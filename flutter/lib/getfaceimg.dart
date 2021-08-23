import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_page_day_23/animation/FadeAnimation.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page_day_23/login.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tflite/tflite.dart';

class FaceImage extends StatefulWidget {
  @override
  _FaceImageState createState() => _FaceImageState();
}

class _FaceImageState extends State<FaceImage> {
  bool _loading = true;
  File _image;
  final imagePicker = ImagePicker();
  List _predictions = [];
  // For picking image from Gallery
  Future loadImageGallery() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    detectImage(image);
  }

  // For picking image from Camera
  Future loadImageCamera() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    detectImage(image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  // LoadModel() for connection app with TensorFlow Lite
  loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  // Method for Image detection
  Future detectImage(image) async {
    var runModelOnImage = Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    var prediction = await runModelOnImage;
    setState(() {
      _loading = false;
      if (image != null) {
        _image = File(image.path);
        _predictions = prediction;
      } else {
        print('No image selected.');
      }
    });
    setState(() {
      _loading = false;
      _predictions = prediction;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
              _loading = true;
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
        brightness: Brightness.light,
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
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "We need your face photo to train our application, so next time it will recognize you",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                  _loading == true
                      ? Text("")
                      : (Padding(
                          padding: EdgeInsets.only(top:10),
                          child: Text(_predictions[0]['label'].toString().substring(2),
                              style: TextStyle(fontSize: 20)),
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
                            child: _loading == true
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
                      height: 60,
                      onPressed: loadImageGallery,
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Select From Phone Gallery",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
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
                      height: 60,
                      onPressed: loadImageCamera,
                      color: Colors.yellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Take Photo From Camera",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
