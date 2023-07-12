import 'dart:convert';
import 'dart:math';
import 'package:boxy/flex.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/http_api/storage.dart';
import 'package:software_cup_web/pages/home/main/table.dart';
import 'package:software_cup_web/pages/home/main/train_item.dart';
import '../../../http_api/model.dart';
import 'main_index.dart';

const _kIndex = MainPageIndex.train;
final Map<String, ConfigBuilder> models = {
  'LGBMClassifier': LGBMClassifier(),
  'RandomForestClassifier': RandomForestClassifier(),
  'XGBClassifier': XGBClassifier(),
  'CatBoostClassifier': CatBoostClassifier()
};

class TrainPage extends StatefulWidget {
  const TrainPage({super.key});

  @override
  State<TrainPage> createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: models.length, vsync: this);
  final Rx<TrainResult?> result = Rx(null);
  final Rx<DataSet?> selectedDataSet = Rx(null);
  final Rx<String> logs = Rx('');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return BoxyColumn(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_kIndex.pageTitle, style: textTheme.headlineLarge),
            width16,
            Flexible(child: Text(_kIndex.description, style: textTheme.titleLarge))
          ],
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(tabs: models.keys.map((e) => Tab(text: e)).toList(), controller: _tabController),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: models.values
                            .map((e) => Form(child: RepaintBoundary(child: e.buildConfig())))
                            .toList(growable: false),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colorScheme.onSecondary,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                width: 360,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(() => Text(logs.value)),
                  ),
                ),
              ),
            ],
          ),
        ),
        // actions
        Row(
          children: [
            ElevatedButton(
                onPressed: () async {
                  assert(storageProvider.dataSetListResponse.value != null);
                  final Set<DataSet> tDataSet = {
                    if (selectedDataSet.value != null) selectedDataSet.value!,
                  };
                  final res = await Get.dialog(
                    AlertDialog(
                      title: const Text('选择数据集'),
                      content: SizedBox(
                        width: max(MediaQuery.of(context).size.width * 0.8, 400),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SCTable(
                            data: storageProvider.dataSetListResponse.value!.datasetList,
                            selectAble: true,
                            limit: 1,
                            selected: tDataSet,
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
                  if (res == null || res == false) {
                    return;
                  }
                  selectedDataSet.value = tDataSet.first;
                },
                child: Obx(() => Text(selectedDataSet.value == null ? '选择数据集' : selectedDataSet.value!.name))),
            width16,
            Obx(
              () => ElevatedButton(
                onPressed: selectedDataSet.value == null
                    ? null
                    : () async {
                        String? name;

                        final res = await Get.dialog(
                          AlertDialog(
                            title: const Text('输入模型名称'),
                            content: SizedBox(
                              width: 300,
                              child: TextFormField(
                                onChanged: (v) => name = v,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text('确定'),
                              ),
                            ],
                          ),
                        );
                        if (res == null || res == false) {
                          return;
                        }

                        final index = _tabController.index;
                        final model = models.values.elementAt(index);
                        authedAPI
                            .train(
                          name!,
                          selectedDataSet.value!.id,
                          model.name,
                          model.toJson(),
                        )
                            .then((resp) {
                          final ResponseBody? data = resp.data;
                          assert(data != null);
                          logs.value = '开始训练\n';
                          data!.stream.listen((event) {
                            final strs = utf8
                                .decode(event)
                                .split('\n')
                                .map((e) => e.trim())
                                .where((element) => element.isNotEmpty);
                            debugPrint(strs.join('\n'));
                            for (final str in strs) {
                              final TrainStreamData data = TrainStreamData.fromJson(jsonDecode(str));
                              if (data.code == "1") {
                                // complete
                                result.value = data.result;
                                assert(data.result != null);
                                final log = data.result!.toString();
                                logs.value += '训练完成: $log\n';
                                storageProvider.forceGetModelList();
                              } else if (data.code == "0") {
                                assert(data.process != null && data.log != null);
                                // progress
                                logs.value += 'log: ${data.log!}, progress: ${data.process!}\n';
                              } else {
                                // error
                                logs.value += 'error: $str\n';
                              }
                            }
                          }, onError: (e) {
                            logs.value += 'error: $e\n';
                          }, onDone: () {
                            storageProvider.forceGetModelList();
                          });
                          storageProvider.forceGetModelList();
                        });
                      },
                child: const Text('训练'),
              ),
            ),
            width16,
            // ElevatedButton(onPressed: () {}, child: const Text('下载')),
            // width16,
          ],
        ),
      ],
    );
  }
}
