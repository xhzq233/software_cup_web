import 'package:analyze_sys_web/pages/home/main/data_page.dart';
import 'package:analyze_sys_web/pages/home/main/model_page.dart';
import 'package:analyze_sys_web/pages/home/main/model_usage_page.dart';
import 'package:analyze_sys_web/pages/home/main/trian_page.dart';
import 'package:flutter/widgets.dart';

enum MainPageIndex {
  data(DataPage(key: Key('data'))),
  train(TrainPage(key: Key('train'))),
  model(ModelPage(key: Key('model'))),
  modelUsage(ModelUsagePage(key: Key('modelUsage')));

  const MainPageIndex(this.page);

  final Widget page;

  String get name {
    switch (this) {
      case MainPageIndex.data:
        return '数据管理';
      case MainPageIndex.model:
        return '模型管理';
      case MainPageIndex.train:
        return '训练管理';
      case MainPageIndex.modelUsage:
        return '模型使用';
    }
  }
}
