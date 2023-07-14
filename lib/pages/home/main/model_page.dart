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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_kIndex.pageTitle, style: textTheme.headlineLarge),
            width16,
            Text(_kIndex.description, style: textTheme.titleLarge)
          ],
        ),
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
                          Get.dialog(AlertDialog(
                            title: const Text('Result'),
                            content: SingleChildScrollView(
                              child: Text(res.toString()),
                            ),
                            actions: [
                              TextButton(onPressed: () => Get.back(), child: const Text('确定')),
                            ],
                          ));
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
                      child: const Text('上一次预测下载'),
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
