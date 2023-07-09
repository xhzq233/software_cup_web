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
    return IndexedStack(
      index: index.value.index,
      children: MainPageIndex.values.map((e) => e.page).toList(),
    );
  }

  Widget getTabs() {
    final res = <Widget>[];
    final curIndex = index.value;
    for (final tab in MainPageIndex.values) {
      final isSelected = tab == curIndex;
      Widget content = Align(child: Text(tab.pageTitle));

      content = ListTile(onTap: () => index(tab), title: content, selected: isSelected);

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
        BoxyColumn(
          children: [
            const SizedBox(height: 16),
            const Align(child: Text('总览')),
            const SizedBox(height: 8),
            const SizedBox(height: 1, child: ColoredBox(color: Colors.grey)),
            Dominant(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 120), child: Obx(getTabs))),
            const Spacer(),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Obx(_buildBody),
          ),
        )
      ],
    );
  }
}
