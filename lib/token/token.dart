import 'package:software_cup_web/token/interface.dart';
import 'package:get/get.dart';
import 'mock.dart'
if (dart.library.html) 'html_token_get.dart'
if (dart.library.io) 'io_token_get.dart' as token_get;

final TokenManagerMixin tokenManager = token_get.CookieManager();
final get111 = Get;