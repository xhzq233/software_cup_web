import 'package:flutter/material.dart';
import 'package:software_cup_web/generated/assets.dart';

class DocPage extends StatelessWidget {
  const DocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.asset(Assets.manual1, height: MediaQuery.of(context).size.height),
        Image.asset(Assets.manual2, height: MediaQuery.of(context).size.height),
        Image.asset(Assets.manual3, height: MediaQuery.of(context).size.height),
        Image.asset(Assets.manual4, height: MediaQuery.of(context).size.height),
        Image.asset(Assets.manual5, height: MediaQuery.of(context).size.height),
        Image.asset(Assets.manual6, height: MediaQuery.of(context).size.height),
      ],
    );
  }
}
