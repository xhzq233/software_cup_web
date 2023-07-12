import 'package:flutter/material.dart';

final themeNotifier = ThemeNotifier();
const useMaterial3 = true;
final lightTheme = ThemeData.light(useMaterial3: useMaterial3);
final darkTheme = ThemeData.dark(useMaterial3: useMaterial3);

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  void changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
