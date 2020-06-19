#![allow(clippy::missing_safety_doc, clippy::not_unsafe_ptr_arg_deref)]

use allo_isolate::Isolate;
use ffi_helpers::null_pointer_check;
use std::{ffi::CStr, os::raw, ptr};
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
        .enable_all()
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
pub extern "C" fn load_page(runtime: RuntimePtr, url: *const raw::c_char, port_id: i64) -> i32 {
    null_pointer_check!(runtime);
    null_pointer_check!(url);
    let url = unsafe { cstr!(url) };
    let rt = unsafe { &mut *(runtime as *mut Runtime) };
    let _ = rt.spawn(run_load_page(url, port_id));
    1
}

async fn run_load_page(url: &str, port: i64) {
    let result = scrap::load_page(url).await;
    let isolate = Isolate::new(port);
    isolate.post(result);
}
