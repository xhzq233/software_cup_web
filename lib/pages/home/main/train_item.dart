import 'package:flutter/material.dart';
import 'package:software_cup_web/theme.dart';

import 'main_index.dart';

Widget _selectIntItem(int? init, String label, void Function(int) onChanged) {
  final cs = themeNotifier.isDark ? darkTheme.colorScheme : lightTheme.colorScheme;
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: cs.primary, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    width: 168,
    margin: const EdgeInsets.all(4),
    padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
    child: TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: init?.toString(),
      keyboardType: TextInputType.number,
      onChanged: (v) => onChanged(int.parse(v)),
    ),
  );
}

Widget _selectDoubleItem(double init, String label, void Function(double) onChanged) {
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
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: init.toString(),
            keyboardType: TextInputType.number,
            onChanged: (v) => onChanged(double.parse(v)),
          ),
        ),
      ],
    ),
  );
}

// have Upper limit and lower limit
Widget _selectNumItem(num init, num u, num l, String label, void Function(num) onChanged) {
  final cs = themeNotifier.isDark ? darkTheme.colorScheme : lightTheme.colorScheme;

  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: cs.primary, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.all(4),
    // padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 128, child: Align(child: Text('${label.substring(0, 9)}: ${init.toStringAsFixed(2)}'))),
        width16,
        SizedBox(
          width: 198,
          child: Slider(
            value: init.toDouble(),
            min: l.toDouble(),
            max: u.toDouble(),
            label: '$init',
            onChanged: (v) => onChanged(v),
          ),
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

  Widget buildConfig();

  Map<String, Object?> toJson();
}

/// train models
///
///
// LGBMClassifier:
// {
//           'objective': 'multiclass',  # 多分类
//           'metric': 'multi_logloss',  # 多分类交叉熵
// //上面这两个不显示，但是要返回
//         boosting_type: str = 'gbdt',(可选值包括gbdt，dart，goss)
//         num_leaves: int = 31,( > 0)
//         max_depth: int = -1, ( > 0)
//         learning_rate: float = 0.1,( > 0)
//         n_estimators: int = 100,(> 0)
//         min_child_samples: int = 20,(>0)
//         subsample: float = 1.,(in the interval `(0.0, 1.0])
//         colsample_bytree: float = 1.,(in the interval `(0.0, 1.0])
//         reg_alpha: float = 0.,( > 0)
//         reg_lambda: float = 0.,(> 0)
//         random_state: Optional[Union[int, np.random.RandomState]] = None,
// }
// ignore_for_file: non_constant_identifier_names
class LGBMClassifier with ConfigBuilder {
  String objective = 'multiclass';
  String metric = 'multi_logloss';
  String boosting_type = 'gbdt';
  int num_leaves = 31;
  int max_depth = -1;
  double learning_rate = 0.1;
  int n_estimators = 100;
  int min_child_samples = 20;
  double subsample = 1.0;
  double colsample_bytree = 1.0;
  double reg_alpha = 0.0;
  double reg_lambda = 0.0;
  int random_state = 45;

  @override
  Widget buildConfig() {
    return Builder(
      builder: (context) => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _selectSwitchItem(boosting_type, {'gbdt', 'dart', 'goss'}, 'boosting_type', (v) {
            boosting_type = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(num_leaves, 'num_leaves', (v) {
            num_leaves = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(max_depth, 'max_depth', (v) {
            max_depth = v;
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(learning_rate, 'learning_rate', (v) {
            learning_rate = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(n_estimators, 'n_estimators', (v) {
            n_estimators = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(min_child_samples, 'min_child_samples', (v) {
            min_child_samples = v;
            (context as Element).markNeedsBuild();
          }),
          _selectNumItem(subsample, 1.0, 0.0, 'subsample', (v) {
            subsample = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectNumItem(colsample_bytree, 1.0, 0.0, 'colsample_bytree', (v) {
            colsample_bytree = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(reg_alpha, 'reg_alpha', (v) {
            reg_alpha = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(reg_lambda, 'reg_lambda', (v) {
            reg_lambda = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(random_state, 'random_state', (v) {
            random_state = v;
            (context as Element).markNeedsBuild();
          }),
        ],
      ),
    );
  }

  @override
  Map<String, Object?> toJson() => {
        'objective': objective,
        'metric': metric,
        'boosting_type': boosting_type,
        'num_leaves': num_leaves,
        'max_depth': max_depth,
        'learning_rate': learning_rate,
        'n_estimators': n_estimators,
        'min_child_samples': min_child_samples,
        'subsample': subsample,
        'colsample_bytree': colsample_bytree,
        'reg_alpha': reg_alpha,
        'reg_lambda': reg_lambda,
        'random_state': random_state,
      };

  @override
  // TODO: implement name
  String get name => 'LGBM';
}

// RandomForestClassifier:
// {
//         n_estimators=100,(int)
//         criterion="gini",(str, 可选值包括'gini'和'entropy'。默认为'gini'。 )
//         max_depth=None,(int,如果设置为None，则表示没有限制，默认为None)
//         min_samples_split=2,(int,greater than 1)
//         min_samples_leaf=1,(int greater than 0)
//         max_features="auto",("auto", "sqrt", "log2")
//         bootstrap=True,(bool)
//         max_samples=None(in the interval `(0.0, 1.0])
//         random_state=None,(int)
//         ccp_alpha=0.0,(non-negative float, default=0.0)
// }
class RandomForestClassifier with ConfigBuilder {
  int n_estimators = 100;
  String criterion = 'gini';
  int? max_depth;

  int min_samples_split = 2;
  int min_samples_leaf = 1;
  String max_features = 'auto';
  bool bootstrap = true;
  double max_samples = 1;
  int random_state = 45;
  double ccp_alpha = 0.0;

  @override
  Widget buildConfig() {
    return Builder(
      builder: (context) => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _selectIntItem(n_estimators, 'n_estimators', (v) {
            n_estimators = v;
            (context as Element).markNeedsBuild();
          }),
          _selectSwitchItem(criterion, {'gini', 'entropy'}, 'criterion', (v) {
            criterion = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(max_depth, 'max_depth', (v) {
            max_depth = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(min_samples_split, 'min_samples_split', (v) {
            min_samples_split = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(min_samples_leaf, 'min_samples_leaf', (v) {
            min_samples_leaf = v;
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
          _selectNumItem(max_samples, 1.0, 0.0, 'max_samples', (v) {
            max_samples = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(random_state, 'random_state', (v) {
            random_state = v;
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(ccp_alpha, 'ccp_alpha', (v) {
            ccp_alpha = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
        ],
      ),
    );
  }

  @override
  Map<String, Object?> toJson() => {
        'n_estimators': n_estimators,
        'criterion': criterion,
        'max_depth': max_depth,
        'min_samples_split': min_samples_split,
        'min_samples_leaf': min_samples_leaf,
        'max_features': max_features,
        'bootstrap': bootstrap,
        'max_samples': max_samples,
        'random_state': random_state,
        'ccp_alpha': ccp_alpha,
      };

  @override
  // TODO: implement name
  String get name => 'RF';
}

// XGBClassifier
// {
//            'objective': 'multiclass',  # 多分类
//            'eval_metric': 'mlogloss',  # 多分类交叉熵
// //上面这两个不显示，但是要返回
//         max_depth=-1,(int > 0)
//         learning_rate=0.1,( float > 0)
//         n_estimators: int = 100, (greater than 0)
//         Gamma=0(float)(in the interval `(0.0, 1.0])
//         subsample: Optional[float] = 1,(in the interval `(0.0, 1.0])
//         colsample_bytree: Optional[float] = 1,(in the interval `(0.0, 1.0])
//         reg_alpha=0(float > 0),
//         reg_lambda=1(float > 0),
//         random_state: Optional[Union[np.random.RandomState, int]] = None,
// }
class XGBClassifier with ConfigBuilder {
  String objective = 'multiclass';
  String eval_metric = 'mlogloss';
  int max_depth = -1;
  double learning_rate = 0.1;
  int n_estimators = 100;
  double gamma = 0.0;
  double subsample = 1;
  double colsample_bytree = 1;
  double reg_alpha = 0.0;
  double reg_lambda = 1.0;
  int random_state = 42;

  @override
  Widget buildConfig() {
    return Builder(
      builder: (context) => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _selectSwitchItem(
              objective, {'multiclass', 'binary:logistic', 'binary:logitraw', 'binary:hinge'}, 'objective', (v) {
            objective = v;
            (context as Element).markNeedsBuild();
          }),
          _selectSwitchItem(eval_metric, {'mlogloss', 'merror', 'auc', 'logloss'}, 'eval_metric', (v) {
            eval_metric = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(max_depth, 'max_depth', (v) {
            max_depth = v;
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(learning_rate, 'learning_rate', (v) {
            learning_rate = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(n_estimators, 'n_estimators', (v) {
            n_estimators = v;
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(gamma, 'gamma', (v) {
            gamma = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(subsample, 'subsample', (v) {
            subsample = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(colsample_bytree, 'colsample_bytree', (v) {
            colsample_bytree = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(reg_alpha, 'reg_alpha', (v) {
            reg_alpha = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(reg_lambda, 'reg_lambda', (v) {
            reg_lambda = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(random_state, 'random_state', (v) {
            random_state = v;
            (context as Element).markNeedsBuild();
          }),
        ],
      ),
    );
  }

  @override
  Map<String, Object?> toJson() => {
        'objective': objective,
        'eval_metric': eval_metric,
        'max_depth': max_depth,
        'learning_rate': learning_rate,
        'n_estimators': n_estimators,
        'gamma': gamma,
        'subsample': subsample,
        'colsample_bytree': colsample_bytree,
        'reg_alpha': reg_alpha,
        'reg_lambda': reg_lambda,
        'random_state': random_state,
      };

  @override
  // TODO: implement name
  String get name => 'XGB';
}

// CatBoostClassifier =
// {
// 'verbose':False
// //上面这个不显示，但是要返回
//             'depth':6,(int > 0)
//             'iterations':1000,(int > 0)
//             'l2_leaf_reg':3,(float > 0)
//             'colsample_bylevel':0.9,(in the interval `(0.0, 1.0])
//             'bagging_temperature':1,(float > 0)
//             'random_strength':1,(float > 0)
// }
class CatBoostClassifier with ConfigBuilder {
  bool verbose = false;
  int depth = 6;
  int iterations = 1000;
  double l2_leaf_reg = 3.0;
  double colsample_bylevel = 0.9;
  double bagging_temperature = 1.0;
  double random_strength = 1.0;

  @override
  Widget buildConfig() {
    return Builder(
      builder: (context) => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _selectSwitchItem(verbose, {true, false}, 'verbose', (v) {
            verbose = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(depth, 'depth', (v) {
            depth = v;
            (context as Element).markNeedsBuild();
          }),
          _selectIntItem(iterations, 'iterations', (v) {
            iterations = v;
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(l2_leaf_reg, 'l2_leaf_reg', (v) {
            l2_leaf_reg = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(colsample_bylevel, 'colsample_bylevel', (v) {
            colsample_bylevel = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(bagging_temperature, 'bagging_temperature', (v) {
            bagging_temperature = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
          _selectDoubleItem(random_strength, 'random_strength', (v) {
            random_strength = v.toDouble();
            (context as Element).markNeedsBuild();
          }),
        ],
      ),
    );
  }

  @override
  Map<String, Object?> toJson() => {
        'verbose': verbose,
        'depth': depth,
        'iterations': iterations,
        'l2_leaf_reg': l2_leaf_reg,
        'colsample_bylevel': colsample_bylevel,
        'bagging_temperature': bagging_temperature,
        'random_strength': random_strength,
      };

  @override
  // TODO: implement name
  String get name => 'CAT';
}
