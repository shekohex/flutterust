import 'dart:async';
import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'binding.dart' as binding;
import 'package:isolate/isolate.dart';

final scrap = binding.NativeLibrary(Platform.isAndroid | Platform.isLinux
    ? DynamicLibrary.open("libscrap_ffi.so")
    : DynamicLibrary.process());

class Scrap {
  static setup() {
    scrap.store_dart_post_cobject(NativeApi.postCObject.address);
    print("Scrap Setup Done");
  }

  Future<String> loadPage(String url) {
    var urlPointer = url.toNativeUtf8().cast<Int8>();
    final completer = Completer<String>();
    final sendPort = singleCompletePort(completer);
    final res = scrap.load_page(
      sendPort.nativePort,
      urlPointer,
    );
    if (res != 1) {
      _throwError();
    }
    return completer.future;
  }

  void _throwError() {
    final length = scrap.last_error_length();
    final Pointer<Int8> message = calloc.allocate(length);
    scrap.error_message_utf8(message, length);
    final error = message.cast<Utf8>().toDartString();
    print(error);
    throw error;
  }
}
