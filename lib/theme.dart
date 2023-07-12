import 'package:flutter/material.dart';

final themeNotifier = ThemeNotifier();
const useMaterial3 = true;
final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
  useMaterial3: true,
);
final darkTheme = ThemeData.dark(useMaterial3: useMaterial3);

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
