import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:isolate/ports.dart';

import 'ffi.dart' as native;

class Scrap {
  static final Pointer _rt = native.setupRuntime(NativeApi.postCObject);
  Future<String> loadPage(String url) {
    var urlPointer = Utf8.toUtf8(url);
    final completer = Completer<String>();
    final sendPort = singleCompletePort(completer);

    final res = native.loadPage(
      _rt,
      urlPointer,
      sendPort.nativePort,
    );
    if (res != 1) {
      _throwError();
    }
    return completer.future;
  }

  void dispose() {
    assert(_rt != null);
    native.destroyRuntime(_rt);
  }

  void _throwError() {
    final length = native.lastErrorLength();
    final Pointer<Utf8> message = allocate(count: length);
    native.errorMessageUtf8(message, length);
    final error = Utf8.fromUtf8(message);
    print(error);
    throw error;
  }
}
