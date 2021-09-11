import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'animation/FadeAnimation.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as imglib;
import 'utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:quiver/collection.dart';

class FaceImage extends StatefulWidget {
  @override
  _FaceImageState createState() => _FaceImageState();
}

class _FaceImageState extends State<FaceImage> {
  File _image;
  double threshold = 1.0;
  final imagePicker = ImagePicker();
  var interpreter;
  dynamic data = {};
  List e1;
  CameraLensDirection _direction = CameraLensDirection.front;
  Directory tempDir;
  String _embPath;
  File jsonFile;
  // For picking image from Gallery
  Future loadImageGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
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
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) _waitingSnack(context);
    bool faceFound = await detectFace(File(image.path));
    setState(() {
      if (faceFound) {
        _image = File(image.path);
      }
    });
  }

  Future<bool> detectFace(final fileImage) async {
    tempDir = await getApplicationDocumentsDirectory();
    _embPath = tempDir.path + '/emb.json';
    jsonFile = new File(_embPath);
    if (jsonFile.existsSync()) data = json.decode(jsonFile.readAsStringSync());

    Face _face;

    bool faceFound = false;
    String res;
    dynamic finalResult = Multimap<String, Face>();
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(fileImage);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    final List<Face> faces = await faceDetector.processImage(visionImage);
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
            (imglib.decodeJpg(fileImage.readAsBytesSync())), x.round(), y.round(), w.round(), h.round());
        croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
        res = _recog(croppedImage);
        finalResult.add(res, _face);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Image loaded successfully"),
        ));
      }
    }
    return faceFound;
  }

  void handleSave() async {
    if (_image != null) {
      jsonFile.writeAsStringSync(json.encode(data));
    }
  }
  String _recog(imglib.Image img) {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = [(1 * 192)].reshape([1, 192]);
    interpreter.run(input, output);
    output = output.reshape([192]);
    e1 = List.from(output);
    return compare(e1).toUpperCase();
  }

  String compare(List currEmb) {
    if (data.length == 0) return "No Face saved";
    double minDist = 999;
    double currDist = 0.0;
    String predRes = "NOT RECOGNIZED";
    for (String label in data.keys) {
      currDist = euclideanDistance(data[label], currEmb);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predRes = label;
      }
    }
    print(minDist.toString() + " " + predRes);
    return predRes;
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

  imglib.Image _convertCameraImage(
      CameraImage image, CameraLensDirection _dir) {
    int width = image.width;
    int height = image.height;
    var img = imglib.Image(width, height);
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = (_dir == CameraLensDirection.front)
        ? imglib.copyRotate(img, -90)
        : imglib.copyRotate(img, 90);
    return img1;
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
