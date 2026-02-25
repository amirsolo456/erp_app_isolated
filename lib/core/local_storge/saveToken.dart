// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_core/index.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(prefix0.LoginRequest token) async {
  final prefs = await SharedPreferences.getInstance();

  var jsonString = jsonEncode(token.toJson());
  await prefs.setString('user_token', jsonString);

  print('TOKEN SAVED IN SHAREDPREFERENCES');
}
