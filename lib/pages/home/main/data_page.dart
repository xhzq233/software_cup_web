import 'package:get/get.dart';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/http_api/model.dart';
import 'package:software_cup_web/http_api/storage.dart';
import 'package:software_cup_web/pages/home/main/choose_data_set.dart';
import 'package:software_cup_web/pages/home/main/main_index.dart';
import 'package:flutter/material.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final searchString = ''.obs;

  Widget _buildBody() {
    final list = storageProvider.dataSetListResponse.value;
    if (list == null) {
      return const SizedBox();
    }
    final key = searchString.value;
    final copied = list.datasetList.where((element) => element.name.contains(key)).toList();
    return _DataSetTable(dataSets: copied);
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
            Text(
              '上传数据集并划分训练集测试集',
              style: textTheme.titleLarge,
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(onPressed: () => Get.dialog(const ChooseDatasetPopUp()), child: const Text('新建数据集')),
            const Spacer(
              flex: 3,
            ),
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

  const _DataSetTable({required this.dataSets});

  @override
  _DataSetTableState createState() => _DataSetTableState();
}

class _DataSetTableState extends State<_DataSetTable> {
  bool _sortAscending = true;
  int _sortColumnIndex = 1;
  final selected = <DataSet>{};
  bool selectAble = false;

  void _onTap(DataSet dataSet) {
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
        selected.add(dataSet);
      } else {
        selected.remove(dataSet);
      }
      setState(() {});
    }

    void onTap() => _onTap(dataSet);

    return DataRow(
      selected: !selectAble ? false : selected.contains(dataSet),
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
            const Text(
              '查看详情',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: onTap),
      ],
      onSelectChanged: !selectAble ? null : onSelectChanged,
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
        const DataColumn(label: Text('Actions')),
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
