import 'package:software_cup_web/pages/home/main/data_page.dart';
import 'package:software_cup_web/pages/home/main/model_page.dart';
import 'package:software_cup_web/pages/home/main/model_usage_page.dart';
import 'package:software_cup_web/pages/home/main/trian_page.dart';
import 'package:flutter/widgets.dart';

enum MainPageIndex {
  data(DataPage(key: Key('data')), '数据管理'),
  train(TrainPage(key: Key('train')), '训练管理'),
  model(ModelPage(key: Key('model')), '模型管理'),
  modelUsage(ModelUsagePage(key: Key('modelUsage')), '模型使用');

  const MainPageIndex(this.page, this.pageTitle);

  final Widget page;
  final String pageTitle;
}
