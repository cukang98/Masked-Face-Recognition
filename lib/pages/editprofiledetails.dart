import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

var title;

class EditProfileDetail extends StatefulWidget {
  final String title;
  final bool isPassword;
  EditProfileDetail(this.title,this.isPassword);
  _EditProfileDetailState createState() => _EditProfileDetailState();
}

class _EditProfileDetailState extends State<EditProfileDetail> {
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
            !widget.isPassword ? 'Edit ' + this.widget.title : widget.title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  onChanged: (text) {
                    setState(() {});
                  },
                  controller: _textController,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      suffixIcon: _textController.text.length > 0
                          ? IconButton(
                              onPressed: () {
                                _textController.clear();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                                size: 18,
                              ))
                          : null),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: _printInfo(widget.title),
              )
            ],
          ),
        ));
  }

  Widget _printInfo(String title) {
    switch (title) {
      case ("Full Name"):
        return Text("Maximum of 100 characters",
            style: TextStyle(color: Colors.grey, fontSize: 12));
        break;
      case ("Email"):
        return Text("adfsdf",
            style: TextStyle(color: Colors.grey, fontSize: 12));
        break;
    }
  }
}
