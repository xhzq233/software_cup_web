import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/pages/home/desc_page.dart';
import 'package:software_cup_web/pages/home/doc_page.dart';
import 'package:software_cup_web/pages/home/main_page.dart';
import 'package:software_cup_web/token/token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kTabBarHeight = 46.0;

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
        return const DescriptionPage();
      case HomePageIndex.main:
        return const MainPage();
      case HomePageIndex.doc:
        return const DocPage();
    }
  }
}

class _HomePageState extends State<HomePage> {
  final index = HomePageIndex.description.obs;

  Widget _buildTabBar() {
    final tabBar = TabBar(
      tabs: HomePageIndex.values.map((e) => Tab(text: e.name)).toList(),
      onTap: (index) => this.index(HomePageIndex.values[index]),
    );
    final username = Expanded(
      child: Text(
        tokenManager.token ?? '未登录',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: tabBar),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 168),
          child: Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  const SizedBox(width: 6),
                  avatarView,
                  username,
                  const SizedBox(width: 12),
                ],
              ),
              const Spacer(),
              Transform.translate(
                offset: const Offset(0, 0.5),
                child: Divider(height: 1, thickness: 1, color: theme.colorScheme.surfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: HomePageIndex.values.length,
        child: Column(
          children: [
            ConstrainedBox(constraints: const BoxConstraints(maxHeight: kTabBarHeight), child: _buildTabBar()),
            Expanded(child: TabBarView(children: HomePageIndex.values.map((e) => e.page).toList())),
          ],
        ),
      ),
    );
  }
}
