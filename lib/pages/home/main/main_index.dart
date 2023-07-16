import 'package:software_cup_web/pages/home/main/data_page.dart';
import 'package:software_cup_web/pages/home/main/model_page.dart';
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
  // predicate(PredicatePage(key: Key('predicate')), '模型预测')
  ;

  const MainPageIndex(this.page, this.pageTitle);

  final Widget page;
  final String pageTitle;


  String get uploadLabel => switch (this) {
        data => '新建数据集',
        train => '训练管理',
        model => '模型管理',
        // predicate => '',
      };

  String get searchLabel => switch (this) {
        data => '搜索数据集',
        train => '训练管理',
        model => '搜索模型',
        // predicate => '搜索模型',
      };
}
