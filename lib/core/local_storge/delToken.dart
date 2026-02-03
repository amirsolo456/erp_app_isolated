// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('');
}
