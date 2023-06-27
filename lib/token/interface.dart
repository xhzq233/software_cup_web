import 'dart:developer';
import 'package:flutter/foundation.dart';

mixin TokenManagerMixin {
  String? get token => _cachedToken;

  String? initToken();

  late String? _cachedToken = initToken();

  bool get isAuthed => token != null;

  @mustCallSuper
  void setToken(String? token) {
    log('setToken: $token');
    _cachedToken = token;
  }
}