import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:software_cup_web/generated/assets.dart';

class DescriptionPage extends StatelessWidget {
  const DescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: theme.colorScheme.primary.withOpacity(0.9)),
        const FlutterLogo(),
        ColoredBox(color: theme.colorScheme.background.withOpacity(0.9)),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.26),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(Assets.assetsLab, height: 56),
                        const SizedBox(width: 12),
                        Text(
                          '华中科技大学CPSS战队',
                          style: theme.textTheme.displayMedium,
                        ),
                      ],
                    ),
                    Text(
                      '作品名称: 在线分布式故障诊断模型训练平台\n团队名称:你所热爱的\n指导老师:邓贤君\n团队成员:刘潇 余沁益 梁仕 夏侯臻',
                      style: theme.textTheme.displaySmall?.copyWith(height: 2),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.70, top: MediaQuery.of(context).size.height * 0.07),
          child: FittedBox(
            child: Image.asset(
              Assets.assetsWa,
              color: theme.colorScheme.onBackground,
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height * 0.15,
            ),
          ),
        ),
      ],
    );
  }
}
