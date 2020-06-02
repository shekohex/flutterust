#![allow(non_camel_case_types, unused)]
use std::os::raw;

/// A port is used to send or receive inter-isolate messages
pub type DartPort = i64;
#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct _DartWeakPersistentHandle {
    _unused: [u8; 0],
}

pub type DartWeakPersistentHandle = *mut _DartWeakPersistentHandle;

pub type DartWeakPersistentHandleFinalizer = Option<
    unsafe extern "C" fn(
        isolate_callback_data: *mut raw::c_void,
        handle: DartWeakPersistentHandle,
        peer: *mut raw::c_void,
    ),
>;
#[repr(i32)]
#[derive(Copy, Clone, PartialEq, Debug)]
pub enum DartTypedDataType {
    kByteData = 0,
    kInt8 = 1,
    kUint8 = 2,
    kUint8Clamped = 3,
    kInt16 = 4,
    kUint16 = 5,
    kInt32 = 6,
    kUint32 = 7,
    kInt64 = 8,
    kUint64 = 9,
    kFloat32 = 10,
    kFloat64 = 11,
    kFloat32x4 = 12,
    kInvalid = 13,
}

/// A Dart_CObject is used for representing Dart objects as native C
/// data outside the Dart heap. These objects are totally detached from
/// the Dart heap. Only a subset of the Dart objects have a
/// representation as a Dart_CObject.
///
/// The string encoding in the 'value.as_string' is UTF-8.
///
/// All the different types from dart:typed_data are exposed as type
/// kTypedData. The specific type from dart:typed_data is in the type
/// field of the as_typed_data structure. The length in the
/// as_typed_data structure is always in bytes.
///
/// The data for kTypedData is copied on message send and ownership remains with
/// the caller. The ownership of data for kExternalTyped is passed to the VM on
/// message send and returned when the VM invokes the
/// Dart_WeakPersistentHandleFinalizer callback; a non-NULL callback must be
/// provided.
#[repr(i32)]
#[derive(Copy, Clone, PartialEq)]
pub enum DartCObjectType {
    DartNull = 0,
    DartBool = 1,
    DartInt32 = 2,
    DartInt64 = 3,
    DartDouble = 4,
    DartString = 5,
    DartArray = 6,
    DartTypedData = 7,
    DartExternalTypedData = 8,
    DartSendPort = 9,
    DartCapability = 10,
    DartUnsupported = 11,
    DartNumberOfTypes = 12,
}

#[repr(C)]
#[derive(Copy, Clone)]
pub struct DartCObject {
    pub type_: DartCObjectType,
    pub value: DartCObjectValue,
}

#[repr(C)]
#[derive(Copy, Clone)]
pub union DartCObjectValue {
    pub as_bool: bool,
    pub as_int32: i32,
    pub as_int64: i64,
    pub as_double: f64,
    pub as_string: *mut raw::c_char,
    pub as_send_port: DartSendPort,
    pub as_capability: DartCapability,
    pub as_array: DartArray,
    pub as_typed_data: DartTypedData,
    pub as_external_typed_data: DartExternalTypedData,
    _bindgen_union_align: [u64; 5usize],
}

#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct DartSendPort {
    pub id: DartPort,
    pub origin_id: DartPort,
}

#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct DartCapability {
    pub id: i64,
}

#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct DartArray {
    pub length: isize,
    pub values: *mut *mut DartCObject,
}

#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct DartTypedData {
    pub type_: DartTypedDataType,
    pub length: isize,
    pub values: *mut u8,
}

#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct DartExternalTypedData {
    pub type_: DartTypedDataType,
    pub length: isize,
    pub data: *mut u8,
    pub peer: *mut raw::c_void,
    pub callback: DartWeakPersistentHandleFinalizer,
}

///  Posts a message on some port. The message will contain the
///  Dart_CObject object graph rooted in 'message'.
///
///  While the message is being sent the state of the graph of
///  Dart_CObject structures rooted in 'message' should not be accessed,
///  as the message generation will make temporary modifications to the
///  data. When the message has been sent the graph will be fully
///  restored.
///
///  port_id The destination port.
///  message The message to send.
///
///  return true if the message was posted.
pub type DartPostCObjectFnPtr =
    unsafe extern "C" fn(port_id: DartPort, message: *mut DartCObject) -> bool;
