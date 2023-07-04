import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/pages/home/home_page.dart';
import 'package:software_cup_web/pages/login/login_page.dart';
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
    const useMaterial3 = true;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '你所热爱的',
      theme: ThemeData.light(useMaterial3: useMaterial3),
      darkTheme: ThemeData.dark(useMaterial3: useMaterial3),
      initialRoute: tokenManager.isAuthed ? '/home' : '/login',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
      },
      navigatorKey: Get.key,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}
