// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:software_cup_web/token/interface.dart';

class CookieManager with TokenManagerMixin {
  @override
  void setToken(String? token) {
    super.setToken(token);
    if (token == null) {
      // delete cookie
      document.cookie = '';
    } else {
      document.cookie = 'token=$token';
    }
  }

  @override
  String? initToken() {
    if (document.cookie == null) {
      return null;
    }
    if (!document.cookie!.contains('token=')) {
      return null;
    }
    return document.cookie?.replaceFirst('token=', '');
  }
}
