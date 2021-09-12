import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class DataBaseService {
  // singleton boilerplate
  static final DataBaseService _cameraServiceService =
      DataBaseService._internal();
  final databaseRef = FirebaseDatabase.instance.reference();
  factory DataBaseService() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  DataBaseService._internal();

  /// Data learned on memory
  Map<String, dynamic> _db = Map<String, dynamic>();
  Map<String, dynamic> get db => this._db;

  /// loads data from real time database
  Future loadDB() async {
    databaseRef.once().then((DataSnapshot snapshot) {
      //print("Data2:"+snapshot.value.toString());
      List <String>users = [];
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        users.add(('{"' + key.toString() + '":' + values.toString()+ "}").toString());
      });
      _db = json.decode((users.join(",")));
    });
  }

  /// [Name]: name of the new user
  /// [Data]: Face representation for Machine Learning model
  Future saveData(String user, String password, List modelData) async {
    String userAndPass = user + ':' + password;
    _db[userAndPass] = modelData;
    databaseRef.child(userAndPass).set(modelData);
  }

  /// deletes the created users
  cleanDB() {
    this._db = Map<String, dynamic>();
    databaseRef.remove();
  }
}
