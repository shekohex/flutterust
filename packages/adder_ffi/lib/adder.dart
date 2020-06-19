import 'ffi.dart' as ffi;

class Adder {
  int add(int a, int b) {
    return ffi.add(a, b);
  }
}
