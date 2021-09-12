import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? null;
  } 

  Future<bool> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', value);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? null;
  } 

  Future<bool> setUserId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userId', value);
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? null;
  } 

  Future<bool> setUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('name', value);
  }
  
  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? null;
  } 

  Future<bool> setUserEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('email', value);
  }
  Future<String> getUserImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('path') ?? null;
  } 

  Future<bool> setUserImagePath(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('path', value);
  }
  Future<bool> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
 
