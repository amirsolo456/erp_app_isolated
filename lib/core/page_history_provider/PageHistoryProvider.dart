// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PageHistoryProvider with ChangeNotifier {
  final List<String> _history = [];

  List<String> get history => _history;

  void addPage(String pageName) {
    _history.add(pageName);
    notifyListeners();
  }
}
