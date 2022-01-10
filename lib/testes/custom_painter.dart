import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';

class CustomPainterOnImage extends StatefulWidget {
  const CustomPainterOnImage({Key? key}) : super(key: key);

  @override
  _CustomPainterOnImageState createState() => _CustomPainterOnImageState();
}

class _CustomPainterOnImageState extends State<CustomPainterOnImage> {
  List<Lines> points = [];
  List<Lines> pointsConfirmed = [];
  late Lines currentLine;

  bool isYellow = true;
  bool isInvasion = false;

  String imagePath = "";

  late Color selectedColor;
  late double strokeWidth;

  Offset? _lastPoint;

  void pickUpImage() {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.camera).then((image) {
      setState(() {
        imagePath = image!.path;
      });
    });
  }

  void selectColor() {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text("Select Color"),
    //       content: SingleChildScrollView(
    //         child: BlockPicker(
    //           pickerColor: selectedColor,
    //           onColorChanged: (color) {
    //             selectedColor = color;
    //           },
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: Text('Fechar'),
    //         )
    //       ],
    //     );
    //   },
    // );

    setState(() {
      isYellow = !isYellow;
      selectedColor = isYellow ? Colors.yellow : Colors.red;
    });
  }

  void setInvasion() {
    setState(() {
      isInvasion = !isInvasion;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.yellow;
    strokeWidth = 2.0;
    currentLine = Lines(
        start: null, end: null, color: selectedColor, isInvasor: isInvasion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter on Image'),
        actions: [
          IconButton(onPressed: pickUpImage, icon: const Icon(Icons.camera_alt))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imagePath.isNotEmpty
              ? Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.80,
                    width: MediaQuery.of(context).size.width * 0.80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onPanDown: (details) {
                        setState(() {
                          currentLine = Lines(
                              start: details.localPosition,
                              end: null,
                              color: selectedColor,
                              isInvasor: isInvasion);
                          currentLine.isDrawed = false;
                          points.add(currentLine); // end null
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          currentLine.end = details.localPosition;
                          points.add(currentLine);
                          print(points);
                          // _lastPoint = details.localPosition;
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          currentLine.isDrawed = true;
                          points.add(currentLine);
                          pointsConfirmed.add(currentLine);

                          // points.add(null);
                          // print(points);
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomPaint(
                          painter: MyCustomPainer(points, pointsConfirmed,
                              selectedColor, strokeWidth),
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text('Tire uma foto'),
                ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: selectColor,
                  icon: Icon(
                    Icons.color_lens,
                    color: selectedColor,
                  ),
                ),
                IconButton(
                  onPressed: setInvasion,
                  icon: Icon(
                    Icons.crop_square,
                    color: isInvasion ? Colors.green : Colors.black,
                  ),
                ),
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 7.0,
                    activeColor: selectedColor,
                    value: strokeWidth,
                    onChanged: (value) {
                      setState(() {
                        strokeWidth = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      pointsConfirmed.clear();
                      points.clear();
                    });
                  },
                  icon: Icon(
                    Icons.layers_clear_sharp,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomPainer extends CustomPainter {
  // final List<Offset?> points;
  List<Lines> pointsDrawed;
  List<Lines> points;
  final Color selectedColor;
  final double strokeWidth;

  MyCustomPainer(
      this.points, this.pointsDrawed, this.selectedColor, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.transparent;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    Paint paint = Paint();
    paint.strokeWidth = strokeWidth;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;

    for (int x = 0; x < points.length - 1; x++) {
      if (pointsDrawed.isNotEmpty) {
        for (var item in pointsDrawed) {
          paint.color = item.isInvasor ? Colors.green : item.color;

          if (item.isInvasor) {
            final teste = Rect.fromPoints(item.start!, item.end!);
            canvas.drawRect(teste, paint);
          } else {
            canvas.drawLine(item.start!, item.end!, paint);
          }
        }
      }

      if (points[x].isDrawed == false &&
          points[x].start != null &&
          points[x].end != null) {
        // paint.color = points[x].color;
        paint.color = points[x].isInvasor ? Colors.green : points[x].color;

        if (points[x].isInvasor) {
          final teste = Rect.fromPoints(points[x].start!, points[x].end!);
          canvas.drawRect(teste, paint);
        } else {
          canvas.drawLine(points[x].start!, points[x].end!, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Lines {
  Offset? start;
  Offset? end;
  bool isDrawed = false;
  Color color;
  bool isInvasor = false;

  Lines({
    this.start,
    this.end,
    required this.color,
    this.isDrawed = false,
    this.isInvasor = false,
  });
}
