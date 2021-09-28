import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:image_picker/image_picker.dart';
import 'rounded_button.dart';
import 'package:tflite/tflite.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class GalleryScreen extends StatefulWidget {
  //const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  File? _image;
  ImagePicker imagePicker = ImagePicker();
  String result = '';

  void initState() {
    super.initState();
    imagePicker = ImagePicker();
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

  Future<void> chooseImageFromGallery() async {
    final PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
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
                image: AssetImage('images/Tiger.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
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
                                  Icons.image,
                                  size: 60,
                                  color: Colors.black,
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
                  title: 'Select Image',
                  color: Colors.indigoAccent,
                  onPressed: () {
                    chooseImageFromGallery();
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
