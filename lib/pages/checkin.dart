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

class CheckIn extends StatelessWidget {
  GoogleMapController newGoogleMapController;
  Position currentPosition;
  CameraPosition cameraPosition;

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            getMap(),
                            Container(
                                decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54.withOpacity(0.55),
                                  spreadRadius: 35,
                                  blurRadius: 50,
                                  offset: Offset(
                                      0,
                                      -(containerHeight *
                                          0.7)), // changes position of shadow
                                ),
                              ],
                            ))
                          ],
                        ),
                        Container(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.0)),
                            ),
                          ),
                        ),
                      ],
                    ))),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
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
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 10),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
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
                            Icon(
                              Icons.location_on_outlined,
                              size: 30,
                              color: Colors.white,
                            ))),
                    Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: FadeAnimation(
                            1,
                            Text(" Check-in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 30)))),
                  ],
                )),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AppButton(
                              text: "Check In",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckIn()),
                                );
                              },
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              color: Color(0xFFFF6161),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
