import 'package:flutter/material.dart';
import 'main_index.dart';

const _kIndex = MainPageIndex.train;



class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_kIndex.pageTitle, style: textTheme.headlineLarge),
            width16,
            Flexible(child: Text(_kIndex.description, style: textTheme.titleLarge))
          ],
        ),
      ],
    );
  }
}
