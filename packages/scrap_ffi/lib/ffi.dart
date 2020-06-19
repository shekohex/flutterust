/// bindings for `libscrap`

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart' as ffi;

// ignore_for_file: unused_import, camel_case_types, non_constant_identifier_names
final DynamicLibrary _dl = _open();
DynamicLibrary _open() {
  if (Platform.isAndroid) return DynamicLibrary.open('libscrap_ffi.so');
  if (Platform.isIOS) return DynamicLibrary.executable();
  throw UnsupportedError('This platform is not supported.');
}

/// <p class="para-brief"> Destroy the Tokio Runtime, and return 1 if everything is okay</p>
int destroy_runtime(
  Pointer runtime,
) {
  return _destroy_runtime(runtime);
}

final _destroy_runtime_Dart _destroy_runtime =
    _dl.lookupFunction<_destroy_runtime_C, _destroy_runtime_Dart>(
        'destroy_runtime');
typedef _destroy_runtime_C = Int32 Function(
  Pointer runtime,
);
typedef _destroy_runtime_Dart = int Function(
  Pointer runtime,
);

/// <p class="para-brief"> Setup a new Tokio Runtime and return a pointer to it so it could be used later to run tasks</p>
Pointer setup_runtime() {
  return _setup_runtime();
}

final _setup_runtime_Dart _setup_runtime =
    _dl.lookupFunction<_setup_runtime_C, _setup_runtime_Dart>('setup_runtime');
typedef _setup_runtime_C = Pointer Function();
typedef _setup_runtime_Dart = Pointer Function();

/// C function `load_page`.
int load_page(
  Pointer runtime,
  Pointer<ffi.Utf8> url,
  int port_id,
) {
  return _load_page(runtime, url, port_id);
}

final _load_page_Dart _load_page =
    _dl.lookupFunction<_load_page_C, _load_page_Dart>('load_page');
typedef _load_page_C = Int32 Function(
  Pointer runtime,
  Pointer<ffi.Utf8> url,
  Int64 port_id,
);
typedef _load_page_Dart = int Function(
  Pointer runtime,
  Pointer<ffi.Utf8> url,
  int port_id,
);

/// C function `error_message_utf8`.
int error_message_utf8(
  Pointer<ffi.Utf8> buf,
  int length,
) {
  return _error_message_utf8(buf, length);
}

final _error_message_utf8_Dart _error_message_utf8 =
    _dl.lookupFunction<_error_message_utf8_C, _error_message_utf8_Dart>(
        'error_message_utf8');
typedef _error_message_utf8_C = Int32 Function(
  Pointer<ffi.Utf8> buf,
  Int32 length,
);
typedef _error_message_utf8_Dart = int Function(
  Pointer<ffi.Utf8> buf,
  int length,
);

/// C function `last_error_length`.
int last_error_length() {
  return _last_error_length();
}

final _last_error_length_Dart _last_error_length =
    _dl.lookupFunction<_last_error_length_C, _last_error_length_Dart>(
        'last_error_length');
typedef _last_error_length_C = Int32 Function();
typedef _last_error_length_Dart = int Function();

// THIS ADDED BY ME, dart-bingen has to integrate with `allo-isolate`

/// C function `store_dart_post_cobject`.
Pointer store_dart_post_cobject(
    Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>> ptr) {
  return _store_dart_post_cobject(ptr);
}

final _store_dart_post_cobject = _dl
    .lookupFunction<_store_dart_post_cobject_C, _store_dart_post_cobject_Dart>(
  'store_dart_post_cobject',
);

typedef _store_dart_post_cobject_C = Pointer Function(
    Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>);
typedef _store_dart_post_cobject_Dart = Pointer Function(
    Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>);
