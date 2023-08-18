import 'package:flutter/material.dart';
import 'package:software_cup_web/generated/assets.dart';

class DocPage extends StatelessWidget {
  const DocPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.68;
    return Align(
      child: SizedBox(
        width: width,
        child: ListView(
          children: [
            Image.asset(
              Assets.manual1,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              Assets.manual2,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              Assets.manual3,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              Assets.manual4,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              Assets.manual5,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              Assets.manual6,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
