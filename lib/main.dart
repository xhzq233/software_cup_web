import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/pages/home/home_page.dart';
import 'package:software_cup_web/pages/login/login_page.dart';
import 'package:software_cup_web/theme.dart';
import 'package:software_cup_web/token/token.dart';
import 'package:flutter/material.dart';

void main() {
  Get.config(defaultTransition: Transition.fadeIn);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/home': (context) => const HomePage(),
      '/login': (context) => const LoginPage(),
    };
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (ctx, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '你所热爱的',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: tokenManager.isAuthed ? '/home' : '/login',
        routes: routes,
        navigatorKey: Get.key,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}
