import 'package:flutter/material.dart';
import 'package:login_page_day_23/animation/FadeAnimation.dart';
import 'package:login_page_day_23/getfaceimg.dart';

Pattern pattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp emailregex = new RegExp(pattern);
bool validEmail = false;
bool passwordIsEmpty = false;
String ht, et1, et2, et3, et4 = '';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/signupbg.png'),
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          )),
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Create an account, It's free",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1.2, makeEmailInput(label: "Email", node: node)),
                  FadeAnimation(
                      1.3,
                      makePasswordInput(
                          label: "Password", obscureText: true, node: node)),
                  FadeAnimation(
                      1.4,
                      makeConfirmPasswordInput(
                          label: "Confirm Password",
                          obscureText: true,
                          node: node)),
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FaceImage()));
                      },
                      color: Colors.yellow,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )),
              FadeAnimation(
                  1.6,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      Text(
                        " Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

Widget makeEmailInput({label, obscureText = false, node}) {
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
      TextFormField(
        onChanged: (text) {
          if (emailregex.hasMatch(text)) {
            validEmail = true;
          } else {
            validEmail = false;
          }
        },
        onEditingComplete: () => node.nextFocus(),
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: validEmail ? null : "Please enter valid email",
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

Widget makePasswordInput({label, obscureText = false, node}) {
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
      TextFormField(
        onChanged: (text) {
          validatePasswordStructure(text);
        },
        onEditingComplete: () => node.nextFocus(),
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: passwordIsEmpty ? ('$et1$et2$et3') : ht,
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

Widget makeConfirmPasswordInput({label, obscureText = false, node}) {
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
      TextFormField(
        onChanged: (text) {},
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

bool validatePasswordStructure(String text) {
  if (text.isNotEmpty) {
    if (text.length <= 8) {
      et1 = "Minimum password length of 8 or more characters\n";
    } else {
      et1 = '';
    }
    if (!text.contains(RegExp(r'[A-Z]'))) {
      et2 = 'Must contain at least 1 uppercase letter\n';
    } else {
      et2 = '';
    }
    if (!text.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      et3 = 'Must contain at least 1 special character\n';
    } else {
      et3 = '';
    }
  } else {
    passwordIsEmpty = true;
    ht = 'Password cannot be empty';
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return true;
  else
    return null;
}
