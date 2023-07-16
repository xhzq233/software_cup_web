import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/http_api/storage.dart';
import 'package:software_cup_web/pages/home/main/table.dart';
import 'package:software_cup_web/pages/home/main/train_item.dart';
import 'package:webviewx/webviewx.dart';
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
  final Rx<List<double>> logs = Rx([]); //折线图参数
  final Rx<double> progress = Rx(0);
  late WebViewXController webViewController;

  @override
  void initState() {
    super.initState();
    result.listen((p0) {
      if (kIsWeb) {
        if (p0 == null) {
          webViewController.loadContent('about:blank', SourceType.URL);
        } else {
          webViewController.loadContent('$baseUrl$p0', SourceType.URL);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_kIndex.pageTitle, style: textTheme.headlineLarge),
        TabBar(tabs: models.keys.map((e) => Tab(text: e)).toList(), controller: _tabController),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 400,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    valueIndicatorShape: const DropSliderValueIndicatorShape(),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: models.values
                        .map(
                          (e) => Form(
                            child: RepaintBoundary(
                              child: Builder(
                                builder: (context) => ListView(
                                  children: e.buildConfig(context),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colorScheme.onSecondary,
                  ),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  height: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 360,
                        child: Obx(
                          () => LineChart(
                            LineChartData(
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: logs.value
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                                      .toList(growable: false),
                                  isCurved: true,
                                  color: theme.colorScheme.secondary,
                                  barWidth: 2,
                                  dotData: const FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (kIsWeb)
                        Expanded(
                          child: WebViewX(
                            onWebViewCreated: (controller) => webViewController = controller,
                          ),
                        ),
                    ],
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
                        height: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: SingleChildScrollView(
                            child: SCTable(
                              data: storageProvider.dataSetListResponse.value!.datasetList,
                              selectAble: true,
                              limit: 1,
                              selected: tDataSet,
                              showAction: false,
                            ),
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
                        logs.update((val) {
                          val?.clear();
                        });
                        result.value = null;
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

                          SmartDialog.showToast('开始训练');

                          data!.stream.listen((event) {
                            final strs = utf8
                                .decode(event)
                                .split('\n')
                                .map((e) => e.trim())
                                .where((element) => element.isNotEmpty);
                            debugPrint(strs.join('\n'));
                            for (final str in strs) {
                              // rm 'data: '

                              final TrainStreamData data = TrainStreamData.fromJson(jsonDecode(str.substring(6)));
                              if (data.code == "1") {
                                // complete
                                result.value = data.result;
                                assert(data.result != null);
                                final log = data.result!.toString();
                                final s = '训练完成: $log\n';
                                SmartDialog.showToast(s);
                                storageProvider.forceGetModelList();
                              } else if (data.code == "0") {
                                assert(data.process != null && data.log != null);
                                // progress
                                logs.update((val) => val?.add(data.log!));
                                progress.value = data.process!;
                              } else {
                                // error
                                final err = 'error: $str\n';
                                SmartDialog.showToast(err);
                              }
                            }
                          }, onError: (e) {
                            // error
                            final err = 'error: $e\n';
                            SmartDialog.showToast(err);
                          }, onDone: () {
                            storageProvider.forceGetModelList();
                          });
                          storageProvider.forceGetModelList();
                        });
                      },
                child: const Text('训练'),
              ),
            ),
            const SizedBox(width: 158),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Row(
                    children: [
                      Text('进度: ${(progress.value * 100).toStringAsFixed(2)}%'),
                      width8,
                      Expanded(
                        child: LinearProgressIndicator(value: progress.value),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
