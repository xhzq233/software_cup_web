import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/pages/home/home_page.dart';
import 'package:software_cup_web/pages/login/login_page.dart';
import 'package:software_cup_web/token/token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.lazyPut(() => UnAuthAPIProvider());
  Get.lazyPut(() => AuthedAPIProvider());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const useMaterial3 = true;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '你所热爱的',
      theme: ThemeData.light(useMaterial3: useMaterial3),
      darkTheme: ThemeData.dark(useMaterial3: useMaterial3),
      initialRoute: tokenManager.isAuthed ? '/home' : '/login',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
