import 'package:software_cup_web/token/interface.dart';

class CookieManager with TokenManagerMixin {
  @override
  // TODO: implement token
  String? get token => throw UnimplementedError();

  @override
  String? initToken() {
    throw UnimplementedError();
  }
}
