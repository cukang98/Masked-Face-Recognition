import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/pages/utils/animation.dart';
import 'package:face_net_authentication/pages/utils/assistantmethods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'package:face_net_authentication/pages/db/database.dart';
import 'package:face_net_authentication/pages/verification.dart';
import 'package:camera/camera.dart';

class CheckInSuccess extends StatefulWidget {
  CheckInSuccessState createState() => CheckInSuccessState();
}

class CheckInSuccessState extends State<CheckInSuccess> {
  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();
  CameraDescription cameraDescription;
  bool loading = false;

  GoogleMapController newGoogleMapController;
  Position currentPosition;
  CameraPosition cameraPosition;
  @override
  void initState() {
    super.initState();
    _startUp();
  }

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
    loading = value;
  }

  Future<CameraPosition> currentLocation() async {
    EasyLoading.show();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    cameraPosition = new CameraPosition(target: latLatPosition, zoom: 18);
    return cameraPosition;
  }

  Future<String> currentAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return AssistantMethods.searchCoordinateAddress(position);
  }

  FutureBuilder getMap() {
    return FutureBuilder(
        future: currentLocation(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Future.delayed(Duration(milliseconds: 750), () {
              EasyLoading.dismiss();
            });
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: snapshot.data,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              scrollGesturesEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
            );
          } else
            return Shimmer(
                child: Container(
              color: Colors.grey[300],
            ));
        });
  }

  Widget build(BuildContext context) {
    var containerHeight = MediaQuery.of(context).size.height / 2;
    var containerWidth = MediaQuery.of(context).size.height / 2.5;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('E yyyy/MM/dd KK:mma').format(now);
    return Scaffold(
      body: Stack(
        children: [
          Align(
              child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/checkin_success.jpg'),
                    fit: BoxFit.fill)),
            height: MediaQuery.of(context).size.height,
          )),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                ),
                Container(
                  alignment: Alignment.center,
                  height: containerHeight,
                  width: containerWidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(2, 2), // changes position of shadow
                        ),
                      ]),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        children: [
                          Container(
                              height: containerHeight * 0.5,
                              width: containerWidth,
                              child: Center(
                                  child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: getMap(),
                              ))),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text("Check-in Information",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                "Location",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: FutureBuilder(
                                    future: currentAddress(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData)
                                        return Text(
                                          snapshot.data,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        );
                                      else
                                        return SizedBox();
                                    })
                                // child: Text(
                                //   "sdfsdfjsdfsdjfjsdhfsdgfshdfkhskhdfhksgfgslngjsfljlsgfjfsjljlsfgjlljljljdfghidfhghdfhghdhfghudfhghihhhi",
                                //   style: TextStyle(
                                //       fontSize: 12, color: Colors.black),
                                // ),
                                ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                "Date & Time",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                ),
              ],
            ),
          ),

          // Align(
          //     alignment: Alignment.topCenter,
          //     child: Container(
          //         margin: EdgeInsets.only(top: 30),
          //         width: 380.00,
          //         height: 200,
          //         decoration: new BoxDecoration(
          //           image: new DecorationImage(
          //             image: ExactAssetImage('assets/face_recog.png'),
          //           ),
          //         ))),
          Align(
            // These values are based on trial & error method
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 30, top: 65),
                padding:
                    EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Text("close", style: TextStyle(color: Color(0xFFFF6161))),
              ),
            ),
          ),
          Align(
              // These values are based on trial & error method
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 60, left: 30),
                      child: FadeAnimation(
                          1,
                          Image.asset('assets/tick.png',width: 45,))),
                  Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: FadeAnimation(
                          1,
                          Text("  Success",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30)))),
                ],
              )),
        ],
      ),
    );
  }
}
