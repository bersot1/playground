import 'dart:io';
import 'dart:typed_data';

import 'package:tflite/tflite.dart';

class Recognizer {
  Future loadModel() {
    Tflite.close();

    return Tflite.loadModel(
      model: "assets/mnist.tflite",
      labels: "assets/mnist.txt",
    );
  }

  dispose() {
    Tflite.close();
  }

  Future<void> recognize(File file) async {
    Uint8List bytes = file.readAsBytesSync();
    var predict = await Tflite.runModelOnImage(path: file.path);
    print(predict);
  }
}
