import 'dart:convert';
import 'package:face_net_authentication/pages/utils/prefs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

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
      List<String> users = [];
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key.toString().contains(":"))
          users.add(('{"' + key.toString() + '":' + values.toString() + "}")
              .toString());
      });
      _db = json.decode((users.join(",")));
      return json.decode((users.join(",")));
    });
    return _db;
  }

  /// [Name]: name of the new user
  /// [Data]: Face representation for Machine Learning model
  Future saveData(String user, String password, List modelData) async {
    String userAndPass = user + ':' + password;
    _db[userAndPass] = modelData;
    databaseRef.child(userAndPass).set(modelData);
  }

  void saveLocation(String email, double lt, double lg, String address) {
    DateTime now = DateTime.now();
    String emailBase64 = base64.encode(utf8.encode(email));
    String formattedDate = DateFormat('E yyyy/MM/dd KK:mma').format(now);
    List data;
        databaseRef
        .child(emailBase64)
        .push()
        .set({"address": address, "lt": lt, "lg": lg, "date": formattedDate});
  }

  /// deletes the created users
  cleanDB() {
    this._db = Map<String, dynamic>();
    databaseRef.remove();
  }

}
