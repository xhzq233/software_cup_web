import 'package:software_cup_web/pages/home/main/data_page.dart';
import 'package:software_cup_web/pages/home/main/model_page.dart';
import 'package:software_cup_web/pages/home/main/predicate_page.dart';
import 'package:software_cup_web/pages/home/main/trian_page.dart';
import 'package:flutter/widgets.dart';

const width4 = SizedBox(width: 4);
const width8 = SizedBox(width: 8);
const width16 = SizedBox(width: 16);
const width32 = SizedBox(width: 32);

enum MainPageIndex {
  data(DataPage(key: Key('data')), '数据管理'),
  train(TrainPage(key: Key('train')), '训练管理'),
  model(ModelPage(key: Key('model')), '模型管理'),
  predicate(PredicatePage(key: Key('predicate')), '模型使用');

  const MainPageIndex(this.page, this.pageTitle);

  final Widget page;
  final String pageTitle;

  String get description => switch (this) {
        data => '上传数据集并划分训练集测试集',
        train => '预置模型调参提供了一种低代码的视觉模型开发方式，开发者无需关注构建模型的细节，而只需要选择合适的预训练模型、网络并通过简单参数配置即可快速构建高精度的视觉模型。',
        model => '管理模型，查看模型属性，性能',
        predicate => '选择模型后，上传数据集进行测试',
      };

  String get uploadLabel => switch (this) {
        data => '新建数据集',
        train => '训练管理',
        model => '模型管理',
        predicate => '',
      };

  String get searchLabel => switch (this) {
        data => '搜索数据集',
        train => '训练管理',
        model => '搜索模型',
        predicate => '搜索模型',
      };
}
