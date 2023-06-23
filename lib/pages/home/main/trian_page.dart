import 'package:flutter/material.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('预置模型调参提供了一种低代码的视觉模型开发方式，开发者无需关注构建模型的细节，而只需要选择合适的预训练模型、网络并通过简单参数配置即可快速构建高精度的视觉模型。'),
      ],
    );
  }
}
