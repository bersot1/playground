import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playground/testes/number_recognizer_tf/services/recognizer.dart';

import '../models/prediction.dart';

class NumberRecognizerTFPage extends StatefulWidget {
  const NumberRecognizerTFPage({Key? key}) : super(key: key);

  @override
  State<NumberRecognizerTFPage> createState() => _NumberRecognizerTFPageState();
}

class _NumberRecognizerTFPageState extends State<NumberRecognizerTFPage> {
  final ImagePicker? _imagePicker = ImagePicker();
  final recognizer = Recognizer();

  late CameraController controller;

  List<dynamic>? _recognitions;

  final List<Prediction> _prediction = [];

  String? textReconized;
  File? _image;

  late double _imageHeight;
  late double _imageWidth;

  bool busy = false;

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      textReconized = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      // _processPickedFile(pickedFile);
      _image = File(pickedFile.path);
    }
    setState(() {});
  }

  loadModel() async {
    var res = await recognizer.loadModel();
    print(res);
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: busy == true
          ? const CircularProgressIndicator()
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(onPressed: () => _getImage(ImageSource.gallery), child: const Text('from Galery')),
                  ElevatedButton(
                      onPressed: () => recognizer.recognize(_image!), child: const Text('IDentificar texto')),
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: _image != null ? Image.file(_image!) : const Text('Escolha uma imagem'),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  if (textReconized != null)
                    Center(
                      child: Text(textReconized!),
                    )
                ],
              ),
            ),
    );
  }
}
