import 'dart:ffi';
import 'dart:io' show Platform;

typedef add_func = Int64 Function(Int64 a, Int64 b);
typedef Add = int Function(int a, int b);

DynamicLibrary load({String basePath = ''}) {
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('${basePath}libadder_ffi.so');
  } else if (Platform.isIOS) {
    return DynamicLibrary.process();
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('${basePath}libadder_ffi.dylib');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('${basePath}libadder_ffi.dll');
  } else {
    throw NotSupportedPlatform('${Platform.operatingSystem} is not supported!');
  }
}

class NotSupportedPlatform implements Exception {
  NotSupportedPlatform(String s);
}

class Adder {
  static DynamicLibrary _lib;
  Adder() {
    if (_lib != null) return;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _lib = load(basePath: '../../../target/debug/');
    } else {
      _lib = load();
    }
  }

  int add(int a, int b) {
    final addPointer = _lib.lookup<NativeFunction<add_func>>('add');
    final sum = addPointer.asFunction<Add>();
    return sum(a, b);
  }
}
