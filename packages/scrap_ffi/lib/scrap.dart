import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'ffi.dart' as native;

class Scrap {
  static final Pointer _rt = native.setupRuntime();
  static Completer<String> completer;
  Scrap() {
    completer = Completer();
  }
  Future<String> loadPage(String url) {
    final resolveFP =
        Pointer.fromFunction<Void Function(Pointer<Utf8>)>(_resolve);

    final rejectFP =
        Pointer.fromFunction<Void Function(Pointer<Utf8>)>(_reject);
    final logFP =
        Pointer.fromFunction<Void Function(Pointer<Utf8>)>(native.dartPrint);
    var urlPointer = Utf8.toUtf8(url);
    var res = native.loadPage(
      _rt,
      urlPointer,
      resolveFP,
      rejectFP,
      logFP,
    );
    print(res);
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

void _resolve(Pointer<Utf8> body) {
  print("Resolved!");
  Scrap.completer.complete(Utf8.fromUtf8(body));
}

void _reject(Pointer<Utf8> error) {
  print("Rejected");
  Scrap.completer.completeError(Utf8.fromUtf8(error));
}
