import 'package:software_cup_web/pages/home/main/main_index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kAnimationDuration = Duration(milliseconds: 180);

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final index = MainPageIndex.data.obs;

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16),
      child: IndexedStack(
        index: index.value.index,
        children: MainPageIndex.values.map((e) => e.page).toList(),
      ),
    );
  }

  Widget getTabs() {
    final res = <Widget>[];
    final tabBatTextTheme = Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600);
    final curIndex = index.value;
    for (final tab in MainPageIndex.values) {
      final isSelected = tab == curIndex;
      final key = ValueKey(tab.index);
      Widget content = AnimatedContainer(
        duration: kAnimationDuration,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(tab.name, style: tabBatTextTheme),
      );
      content = GestureDetector(
        onTap: () => index(tab),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: content,
        ),
      );

      res.add(KeyedSubtree(key: key, child: content));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: res,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              const SizedBox(height: 64),
              Text('总览', style: Theme.of(context).textTheme.titleLarge),
              Expanded(child: Obx(getTabs)),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        const SizedBox(width: 16),
        Expanded(child: Obx(_buildBody))
      ],
    );
  }
}
