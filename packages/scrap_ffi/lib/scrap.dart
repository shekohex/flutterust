import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:isolate/ports.dart';

import 'ffi.dart' as native;

class Scrap {
  static setup() {
    native.store_dart_post_cobject(NativeApi.postCObject);
    print("Scrap Setup Done");
  }

  Future<String> loadPage(String url) {
    var urlPointer = Utf8.toUtf8(url);
    final completer = Completer<String>();
    final sendPort = singleCompletePort(completer);
    final res = native.load_page(
      sendPort.nativePort,
      urlPointer,
    );
    if (res != 1) {
      _throwError();
    }
    return completer.future;
  }

  void _throwError() {
    final length = native.last_error_length();
    final Pointer<Utf8> message = allocate(count: length);
    native.error_message_utf8(message, length);
    final error = Utf8.fromUtf8(message);
    print(error);
    throw error;
  }
}
