import 'dart:io';
import 'package:software_cup_web/token/interface.dart';

class CookieManager with TokenManagerMixin {
  @override
  void setToken(String? token) {
    super.setToken(token);
    final file = File('token');
    if (token == null) {
      file.delete();
      return;
    }
    // write token to file
    file.writeAsString(token);
  }

  @override
  String? initToken() {
    if (!File('token').existsSync()) {
      return null;
    }
    return File('token').readAsStringSync();
  }
}
