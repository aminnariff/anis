import 'package:flutter/material.dart';

class ButtonIdProvider with ChangeNotifier {
  String? _buttonId1;
  String? _buttonId2;

  String? get buttonId1 => _buttonId1;
  String? get buttonId2 => _buttonId2;

  set buttonId1(String? id) {
    _buttonId1 = id;
    notifyListeners();
  }

  set buttonId2(String? id2) {
    _buttonId2 = id2;
    notifyListeners();
  }
}
