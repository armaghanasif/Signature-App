import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Offset> points = [];

  Color selectedColor = Colors.black;
  double strokeWidth = 1;

  @override
  void initState() {
    super.initState();
    selectedColor = selectedColor;
    strokeWidth = 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;

    void selectColor() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Choose Color"),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(138, 35, 138, 1.0),
                Color.fromRGBO(233, 64, 87, 1.0),
                Color.fromRGBO(242, 113, 33, 1.0),
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.78,
                width: width * 0.78,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onPanDown: (details) {
                    setState(() {
                      points.add(details.localPosition);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      points.add(details.localPosition);
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      points.add(Offset.infinite);
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomPaint(
                      painter: MyCustomPainter(
                          points: points,
                          color: selectedColor,
                          strokeWidth: strokeWidth),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: width * 0.80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        selectColor();
                      },
                      icon: Icon(
                        Icons.color_lens,
                        color: selectedColor,
                      ),
                    ),
                    Expanded(
                        child: Slider(
                      min: 0,
                      max: 10,
                      activeColor: selectedColor,
                      value: strokeWidth,
                      onChanged: (value) {
                        setState(() {
                          strokeWidth = value;
                        });
                      },
                    )),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          points.clear();
                        });
                      },
                      icon: const Icon(Icons.layers_clear),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class MyCustomPainter extends CustomPainter {
  List<Offset> points;
  Color color;
  double strokeWidth;
  MyCustomPainter(
      {required this.points, required this.color, required this.strokeWidth});
  @override
  void paint(Canvas canvas, size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint();
    paint.color = color;
    paint.strokeWidth = strokeWidth;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;
    canvas.drawRect(rect, background);
    for (var i = 0; i < points.length - 1; i++) {
      // ignore: unnecessary_null_comparison
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
        // ignore: unnecessary_null_comparison
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
