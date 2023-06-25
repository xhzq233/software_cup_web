import 'dart:ui';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

const kDuration = Duration(milliseconds: 300);

enum LoginLayoutState {
  login,
  register,
  forget;

  String get labelText {
    return '用户名';
  }

  String get hintText {
    return '请输入用户名';
  }

  String get passwdLabelText {
    switch (this) {
      case login || register:
        return '密码';
      case forget:
        return '新密码';
    }
  }

  String get passwdHintText {
    switch (this) {
      case login || register:
        return '请输入密码';
      case forget:
        return '请输入新密码';
    }
  }

  String get mainActionLabel {
    switch (this) {
      case login:
        return '登录';
      case register:
        return '注册';
      case forget:
        return '重置密码';
    }
  }

  (String, String) get actionLabels {
    switch (this) {
      case login:
        return ('注册', '忘记密码');
      case register:
        return ('登录', '忘记密码');
      case forget:
        return ('登录', '注册');
    }
  }
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final state = LoginLayoutState.login.obs;
  final UnAuthAPIProvider api = Get.find();

  late final mainActionsMap = {
    LoginLayoutState.login: login,
    LoginLayoutState.register: register,
    LoginLayoutState.forget: forget,
  };

  void forget() {}

  void register() {
    api.register(nameController.text, passwordController.text).then((resp) {
      if (resp.statusCode == 200) {
        state(LoginLayoutState.login);
      }
    });
  }

  void login() {
    api.login(nameController.text, passwordController.text);
  }

  Widget _contentBuilder() {
    final textTheme = Theme.of(context).textTheme;
    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('平台登录', style: textTheme.titleLarge),
      )
    ];

    final state = this.state.value;
    final otherStates = LoginLayoutState.values.where((s) => s != state);
    children.addAll([
      TextField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: state.labelText,
          prefixIcon: const Icon(Icons.person),
          hintText: state.hintText,
        ),
      ),
      TextField(
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
          labelText: state.passwdLabelText,
          prefixIcon: const Icon(Icons.lock),
          hintText: state.passwdHintText,
        ),
      ),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: kDuration,
              child: TextButton(
                key: Key(state.actionLabels.$1),
                onPressed: () => this.state(otherStates.first),
                child: Text(state.actionLabels.$1),
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: kDuration,
              child: TextButton(
                key: Key(state.actionLabels.$2),
                onPressed: () => this.state(otherStates.last),
                child: Text(state.actionLabels.$2),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ElevatedButton(
        onPressed: mainActionsMap[state],
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.mainActionLabel,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
    ]);

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
          child: Align(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Material(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(_contentBuilder),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
