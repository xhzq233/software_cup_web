import 'package:software_cup_web/token/interface.dart';
import 'html_token_get.dart'
if (dart.library.io) 'io_token_get.dart' as token_get;

final TokenManagerMixin tokenManager = token_get.CookieManager();