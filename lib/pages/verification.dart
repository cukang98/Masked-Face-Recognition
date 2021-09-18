// A screen that allows users to take a picture using a given camera.
import 'dart:async';
import 'dart:io';
import 'package:face_net_authentication/pages/widgets/FacePainter.dart';
import 'package:face_net_authentication/pages/widgets/auth-action-button.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'package:face_net_authentication/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:face_net_authentication/pages/utils/animation.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Verification extends StatefulWidget {
  final CameraDescription cameraDescription;

  const Verification({
    Key key,
    @required this.cameraDescription,
  }) : super(key: key);

  @override
  VerificationState createState() => VerificationState();
}

class VerificationState extends State<Verification> {
  /// Service injection
  CameraService _cameraService = CameraService();
  MLKitService _mlKitService = MLKitService();
  FaceNetService _faceNetService = FaceNetService();

  Future _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;

  String imagePath;
  Size imageSize;
  Face faceDetected;

  @override
  void initState() {
    super.initState();

    /// starts the camera & start framing faces
    _start();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlKitService.getFacesFromImage(image);

          if (faces != null) {
            print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            if (faces.length > 0) {
              // preprocessing the image
              setState(() {
                faceDetected = faces[0];
              });

              if (_saving) {
                _saving = false;
                _faceNetService.setCurrentPrediction(image, faceDetected);
              }
            } else {
              setState(() {
                faceDetected = null;
              });
            }
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  /// handles the button pressed event
  Future<void> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );

      return false;
    } else {
      _saving = true;

      await Future.delayed(Duration(milliseconds: 500));
      await _cameraService.cameraController.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      XFile file = await _cameraService.takePicture();

      setState(() {
        _bottomSheetVisible = true;
        pictureTaked = true;
        imagePath = file.path;
      });

      return true;
    }
  }

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      cameraInitializated = false;
      pictureTaked = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6161),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Identity Verification",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (pictureTaked) {
                    return Container(
                      width: width,
                      height: height,
                      child: Transform(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.file(File(imagePath)),
                          ),
                          transform: Matrix4.rotationY(mirror)),
                    );
                  } else {
                    return Transform.scale(
                      scale: 1.0,
                      child: AspectRatio(
                        aspectRatio: MediaQuery.of(context).size.aspectRatio,
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: width,
                              height: width *
                                  _cameraService
                                      .cameraController.value.aspectRatio,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  CameraPreview(
                                      _cameraService.cameraController),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcOut,
            ), // This one will create the magic
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ), // This one will handle background + difference out
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    
                    height: MediaQuery.of(context).size.width * 0.6,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width / 2,
                      ),
                      boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              spreadRadius: 1.0,
                              blurRadius: 10.0,
                              offset: Offset(3.0, 3.0))
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.width * 0.15),
                FadeAnimation(
                    1,
                    Text(
                      "Verification",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 30
                          
                          ,
                          color: Color(0xFFFF6161)),
                    )),
                FadeAnimation(
                  1,
                  Center(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                              'Keep your account safe, \nPlease verify your identity.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 16)))),
                ),
              ]),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_bottomSheetVisible
          ? AuthActionButton(
              _initializeControllerFuture,
              onPressed: onShot,
              isLogin: true,
              reload: _reload,
            )
          : Container(),
    );
  }
}
