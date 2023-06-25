import 'dart:io';
import 'package:software_cup_web/token/interface.dart';

class CookieManager with TokenManagerMixin {
  @override
  String? get token {
    if (!File('token').existsSync()) {
      return null;
    }
    return File('token').readAsStringSync();
  }

  @override
  void setToken(String token) {
    // write token to file
    File('token').writeAsString(token);
  }
}
