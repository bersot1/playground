// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';


// class TextRecognizerPage extends StatefulWidget {
//   const TextRecognizerPage({Key? key}) : super(key: key);

//   @override
//   State<TextRecognizerPage> createState() => _TextRecognizerPageState();
// }

// class _TextRecognizerPageState extends State<TextRecognizerPage> {
//   final ImagePicker? _imagePicker = ImagePicker();

//   late CameraController controller;
//   late List<CameraDescription> _cameras;

//   String? textReconized;

//   bool _canProcess = true;
//   final bool _isBusy = false;
//   CustomPaint? _customPaint;
//   String? _text;
//   File? _image;
//   String? _path;

//   retrieveGCloudInformation() {
//     // Read the service account credentials from the file.
//     var jsonCredentials = File('my-project.json').readAsStringSync();
//     var credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

//     // Get an HTTP authenticated client using the service account credentials.
//     var scopes = [...datastore.Datastore.Scopes, ...Storage.SCOPES, ...PubSub.SCOPES]
        
        
//         ;
//     var client = await auth.clientViaServiceAccount(credentials, scopes);

//     // Instantiate objects to access Cloud Datastore, Cloud Storage
//     // and Cloud Pub/Sub APIs.
//     var db = DatastoreDB(
//         datastore.Datastore(client, 's~my-project'));
//     var storage = Storage(client, 'my-project');
//     var pubsub = PubSub(client, 'my-project');
//   }

//   Future<void> getCameras() async {
//     _cameras = await availableCameras();
//   }

//   Future _getImage(ImageSource source) async {
//     setState(() {
//       _image = null;
//       _path = null;
//       textReconized = null;
//     });
//     final pickedFile = await _imagePicker?.pickImage(source: source);
//     if (pickedFile != null) {
//       // _processPickedFile(pickedFile);
//       _image = File(pickedFile.path);
//     }
//     setState(() {});
//   }

//   Future<void> textReconizer() async {
//     try {
//       final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(_image!);

//       final textRecognizer = GoogleVision.instance.textRecognizer();

//       final VisionText visionText = await textRecognizer.processImage(visionImage);

//       String text = visionText.text!;
//       for (TextBlock block in visionText.blocks) {
//         // final Rect boundingBox = block.boundingBox;
//         // final List<Offset> cornerPoints = block.cornerPoints;
//         // final String text = block.text;
//         // final List<RecognizedLanguage> languages = block.recognizedLanguages;

//         for (TextLine line in block.lines) {
//           // Same getters as TextBlock
//           for (TextElement element in line.elements) {
//             // Same getters as TextBlock
//           }
//         }
//       }

//       textRecognizer.close();
//     } on Exception catch (e) {
//       print(e);
//     }
//     setState(() {});
//   }

//   @override
//   void initState() {
//     getCameras();
//     super.initState();
//   }

//   @override
//   void dispose() async {
//     _canProcess = false;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 100,
//             ),
//             ElevatedButton(onPressed: () => _getImage(ImageSource.gallery), child: const Text('from Galery')),
//             ElevatedButton(onPressed: textReconizer, child: const Text('IDentificar texto')),
//             const SizedBox(
//               height: 100,
//             ),
//             SizedBox(
//               height: 200,
//               width: 200,
//               child: _image != null ? Image.file(_image!) : const Text('Escolha uma imagem'),
//             ),
//             const SizedBox(
//               height: 100,
//             ),
//             if (textReconized != null)
//               Center(
//                 child: Text(textReconized!),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
