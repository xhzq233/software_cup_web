import 'dart:html';
import 'package:software_cup_web/token/interface.dart';

class CookieManager with TokenManagerMixin {
  @override
  String? get token {
    if (document.cookie == null) {
      return null;
    }
    if (!document.cookie!.contains('token=')) {
      return null;
    }
    return document.cookie?.replaceFirst('token=', '');
  }

  @override
  void setToken(String? token) {
    if (token == null) {
      // delete cookie
      document.cookie = 'token=; expires=Thu, 01 Jan 1970 00:00:00 UTC';
    } else {
      document.cookie = 'token=$token';
    }
  }
}
