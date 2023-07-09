import 'package:flutter/foundation.dart';

final themeNotifier = ThemeNotifier();

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  void changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
