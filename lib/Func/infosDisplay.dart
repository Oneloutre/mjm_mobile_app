import 'package:shared_preferences/shared_preferences.dart';

import '../loginHandler/connection.dart' as connection;
import 'package:flutter/material.dart';

Future InfosDisplay() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String username = prefs.getString('username') ?? '';
  String password = prefs.getString('password') ?? '';
  String nameFirstname = prefs.getString('name_firstname') ?? '';
  connection.Data Connection_Result = await connection.authentication(username, password);

  var response = Connection_Result.response;

  return Connection_Result;

}