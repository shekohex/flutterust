import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

DynamicLibrary load({String basePath = ''}) {
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('${basePath}libscrap_ffi.so');
  } else if (Platform.isIOS) {
    return DynamicLibrary.process();
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('${basePath}libscrap_ffi.dylib');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('${basePath}libscrap_ffi.dll');
  } else {
    throw NotSupportedPlatform();
  }
}

class NotSupportedPlatform extends Error implements Exception {
  NotSupportedPlatform() {
    throw Error();
  }
}

DynamicLibrary dynamicLibrary() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return load(basePath: '../../../target/debug/');
  } else {
    return load();
  }
}

/// Dynamic library
final _dl = dynamicLibrary();

final lastErrorLength = _dl.lookupFunction<Int32 Function(), int Function()>(
  'last_error_length',
);

final errorMessageUtf8 = _dl.lookupFunction<
    Int32 Function(
  Pointer<Utf8>,
  Int32,
),
    int Function(
  Pointer<Utf8>,
  int,
)>(
  'error_message_utf8',
);

final setupRuntime = _dl.lookupFunction<
    Pointer Function(
        Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>),
    Pointer Function(
        Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>)>(
  'setup_runtime',
);

final destroyRuntime = _dl.lookupFunction<
    Void Function(
  Pointer,
),
    void Function(
  Pointer,
)>(
  'destroy_runtime',
);

final loadPage = _dl.lookupFunction<loadPageC, loadPageDart>(
  'load_page',
);
typedef loadPageC = Int32 Function(Pointer, Pointer<Utf8>, Int64);

typedef loadPageDart = int Function(Pointer, Pointer<Utf8>, int);

void dartPrint(Pointer<Utf8> msg) {
  print(Utf8.fromUtf8(msg));
}
