import 'dart:ffi';
import 'dart:io' show Platform;
import 'binding.dart' as binding;

final adder = binding.NativeLibrary(Platform.isAndroid
    ? DynamicLibrary.open("libadder_ffi.so")
    : DynamicLibrary.executable());

class Adder {
  int add(int a, int b) {
    return adder.add(a, b);
  }
}
