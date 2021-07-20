import 'dart:html';

import 'package:jsqr/jsqr.dart';

class BarcodeWorker {
  DedicatedWorkerGlobalScope dws = DedicatedWorkerGlobalScope.instance;

  late MessagePort port;

  BarcodeWorker() {
    dws.importScripts('https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js');
    dws.onMessage.listen((e) {
      if (e.data?['port'] != null) {
        port = e.data['port'];
      } else {
        final start = DateTime.now();
        final code = jsQR(e.data['imageData'], e.data['width'], e.data['height']);
        print('[Worker] w: ${e.data['width']}, h: ${e.data['height']}, took ${DateTime.now().difference(start).inMilliseconds} ms.');
        print('[Worker] result: ${code?.data}');
        port.postMessage({'data': code?.data});
      }
    });
  }
}

void main() {
  BarcodeWorker();
}