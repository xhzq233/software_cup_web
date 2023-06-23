import 'dart:ui';
import 'package:analyze_sys_web/http_api/http_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum LoginLayoutState {
  login,
  register,
  forget,
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final state = LoginLayoutState.login.obs;
  final UnAuthAPIProvider api = Get.find();

  void forget() {}

  void register() {
    api.register(nameController.text, passwordController.text).then((resp) {
      if (resp.statusCode == 200) {
        Get.snackbar('注册成功', '请登录');
        toLogin();
      } else if (resp.statusCode == 409) {
        Get.snackbar('注册失败', '用户名已存在');
      } else {
        Get.snackbar('注册失败', '未知错误');
      }
    });
  }

  void login() {
    api.login(nameController.text, passwordController.text).then((resp) {
      if (resp.statusCode == 200) {
        final token = resp.body['token'];
        Get.lazyPut(() => AuthedProvider(token));
        Get.snackbar('登录成功', '欢迎回来');
        Get.offAllNamed('/');
      } else if (resp.statusCode == 401) {
        Get.snackbar('登录失败', '用户名或密码错误');
      } else {
        Get.snackbar('登录失败', '未知错误');
      }
    });
  }

  void toForget() {
    state(LoginLayoutState.forget);
  }

  void toRegister() {
    state(LoginLayoutState.register);
  }

  void toLogin() {
    state(LoginLayoutState.login);
  }

  Widget _obxBuilder() {
    final textTheme = Theme.of(context).textTheme;
    final children = <Widget>[Text('平台登录', style: textTheme.titleLarge)];

    if (state() == LoginLayoutState.login) {
      children.addAll([
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: '用户名',
            prefixIcon: Icon(Icons.person),
            hintText: '请输入用户名',
          ),
        ),
        TextField(
          obscureText: true,
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: '密码',
            prefixIcon: Icon(Icons.lock),
            hintText: '请输入密码',
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: toRegister,
              child: const Text('注册'),
            ),
            TextButton(
              onPressed: toForget,
              child: const Text('忘记密码'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: login,
          child: const SizedBox(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '登录',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ]);
    } else if (state() == LoginLayoutState.forget) {
      children.addAll([
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: '用户名',
            prefixIcon: Icon(Icons.person),
            hintText: '请输入用户名',
          ),
        ),
        TextField(
          obscureText: true,
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: '新密码',
            prefixIcon: Icon(Icons.lock),
            hintText: '请输入新密码',
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: toRegister,
              child: const Text('注册'),
            ),
            TextButton(
              onPressed: toLogin,
              child: const Text('登录'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: forget,
          child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '更改密码',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )),
        ),
        const SizedBox(height: 16),
      ]);
    } else {
      children.addAll([
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: '用户名',
            prefixIcon: Icon(Icons.person),
            hintText: '请输入用户名',
          ),
        ),
        TextField(
          obscureText: true,
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: '密码',
            prefixIcon: Icon(Icons.lock),
            hintText: '请输入密码',
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: toLogin,
              child: const Text('登录'),
            ),
            TextButton(
              onPressed: toForget,
              child: const Text('忘记密码'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: register,
          child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '注册',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )),
        ),
        const SizedBox(height: 16),
      ]);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: theme.colorScheme.primary.withOpacity(0.9)),
        const FlutterLogo(),
        ColoredBox(color: theme.colorScheme.background.withOpacity(0.9)),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: FractionallySizedBox(
            widthFactor: 0.3,
            child: Center(
              child: Material(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(_obxBuilder),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
