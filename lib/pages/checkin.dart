import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class CheckIn extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  
  Widget build(BuildContext context) {
    var containerHeight = MediaQuery.of(context).size.height / 2;
    var containerWidth = MediaQuery.of(context).size.height / 2.5;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('E yyyy/MM/dd KK:mma').format(now);
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    color: Color(0xFFFF6161),
                    height: MediaQuery.of(context).size.height * 0.5)),
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
                                height: containerHeight*0.5,
                                width: containerWidth,
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(0),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      heightFactor: 1,
                                      widthFactor: 1,
                                      child: GoogleMap(
                                        mapType: MapType.normal,
                                        initialCameraPosition: _kGooglePlex,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(controller);
                                          newGoogleMapController = controller;
                                        },
                                        scrollGesturesEnabled: false,
                                        zoomControlsEnabled: false,
                                        zoomGesturesEnabled: false,
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child:Text("Check-in Information",style:TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    "Location",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54),
                                  )),
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  "sdfsdfjsdfsdjfjsdhfsdgfshdfkhskhdfhksgfgslngjsfljlsgfjfsjljlsfgjlljljljdfghidfhghdfhghdhfghudfhghihhhi",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    "Date & Time",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54),
                                  )),
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
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
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 30,
                          color: Colors.white,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Text(" Check-in",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 30))),
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
