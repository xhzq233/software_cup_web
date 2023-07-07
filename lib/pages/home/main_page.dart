import 'package:boxy/flex.dart';
import 'package:software_cup_web/http_api/storage.dart';
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
  final Rx<MainPageIndex> index = MainPageIndex.data.obs;

  @override
  void initState() {
    index.listen(storageProvider.switchedMainPageTab);
    // init
    storageProvider.switchedMainPageTab(index.value);
    super.initState();
  }

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
    final curIndex = index.value;
    for (final tab in MainPageIndex.values) {
      final isSelected = tab == curIndex;
      Widget content = AnimatedContainer(
        duration: kAnimationDuration,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(tab.pageTitle),
      );

      content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => index(tab),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: content,
          ),
        ),
      );

      res.add(KeyedSubtree(key: ValueKey(tab), child: content));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: res,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: BoxyColumn(
            children: [
              const SizedBox(height: 16),
              const Align(child: Text('总览')),
              const SizedBox(height: 8),
              const SizedBox(height: 1, child: ColoredBox(color: Colors.grey)),
              Dominant(child: Obx(getTabs)),
              const Spacer(),
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
