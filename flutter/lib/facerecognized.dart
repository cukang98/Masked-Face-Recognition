import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:login_page_day_23/completecheckin.dart';
import 'package:login_page_day_23/animation/FadeAnimation.dart';

class FaceRecognized extends StatelessWidget {
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('E yyyy/MM/dd KK:mma').format(now);
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Container(color: Colors.green[200], height: 400)),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.6,
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2.3,
                  width: MediaQuery.of(context).size.height / 2.2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(3, 3), // changes position of shadow
                        ),
                      ]),
                  child: Container(
                    padding: EdgeInsets.only(top: 90),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                                "Name",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54),
                              ),
                          Text(
                            "TIN CU KANG\n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 16),
                          ),
                          Text(
                                "Email Address",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54),
                              ),
                          Text(
                            "cukang98@gmail.com\n",
                            style: TextStyle(fontSize: 16,
                            color: Colors.black),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          FadeAnimation(1.3,
                              makeInput(label: "\nPassword", obscureText: true)),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 90,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(15),
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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CompleteCheckIn()));
                },
                color: Colors.yellow,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "Submit",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ),
          ),
          Align(
            child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 50, left: 30),
                child: Text(
                  "Welcome,\nEnter your password\nto proceed.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                )),
          ),
          Align(
            // These values are based on trial & error method
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 30, top: 50),
                padding:
                    EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("close", style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          Align(
              child: Container(
                  padding: EdgeInsets.only(top: 195),
                  alignment: Alignment.topCenter,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/test1.jpg',
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
