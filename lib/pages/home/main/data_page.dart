import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/http_api/model.dart';
import 'package:software_cup_web/http_api/storage.dart';
import 'package:software_cup_web/pages/home/main/choose_data_set.dart';
import 'package:software_cup_web/pages/home/main/main_index.dart';
import 'package:flutter/material.dart';
import 'package:software_cup_web/pages/home/main/split_data_set.dart';

const width4 = SizedBox(width: 4);
const width8 = SizedBox(width: 8);
const width16 = SizedBox(width: 16);
const width32 = SizedBox(width: 32);

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
    if (list == null) {
      return const SizedBox();
    }
    final key = searchString.value;
    final copied = list.datasetList.where((element) => element.name.contains(key)).toList();
    return _DataSetTable(dataSets: copied, selectAble: isOnMerging, selected: selected);
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
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
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
        storageProvider.dataSetListResponse.refresh();
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(MainPageIndex.data.pageTitle, style: textTheme.headlineLarge),
            const SizedBox(width: 8),
            Text('上传数据集并划分训练集测试集', style: textTheme.titleLarge)
          ],
        ),
        const SizedBox(height: 16),
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
            const Spacer(flex: 3),
            Expanded(
              child: SizedBox(
                height: 44,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: '搜索数据集',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: searchString.call,
                ),
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
              scrollDirection: Axis.horizontal,
              child: Obx(_buildBody),
            ),
          ),
        )
      ],
    );
  }
}

class _DataSetTable extends StatefulWidget {
  final List<DataSet> dataSets;
  final bool selectAble;
  final Set<DataSet> selected;

  const _DataSetTable({required this.dataSets, this.selectAble = false, this.selected = const {}});

  @override
  _DataSetTableState createState() => _DataSetTableState();
}

class _DataSetTableState extends State<_DataSetTable> {
  bool _sortAscending = true;
  int _sortColumnIndex = 1;

  void _getDetail(DataSet dataSet) {
    // detail
    authedAPI.getDatasetDetail(dataSet.id).then((value) {
      if (value == null) {
        return;
      }
      Get.dialog(
        AlertDialog(
          title: Text(dataSet.name),
          content: Text(value.toJson().toString()),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('关闭')),
          ],
        ),
      );
    });
  }

  DataRow _buildRow(DataSet dataSet) {
    void onSelectChanged(bool? value) {
      if (value == true) {
        widget.selected.add(dataSet);
      } else {
        widget.selected.remove(dataSet);
      }
      setState(() {});
    }

    return DataRow(
      selected: !widget.selectAble ? false : widget.selected.contains(dataSet),
      cells: [
        DataCell(Text(dataSet.name)),
        DataCell(Text(dataSet.id.toString())),
        DataCell(Text(dataSet.createTime)),
        DataCell(Text(dataSet.lineNum.toString())),
        DataCell(Text(dataSet.featureNum.toString())),
        DataCell(Text(dataSet.kClass.toString())),
        DataCell(Text(dataSet.labelState)),
        DataCell(Text(dataSet.source)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => _getDetail(dataSet),
                child: const Text('查看详情'),
              ),
              width4,
              ElevatedButton(
                onPressed: () => authedAPI.downloadDataset(dataSet.id),
                child: const Text('下载'),
              ),
              width4,
              ElevatedButton(
                onPressed: () => authedAPI.deleteDataset(dataSet.id),
                child: const Text('删除'),
              ),
              width4,
              ElevatedButton(
                onPressed: () => Get.dialog(SplitDataSetPopUp(dataSet: dataSet)),
                child: const Text('拆分'),
              ),
            ],
          ),
        ),
      ],
      onSelectChanged: !widget.selectAble ? null : onSelectChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      sortAscending: _sortAscending,
      sortColumnIndex: _sortColumnIndex,
      columns: [
        DataColumn(
            label: const Text('Name'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                widget.dataSets.sort((a, b) => _sort(a.name, b.name));
              });
            }),
        DataColumn(
            label: const Text('ID'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                widget.dataSets.sort((a, b) => _sort(a.id, b.id));
              });
            }),
        DataColumn(
            label: const Text('Create Time'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                widget.dataSets.sort((a, b) => _sort(a.createTime, b.createTime));
              });
            }),
        DataColumn(
            label: const Text('Line Num'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                widget.dataSets.sort((a, b) => _sort(a.lineNum, b.lineNum));
              });
            }),
        DataColumn(
            label: const Text('Feature Num'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                widget.dataSets.sort((a, b) => _sort(a.featureNum, b.featureNum));
              });
            }),
        DataColumn(
            label: const Text('K Class'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                widget.dataSets.sort((a, b) => _sort(a.kClass, b.kClass));
              });
            }),
        DataColumn(
            label: const Text('Label State'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                widget.dataSets.sort((a, b) => _sort(a.labelState, b.labelState));
              });
            }),
        DataColumn(
            label: const Text('Source'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                widget.dataSets.sort((a, b) => _sort(a.source, b.source));
              });
            }),
        const DataColumn(label: SizedBox(width: 360, child: Align(child: Text('Actions')))),
      ],
      rows: widget.dataSets.map(_buildRow).toList(),
    );
  }

  int _sort(dynamic a, dynamic b) {
    if (_sortAscending) {
      return a.compareTo(b);
    } else {
      return b.compareTo(a);
    }
  }
}
