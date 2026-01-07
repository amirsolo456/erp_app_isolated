// ignore_for_file: file_names

import 'dart:convert';

import 'package:shared_core/index.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';

Future<prefix0.LoginRequest?> getToken() async {
  final prefs = await SharedPreferences.getInstance();

  var jsonString = prefs.getString('user_token');

  if (jsonString == null) return null;

  return prefix0.LoginRequest.fromJson(jsonDecode(jsonString));
}
