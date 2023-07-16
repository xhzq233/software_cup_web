import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/http_api/model.dart';
import 'package:software_cup_web/http_api/storage.dart';
import 'package:software_cup_web/pages/home/main/choose_data_set.dart';
import 'package:software_cup_web/pages/home/main/main_index.dart';
import 'package:flutter/material.dart';
import 'package:software_cup_web/pages/home/main/table.dart';

const _kIndex = MainPageIndex.data;

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final searchString = ''.obs;
  final isOnMerging = false.obs;
  final Set<DataSet> selected = {};

  Widget _buildBody() {
    final list = storageProvider.dataSetListResponse.value;
    final isOnMerging = this.isOnMerging.value;
    if (list == null || list.datasetList.isEmpty) {
      return const SizedBox();
    }
    final key = searchString.value;
    final copied = list.datasetList.where((element) => element.name.contains(key)).toList();
    return SCTable(data: copied, selectAble: isOnMerging, selected: selected);
  }

  void _merge() async {
    if (selected.length < 2) {
      SmartDialog.showToast('请至少选择两个数据集');
      return;
    }

    final controller = TextEditingController();

    // input data name
    final res = await Get.dialog(
      AlertDialog(
        title: const Text('输入数据集名称'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '数据集名称'),
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
    final name = controller.text.isEmpty ? '未命名数据集' : controller.text;

    authedAPI.mergeDataset(name, selected.map((e) => e.id)).then((trueOrFalse) {
      if (trueOrFalse) {
        storageProvider.forceGetDatasetList();
        selected.clear();
        isOnMerging.value = false;
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
        width16,
        Row(
          children: [
            ElevatedButton(onPressed: () => Get.dialog(const ChooseDatasetPopUp()), child: const Text('新建数据集')),
            width16,
            ElevatedButton(
              onPressed: () => isOnMerging.value = !isOnMerging.value,
              child: Obx(() => Text(!isOnMerging.value ? '合并数据集' : '取消合并')),
            ),
            width16,
            Obx(
              () => Visibility(
                visible: isOnMerging.value == true,
                child: ElevatedButton(
                  onPressed: _merge,
                  child: const Text('合并'),
                ),
              ),
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
