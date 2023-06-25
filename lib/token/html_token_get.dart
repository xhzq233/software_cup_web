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
  void setToken(String token) {
    document.cookie = 'token=$token';
  }
}
