import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'animation/FadeAnimation.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart' as imglib;

class FaceImage extends StatefulWidget {
  @override
  _FaceImageState createState() => _FaceImageState();
}

class _FaceImageState extends State<FaceImage> {
  File _image;
  final imagePicker = ImagePicker();
  var interpreter;

  // For picking image from Gallery
  Future loadImageGallery() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) _waitingSnack(context);
    bool faceFound = await detectFace(File(image.path));
    setState(() {
      // ignore: unrelated_type_equality_checks
      if (faceFound) {
        _image = File(image.path);
      }
    });
  }

  // For picking image from Camera
  Future loadImageCamera() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    if (image != null) _waitingSnack(context);
    bool faceFound = await detectFace(File(image.path));
    setState(() {
      if (faceFound) {
        _image = File(image.path);
      }
    });
  }

  Future<bool> detectFace(final fileImage) async {
    Face _face;
    bool faceFound = false;
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(fileImage);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    final List<Face> faces = await faceDetector.processImage(visionImage);
    // ignore: deprecated_member_use
    print(faces.length);
    if (faces.length == 0 || faces.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid image, Please try again"),
      ));
    } else {
      faceFound = true;
      for (_face in faces) {
        double x, y, w, h;
        x = (_face.boundingBox.left - 10);
        y = (_face.boundingBox.top - 10);
        w = (_face.boundingBox.width + 10);
        h = (_face.boundingBox.height + 10);
        imglib.Image croppedImage = imglib.copyCrop(
            (imglib.decodeJpg(fileImage.readAsBytesSync())),
            x.round(),
            y.round(),
            w.round(),
            h.round());
        croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
        print(croppedImage);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Image loaded successfully"),
        ));
      }
    }
    return faceFound;
  }

  void alertDialog(BuildContext context) {
    var alert = AlertDialog(
      title: Text("Remove Photo"),
      content: Text("Do you want to remove this photo?"),
      actions: [
        FlatButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              setState(() {});
            }),
        FlatButton(
            child: Text("Yes"),
            onPressed: () {
              _image = null;
              Navigator.of(context, rootNavigator: true).pop('dialog');
              setState(() {});
            }),
      ],
      elevation: 24.0,
      backgroundColor: Colors.white,
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 200,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Face Photo Required",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "We need your face photo to train our application, so next time it will recognize you",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      )),
                  FadeAnimation(
                      1.2,
                      AvatarGlow(
                        glowColor: Colors.blue,
                        endRadius: 140.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Material(
                          elevation: 25.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            child: _image == null
                                ? Image.asset(
                                    'assets/face.png',
                                    height: 170,
                                  )
                                : GestureDetector(
                                    child: InkWell(
                                        onTap: () => alertDialog(context),
                                        child: CircleAvatar(
                                            radius: (150),
                                            backgroundColor: Colors.grey[100],
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                              child: Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                                width: 200,
                                                height: 200,
                                              ),
                                            )))),
                            radius: 120.0,
                          ),
                        ),
                      ))
                ],
              ),
              FadeAnimation(
                  1.5,
                  Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: loadImageGallery,
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Select From Phone Gallery",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  )),
              FadeAnimation(
                  1.5,
                  Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: loadImageCamera,
                      color: Colors.yellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Take Photo From Camera",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future _waitingSnack(BuildContext context) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: new Row(
      children: <Widget>[
        new CircularProgressIndicator(),
        new Text("    Please wait...")
      ],
    )));
  }
}
