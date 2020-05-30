#![allow(clippy::missing_safety_doc, clippy::not_unsafe_ptr_arg_deref)]

use ffi_helpers::null_pointer_check;
use std::{
    ffi::{CStr, CString},
    os::raw,
    ptr,
};
use tokio::runtime::{Builder, Runtime};

pub type RuntimePtr = *mut raw::c_void;

macro_rules! error {
    ($result:expr) => {
        error!($result, 0);
    };
    ($result:expr, $error:expr) => {
        match $result {
            Ok(value) => value,
            Err(e) => {
                ffi_helpers::update_last_error(e);
                return $error;
            }
        }
    };
}

macro_rules! cstr {
    ($ptr:expr) => {
        cstr!($ptr, 0);
    };
    ($ptr:expr, $error:expr) => {
        error!(CStr::from_ptr($ptr).to_str(), $error)
    };
}

macro_rules! into_cstring_raw {
    ($ptr:expr) => {
        into_cstring_raw!($ptr, ())
    };
    ($ptr:expr, $error:expr) => {
        error!(CString::new($ptr), $error).into_raw()
    };
}

#[no_mangle]
pub unsafe extern "C" fn last_error_length() -> i32 {
    ffi_helpers::error_handling::last_error_length()
}

#[no_mangle]
pub unsafe extern "C" fn error_message_utf8(buf: *mut raw::c_char, length: i32) -> i32 {
    ffi_helpers::error_handling::error_message_utf8(buf, length)
}

/// Setup a new Tokio Runtime and return a pointer to it so it could be used later to run tasks
#[no_mangle]
pub extern "C" fn setup_runtime() -> RuntimePtr {
    // build runtime
    let runtime = Builder::new()
        .threaded_scheduler()
        .core_threads(4)
        .thread_name("flutterust")
        .build();
    let runtime = error!(runtime, ptr::null_mut());
    let boxed_runtime = Box::new(runtime);
    Box::into_raw(boxed_runtime) as RuntimePtr
}

/// Destroy the Tokio Runtime, and return 1 if everything is okay
#[no_mangle]
pub unsafe extern "C" fn destroy_runtime(runtime: RuntimePtr) -> i32 {
    null_pointer_check!(runtime);
    Box::from_raw(runtime);
    1
}

#[no_mangle]
pub extern "C" fn load_page(
    runtime: RuntimePtr,
    url: *const raw::c_char,
    resolve: fn(*mut raw::c_char) -> (),
    reject: fn(*mut raw::c_char) -> (),
    log: fn(*mut raw::c_char) -> (),
) -> i32 {
    null_pointer_check!(runtime);
    null_pointer_check!(url);
    let url = unsafe { cstr!(url) };
    (log)(into_cstring_raw!(url, 0));
    let rt = unsafe { &mut *(runtime as *mut Runtime) };
    let _ = rt.spawn(run_load_page(url, resolve, reject));
    1
}

async fn run_load_page(
    url: &str,
    resolve: fn(*mut raw::c_char) -> (),
    reject: fn(*mut raw::c_char) -> (),
) {
    let result = scrap::load_page(url).await;
    match result {
        Ok(body) => (resolve)(into_cstring_raw!(body)),
        Err(e) => (reject)(into_cstring_raw!(e.to_string())),
    };
}
