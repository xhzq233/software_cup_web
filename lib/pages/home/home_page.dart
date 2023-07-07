import 'package:boxy/flex.dart';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/pages/home/desc_page.dart';
import 'package:software_cup_web/pages/home/doc_page.dart';
import 'package:software_cup_web/pages/home/main_page.dart';
import 'package:software_cup_web/token/token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kTabBarHeight = 46.0;

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({
    Key? key,
    this.keepAlive = true,
    required this.child,
  }) : super(key: key);
  final bool keepAlive;
  final Widget child;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant KeepAliveWrapper oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin 中
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum HomePageIndex {
  main,
  description,
  doc;

  String get name {
    switch (this) {
      case HomePageIndex.description:
        return '团队介绍';
      case HomePageIndex.main:
        return '模型训练';
      case HomePageIndex.doc:
        return '支持文档';
    }
  }

  Widget get page {
    switch (this) {
      case HomePageIndex.description:
        return const DescriptionPage(key: ValueKey('DescriptionPage'));
      case HomePageIndex.main:
        return const MainPage(key: ValueKey('MainPage'));
      case HomePageIndex.doc:
        return const DocPage(key: ValueKey('DocPage'));
    }
  }
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final index = HomePageIndex.description.obs;
  final _username = Rx<String?>(null);
  late final _tabBarController = TabController(length: HomePageIndex.values.length, vsync: this);

  @override
  void initState() {
    super.initState();
    authedAPI.getUsername().then((value) => _username.value = value);
  }

  Widget _buildTabBar() {
    final tabBar = TabBar(
      controller: _tabBarController,
      tabs: HomePageIndex.values.map((e) => Tab(text: e.name)).toList(),
      onTap: (index) => this.index(HomePageIndex.values[index]),
    );
    final username = Flexible(
      child: Obx(
        () => Text(
          _username.value ?? '未登录',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    final theme = Theme.of(context);
    final avatarView = IconButton(
      icon: const Icon(Icons.account_circle),
      onPressed: () {
        if (tokenManager.isAuthed) {
          Get.find<AuthedAPIProvider>().logout();
        }
      },
    );
    return Row(
      children: [
        Expanded(child: tabBar),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 168, minWidth: 0),
          child: BoxyColumn(
            children: [
              const Spacer(),
              Dominant(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 6),
                    avatarView,
                    username,
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              const Spacer(),
              Transform.translate(
                offset: const Offset(0, 0.5),
                child: SizedBox(height: 1, child: ColoredBox(color: theme.colorScheme.surfaceVariant)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          ConstrainedBox(constraints: const BoxConstraints(maxHeight: kTabBarHeight), child: _buildTabBar()),
          Expanded(
            child: TabBarView(
                controller: _tabBarController,
                children: HomePageIndex.values.map((e) => KeepAliveWrapper(child: e.page)).toList(growable: false)),
          ),
        ],
      ),
    );
  }
}
