import 'dart:math';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/http_api/model.dart';
import 'package:software_cup_web/http_api/storage.dart';
import 'package:software_cup_web/pages/home/main/main_index.dart';
import 'package:flutter/material.dart';
import 'package:software_cup_web/pages/home/main/table.dart';

const _kIndex = MainPageIndex.model;
const _kAnimationDuration = Duration(milliseconds: 300);

class ModelPage extends StatefulWidget {
  const ModelPage({super.key});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  final searchString = ''.obs;
  final Set<Model> selected = {};
  final selectAble = false.obs;
  final updateF1 = false.obs;
  final Rx<DataSet?> selectedDataSet = Rx(null);

  Widget _buildBody() {
    final list = storageProvider.modelListResponse.value;
    if (list == null || list.modelList.isEmpty) {
      return const SizedBox();
    }
    final key = searchString.value;
    final copied = list.modelList.where((element) => element.name.contains(key)).toList();
    return SCTable<Model>(
      data: copied,
      selectAble: selectAble.value,
      selected: selected,
      limit: 1,
    );
  }

  DataTable _getResDataTable(Map<String, int> predRes) {
    return DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('样本序号')),
          DataColumn(label: Text('分类结果')),
        ],
        rows: predRes
            .map((key, value) {
              return MapEntry(
                DataRow(cells: [DataCell(Text(key)), DataCell(Text(value.toString()))]),
                '',
              );
            })
            .keys
            .toList());
  }

  DataTable _getResCountDataTable(Map<String, int> predRes) {
    Map<int, int> countMap = {};
    int len = predRes.length;
    for (var value in predRes.values) {
      countMap[value] = (countMap[value] ?? 0) + 1;
    }
    return DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('故障类别')),
          DataColumn(label: Text('出现次数')),
          DataColumn(label: Text('出现频率')),
        ],
        rows: countMap
            .map((key, value) {
              return MapEntry(
                DataRow(cells: [
                  DataCell(Text(key.toString())),
                  DataCell(Text(value.toString())),
                  DataCell(Text((value / len).toStringAsFixed(2))),
                ]),
                '',
              );
            })
            .keys
            .toList());
  }

  DataTable _getEvaluationDataTable(PredictionResp res) {
    return DataTable(columns: const <DataColumn>[
      DataColumn(label: Text('precision')),
      DataColumn(label: Text('recall')),
      DataColumn(label: Text('macroF1')),
    ], rows: [
      DataRow(cells: [
        DataCell(Tooltip(message: res.precision.toString(), child: Text(res.precision.toStringAsFixed(2)))),
        DataCell(Tooltip(message: res.recall.toString(), child: Text(res.recall.toStringAsFixed(2)))),
        DataCell(Tooltip(message: res.macroF1.toString(), child: Text(res.macroF1.toStringAsFixed(2)))),
      ])
    ]);
  }

  DataTable _getClassEvaluationDataTable(List<ClassRes> classRes) {
    return DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('类别序号')),
          DataColumn(label: Text('precision')),
          DataColumn(label: Text('recall')),
          DataColumn(label: Text('macroF1')),
        ],
        rows: classRes.map((e) {
          return DataRow(cells: [
            DataCell(Text(classRes.indexOf(e).toString())),
            DataCell(Text(e.precision.toString())),
            DataCell(Text(e.recall.toString())),
            DataCell(Text(e.f1.toString())),
          ]);
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(_kIndex.pageTitle, style: textTheme.headlineLarge),
        width16,
        Row(
          children: [
            ElevatedButton(
              onPressed: () => selectAble.value = !selectAble.value,
              child: Obx(() => Text(!selectAble.value ? '进行预测' : '取消选择')),
            ),
            width16,
            Obx(
              () => IgnorePointer(
                ignoring: !selectAble.value,
                child: AnimatedOpacity(
                  opacity: selectAble.value == true ? 1 : 0,
                  duration: _kAnimationDuration,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selected.isEmpty) {
                        SmartDialog.showToast('请先选择模型');
                      } else {
                        assert(storageProvider.dataSetListResponse.value != null);
                        final Set<DataSet> tDataSet = {
                          if (selectedDataSet.value != null) selectedDataSet.value!,
                        };
                        final res = await Get.dialog(
                          AlertDialog(
                            title: const Text('选择数据集'),
                            content: SizedBox(
                              width: max(MediaQuery.of(context).size.width * 0.8, 400),
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
                      }
                    },
                    child: Text(selectedDataSet.value != null ? selectedDataSet.value!.name : '选择数据集'),
                  ),
                ),
              ),
            ),
            width16,
            Obx(() => IgnorePointer(
                  ignoring: selectAble.value == false,
                  child: AnimatedOpacity(
                    duration: _kAnimationDuration,
                    opacity: selectAble.value ? 1 : 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: updateF1.value,
                          onChanged: updateF1.call,
                        ),
                        width4,
                        const Text('updateF1'),
                      ],
                    ),
                  ),
                )),
            width16,
            Obx(
              () {
                final show = selectedDataSet.value != null && selectAble.value;
                return IgnorePointer(
                  ignoring: !show,
                  child: AnimatedOpacity(
                    opacity: show ? 1 : 0,
                    duration: _kAnimationDuration,
                    child: ElevatedButton(
                      onPressed: () async {
                        assert(selectAble.value == true && selected.length == 1 && selectedDataSet.value != null);
                        final res =
                            await authedAPI.predict(selected.first.id, selectedDataSet.value!.id, updateF1.value);
                        if (res != null) {
                          DataTable predResTable = _getResDataTable(res.predRes);
                          DataTable resCountTable = _getResCountDataTable(res.predRes);
                          DataTable evaTable = _getEvaluationDataTable(res);
                          DataTable classEvaTable = _getClassEvaluationDataTable(res.classRes);
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Result'),
                              content: Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('预测结果:'),
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              width: 300,
                                              child: predResTable,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('评估结果:'),
                                          const SizedBox(height: 10),
                                          SingleChildScrollView(
                                            child: evaTable,
                                          ),
                                          const SizedBox(height: 30),
                                          const Text('各类评估结果:'),
                                          const SizedBox(height: 10),
                                          SingleChildScrollView(
                                            child: classEvaTable,
                                          ),
                                          const SizedBox(height: 30),
                                          const Text('频率统计:'),
                                          const SizedBox(height: 10),
                                          SingleChildScrollView(
                                            child: resCountTable,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('确定'),
                                ),
                                ElevatedButton(
                                  onPressed: () => authedAPI.downloadPredict(),
                                  child: const Text('下载'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text('预测'),
                    ),
                  ),
                );
              },
            ),
            width16,
            Obx(
              () {
                final show = selectAble.value == false;
                return IgnorePointer(
                  ignoring: !show,
                  child: AnimatedOpacity(
                    opacity: show ? 1 : 0,
                    duration: _kAnimationDuration,
                    child: ElevatedButton(
                      onPressed: authedAPI.downloadPredict,
                      child: const Text('预测结果下载'),
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 168, minWidth: 0, maxHeight: 44, minHeight: 44),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  hintText: _kIndex.searchLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: searchString.call,
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(border: Border.all(width: 1.5), borderRadius: BorderRadius.circular(8)),
            width: double.infinity,
            child: SingleChildScrollView(
                child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Obx(_buildBody))),
          ),
        )
      ],
    );
  }
}
