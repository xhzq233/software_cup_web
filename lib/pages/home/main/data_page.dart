import 'package:software_cup_web/pages/home/main/main_index.dart';
import 'package:flutter/material.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

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
            Text(MainPageIndex.data.name, style: textTheme.headlineLarge),
            const SizedBox(width: 8),
            Text(
              '上传数据集并划分训练集测试集',
              style: textTheme.titleLarge,
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('新建数据集')),
            const Spacer(
              flex: 3,
            ),
            const Expanded(
              child: SizedBox(
                height: 44,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: '搜索数据集',
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
