import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:image_picker/image_picker.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tflite/tflite.dart';
import 'rounded_button.dart';

class CameraScreen extends StatefulWidget {
  static const String id = 'camera_screen';

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  ImagePicker picker = ImagePicker();
  String result = '';

  void initState() {
    super.initState();
    picker = ImagePicker();
    loadModelFiles();
  }

  loadModelFiles() async {
    String? res = await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/mobilenet_v1_1.0_224.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
  }

  doImageClassification() async {
    result = '';
    var recognitions = await Tflite.runModelOnImage(
        path: _image!.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 3,
        threshold: 0.2,
        asynch: true);

    if (recognitions != null) {
      recognitions.forEach((element) {
        result += element['label'] +
            '  ' +
            ((element['confidence'] * 100) as double).toStringAsFixed(0) +
            '%\n';
      });
    }
    setState(() {
      result;
    });
  }

  Future<void> captureImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
      doImageClassification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fish.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              SizedBox(
                width: 100,
              ),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'images/frame.png',
                            height: 280,
                            width: 250,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 175,
                                height: 265,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                width: 140,
                                height: 150,
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              RoundedButton(
                  title: 'Capture Your Image',
                  color: Colors.indigoAccent,
                  onPressed: () {
                    captureImageFromCamera();
                  }),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: GradientText(
                  '$result',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                  gradientType: GradientType.radial,
                  radius: 1,
                  colors: [
                    Colors.cyanAccent,
                    Colors.blueAccent,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
