import 'package:flutter/material.dart';
import 'package:software_cup_web/theme.dart';

// ignore_for_file: non_constant_identifier_names
import 'main_index.dart';

// have Upper limit and lower limit
Widget _selectNumItem(num init, {num u = 1, num l = 0, String label = '', void Function(num)? onChanged}) {
  final theme = themeNotifier.isDark ? darkTheme : lightTheme;
  final cs = theme.colorScheme;

  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: cs.primary, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.all(4),
    padding: const EdgeInsets.all(4),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 128,
          height: 32,
          child: FittedBox(
            child: Text('$label: ${init is int ? init : init.toStringAsFixed(2)}'),
          ),
        ),
        width4,
        Slider(
          value: init.toDouble(),
          min: l.toDouble(),
          max: u.toDouble(),
          // divisions: init is int ? (u - l).toInt() : null,
          label: '$init',
          onChanged: (v) => onChanged?.call(v),
        ),
      ],
    ),
  );
}

Widget _selectSwitchItem<Tt>(Tt init, Set<Tt> available, String label, void Function(Tt) onChanged) {
  final cs = themeNotifier.isDark ? darkTheme.colorScheme : lightTheme.colorScheme;

  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: cs.primary, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.all(4),
    padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        width16,
        DropdownButton<Tt>(
          value: init,
          onChanged: (v) => onChanged(v ?? init),
          items: available.map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList(growable: false),
        ),
      ],
    ),
  );
}

mixin ConfigBuilder {
  String get name;

  List<Widget> buildConfig(BuildContext context);

  Map<String, Object?> toJson();
}

/// train models
///

class LGBMClassifier with ConfigBuilder {
  // boosting_type: str = 'gbdt',(可选值包括gbdt，dart，goss)
// 提升树的类型num_leaves= 31		int ,( [1,10000])   //树的最大叶子数,小于2^max_depth
// max_depth=6 			int   ( ([1,100])         //最大树的深度
// learning_rate=0.1 		float  ( [0.001,10])  //学习率
// n_estimators=100		int   ([1,10000])     //拟合的树的数量
// Subsample=1.0			float  ([0.1, 1.0])        //子样本频率
// colsample_bytree=1.0 	float  ([0.1, 1.0])  //训练特征采样率
// reg_alpha=0.001	 		float  ( [0.001,100])			  //L1正则化系数
// reg_lambda=0.001 		float  ([0.001,100])		  //L2正则化系数
// random_state=42  		int   ([1,10000])	//随机数种子
  String boosting_type = 'gbdt';
  int num_leaves = 31;
  int max_depth = 6;
  double learning_rate = 0.1;
  int n_estimators = 100;
  double Subsample = 1.0;
  double colsample_bytree = 1.0;
  double reg_alpha = 0.001;
  double reg_lambda = 0.001;
  int random_state = 42;

  @override
  List<Widget> buildConfig(BuildContext context) => [
        _selectSwitchItem(boosting_type, {'gbdt', 'dart', 'goss'}, 'boosting_type', (v) {
          boosting_type = v;
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(num_leaves, l: 1, u: 10000, label: 'num_leaves', onChanged: (v) {
          num_leaves = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(max_depth, l: 1, u: 100, label: 'max_depth', onChanged: (v) {
          max_depth = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(learning_rate, l: 0.001, u: 10, label: 'learning_rate', onChanged: (v) {
          learning_rate = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(n_estimators, l: 1, u: 10000, label: 'n_estimators', onChanged: (v) {
          n_estimators = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(Subsample, l: 0.1, u: 1.0, label: 'Subsample', onChanged: (v) {
          Subsample = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(colsample_bytree, l: 0.1, u: 1.0, label: 'colsample_bytree', onChanged: (v) {
          colsample_bytree = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(reg_alpha, l: 0.001, u: 100, label: 'reg_alpha', onChanged: (v) {
          reg_alpha = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(reg_lambda, l: 0.001, u: 100, label: 'reg_lambda', onChanged: (v) {
          reg_lambda = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(random_state, l: 1, u: 10000, label: 'random_state', onChanged: (v) {
          random_state = v.toInt();
          (context as Element).markNeedsBuild();
        }),
      ];

  @override
  Map<String, Object?> toJson() => {
        'boosting_type': boosting_type,
        'num_leaves': num_leaves,
        'max_depth': max_depth,
        'learning_rate': learning_rate,
        'n_estimators': n_estimators,
        'Subsample': Subsample,
        'colsample_bytree': colsample_bytree,
        'reg_alpha': reg_alpha,
        'reg_lambda': reg_lambda,
        'random_state': random_state,
      };

  @override
  // TODO: implement name
  String get name => 'LGBM';
}

class RandomForestClassifier with ConfigBuilder {
  //criterion="gini",(str, 可选值包括'gini'和'entropy'。默认为'gini'。 )   //分裂节点所用的标准
  // max_features="auto",("auto", "sqrt", "log2")  //单个决策树使用的特征最大数量
  // bootstrap=True,(bool) 			 //是否进行bootstrap操作
  // n_estimators=100,		(int [1,10000] )   //森林中决策树的数量，默认100
  // max_depth=10 			(int [1,100]),       //分裂节点所用的标准
  // min_samples_split=2,	int ([2,100])     //拆分内部节点所需的最少样本数
  // min_samples_leaf= 1,	int ([1,100])     //叶节点处需要的最小样本数
  // max_samples=1.0 		float ( [0.1, 1.0] )   //子样本频率
  // random_state=42 		int ([1,10000])  //随机数种子
  // ccp_alpha=0.001,		float( [0.001,10] )			//树修剪参数
  String criterion = 'gini';
  String max_features = 'auto';
  bool bootstrap = true;
  int n_estimators = 100;
  int max_depth = 10;
  int min_samples_split = 2;
  int min_samples_leaf = 1;
  double max_samples = 1.0;
  int random_state = 42;
  double ccp_alpha = 0.001;

  @override
  List<Widget> buildConfig(BuildContext context) => [
        _selectSwitchItem(criterion, {'gini', 'entropy'}, 'criterion', (v) {
          criterion = v;
          (context as Element).markNeedsBuild();
        }),
        _selectSwitchItem(max_features, {'auto', 'sqrt', 'log2'}, 'max_features', (v) {
          max_features = v;
          (context as Element).markNeedsBuild();
        }),
        _selectSwitchItem(bootstrap, {true, false}, 'bootstrap', (v) {
          bootstrap = v;
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(n_estimators, l: 1, u: 10000, label: 'n_estimators', onChanged: (v) {
          n_estimators = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(max_depth, l: 1, u: 100, label: 'max_depth', onChanged: (v) {
          max_depth = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(min_samples_split, l: 2, u: 100, label: 'min_samples_split', onChanged: (v) {
          min_samples_split = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(min_samples_leaf, l: 1, u: 100, label: 'min_samples_leaf', onChanged: (v) {
          min_samples_leaf = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(max_samples, l: 0.1, u: 1.0, label: 'max_samples', onChanged: (v) {
          max_samples = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(random_state, l: 1, u: 10000, label: 'random_state', onChanged: (v) {
          random_state = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(ccp_alpha, l: 0.001, u: 10, label: 'ccp_alpha', onChanged: (v) {
          ccp_alpha = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
      ];

  @override
  Map<String, Object?> toJson() => {
        'criterion': criterion,
        'max_features': max_features,
        'bootstrap': bootstrap,
        'n_estimators': n_estimators,
        'max_depth': max_depth,
        'min_samples_split': min_samples_split,
        'min_samples_leaf': min_samples_leaf,
        'max_samples': max_samples,
        'random_state': random_state,
        'ccp_alpha': ccp_alpha,
      };

  @override
  String get name => 'RF';
}

class XGBClassifier with ConfigBuilder {
  // max_depth=6,	 		int ( [1,100] )   				//树的最大深度
  // learning_rate=0.1,		float ( [0.001,10] )  		//学习率
  // n_estimators= 100, 		int( [1,10000] )     //弱分类器的数量
  // subsample= 1.0  		float([0.1, 1.0])          //子样本频率
  // colsample_bytree:1.0	float ( [0.1,1.0] )  //训练特征采样率
  // reg_alpha=0.01 			float ( [0.01, 10] ),              //L1正则化权重项
  // reg_lambda=0.01  		float ( [0.01, 10] ),              //L2正则化权重项
  // random_state=42 		int ([1,10000])        //随机数种子

  int max_depth = 6;
  double learning_rate = 0.1;
  int n_estimators = 100;
  double subsample = 1.0;
  double colsample_bytree = 1.0;
  double reg_alpha = 0.01;
  double reg_lambda = 0.01;
  int random_state = 42;

  @override
  List<Widget> buildConfig(BuildContext context) => [
        _selectNumItem(max_depth, l: 1, u: 100, label: 'max_depth', onChanged: (v) {
          max_depth = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(learning_rate, l: 0.001, u: 10, label: 'learning_rate', onChanged: (v) {
          learning_rate = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(n_estimators, l: 1, u: 10000, label: 'n_estimators', onChanged: (v) {
          n_estimators = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(subsample, l: 0.1, u: 1.0, label: 'subsample', onChanged: (v) {
          subsample = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(colsample_bytree, l: 0.1, u: 1.0, label: 'colsample_bytree', onChanged: (v) {
          colsample_bytree = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(reg_alpha, l: 0.01, u: 10, label: 'reg_alpha', onChanged: (v) {
          reg_alpha = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(reg_lambda, l: 0.01, u: 10, label: 'reg_lambda', onChanged: (v) {
          reg_lambda = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(random_state, l: 1, u: 10000, label: 'random_state', onChanged: (v) {
          random_state = v.toInt();
          (context as Element).markNeedsBuild();
        }),
      ];

  @override
  Map<String, Object?> toJson() => {
        'max_depth': max_depth,
        'learning_rate': learning_rate,
        'n_estimators': n_estimators,
        'subsample': subsample,
        'colsample_bytree': colsample_bytree,
        'reg_alpha': reg_alpha,
        'reg_lambda': reg_lambda,
        'random_state': random_state,
      };

  @override
  String get name => 'XGB';
}

class CatBoostClassifier with ConfigBuilder {
  //‘learning_rate’=0.030			float ( [0.001,10] )   //学习率
  // 'depth'=6,		 			int ( [1, 100] )              //树的深度
  // 'iterations'=1000, 			int ( [10,10000] )     //迭代轮数
  // 'l2_leaf_reg'=3.0, 			float ([0.1, 100] )    //L2叶子正则化系数
  // 'colsample_bylevel'=0.9, 		int ( [0.1, 1.0])  //训练特征采样率
  // 'bagging_temperature'=1, 	float ( [0.1,10] )  //控制分裂节点的概率
  // 'random_strength'=1.0, 		float ( [0.1,10] )     //控制分裂节点随机性

  double learning_rate = 0.030;
  int depth = 6;
  int iterations = 1000;
  double l2_leaf_reg = 3.0;
  double colsample_bylevel = 0.9;
  double bagging_temperature = 1;
  double random_strength = 1.0;

  @override
  List<Widget> buildConfig(BuildContext context) => [
        _selectNumItem(learning_rate, l: 0.001, u: 10, label: 'learning_rate', onChanged: (v) {
          learning_rate = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(depth, l: 1, u: 100, label: 'depth', onChanged: (v) {
          depth = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(iterations, l: 10, u: 10000, label: 'iterations', onChanged: (v) {
          iterations = v.toInt();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(l2_leaf_reg, l: 0.1, u: 100, label: 'l2_leaf_reg', onChanged: (v) {
          l2_leaf_reg = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(colsample_bylevel, l: 0.1, u: 1.0, label: 'colsample_bylevel', onChanged: (v) {
          colsample_bylevel = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(bagging_temperature, l: 0.1, u: 10, label: 'bagging_temperature', onChanged: (v) {
          bagging_temperature = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
        _selectNumItem(random_strength, l: 0.1, u: 10, label: 'random_strength', onChanged: (v) {
          random_strength = v.toDouble();
          (context as Element).markNeedsBuild();
        }),
      ];

  @override
  Map<String, Object?> toJson() => {
        'learning_rate': learning_rate,
        'depth': depth,
        'iterations': iterations,
        'l2_leaf_reg': l2_leaf_reg,
        'colsample_bylevel': colsample_bylevel,
        'bagging_temperature': bagging_temperature,
        'random_strength': random_strength,
      };

  @override
  String get name => 'CAT';
}
