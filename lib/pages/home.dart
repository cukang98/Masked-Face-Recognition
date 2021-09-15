import 'package:face_net_authentication/pages/db/database.dart';
import 'package:face_net_authentication/pages/sign-in.dart';
import 'package:face_net_authentication/pages/sign-up.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'utils/animation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;

  String githubURL =
      "https://github.com/MCarlomagno/FaceRecognitionAuth/tree/master";

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlKitService.initialize();

    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  void _launchURL() async => await canLaunch(githubURL)
      ? await launch(githubURL)
      : throw 'Could not launch $githubURL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: PopupMenuButton<String>(
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Clear DB':
                    _dataBaseService.cleanDB();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Clear DB'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      drawer:Drawer(),
      body: !loading
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Welcome",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 27),
                        )),
                    FadeAnimation(
                      1.2,
                      Center(
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
                              child: Text(
                                  'Automatic identity verification with face recognition which enables you to verify your identity',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 14)))),
                    ),
                    FadeAnimation(
                        1.4,
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/logo.png'))),
                        )),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignIn(
                                  cameraDescription: cameraDescription,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignUp(
                                  cameraDescription: cameraDescription,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0),
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFFFF6161),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: (TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 14)
                                   )
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
