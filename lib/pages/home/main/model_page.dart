import 'package:analyze_sys_web/pages/home/main/main_index.dart';
import 'package:flutter/material.dart';

class ModelPage extends StatelessWidget {
  const ModelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(MainPageIndex.model.name, style: textTheme.headlineLarge),
            const SizedBox(width: 8),
            Text(
              '管理模型，查看模型属性，性能',
              style: textTheme.titleLarge,
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '我的模型(0)',
              style: textTheme.titleLarge,
            ),
            const Spacer(
              flex: 3,
            ),
            const Expanded(
              child: SizedBox(
                height: 44,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: '输入模型名称',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
