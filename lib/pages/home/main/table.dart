import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/pages/home/main/split_data_set.dart';
import '../../../http_api/http_api.dart';
import '../../../http_api/model.dart';
import 'main_index.dart';

class SCTable<T> extends StatefulWidget {
  final List<T> data;
  final bool selectAble;
  final Set<T> selected;
  final int? limit;

  const SCTable({super.key, required this.data, this.selectAble = false, this.selected = const {}, this.limit});

  @override
  State<SCTable<T>> createState() => _SCTableState<T>();
}

class _SCTableState<T> extends State<SCTable<T>> {
  bool _sortAscending = true;
  int _sortColumnIndex = 1;

  bool get reachLimit => !(widget.selectAble && (widget.limit == null || widget.selected.length < (widget.limit!)));

  void _getDetail(T data) {
    if (data is DataSet) {
      // detail
      authedAPI.getDatasetDetail(data.id).then((value) {
        if (value == null) {
          return;
        }
        Get.dialog(
          AlertDialog(
            title: Text(data.name),
            content: SingleChildScrollView(child: Text(value.toString())),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('关闭')),
            ],
          ),
        );
      });
    } else if (data is Model) {
      authedAPI.getModelDetail(data.id).then((value) {
        if (value == null) {
          return;
        }
        Get.dialog(
          AlertDialog(
            title: Text(data.name),
            content: SingleChildScrollView(child: Text(value.toString())),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('关闭')),
            ],
          ),
        );
      });
    }
  }

  DataRow _buildRow(T dataSet) {
    void onSelectChanged(bool? value) {
      if (value == true) {
        if (reachLimit) {
          // 去除第一个
          widget.selected.remove(widget.selected.first);
        }
        widget.selected.add(dataSet);
      } else {
        widget.selected.remove(dataSet);
      }
      setState(() {});
    }

    final cells = <DataCell>[];

    if (dataSet is DataSet) {
      cells.addAll([
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
      ]);
    } else if (dataSet is Model) {
      cells.addAll([
        DataCell(Text(dataSet.name)),
        DataCell(Text(dataSet.id.toString())),
        DataCell(Text(dataSet.type)),
        DataCell(Text(dataSet.status)),
        DataCell(Text(dataSet.createTime)),
        DataCell(Text(dataSet.macroF1.toString())),
        DataCell(Text(dataSet.featureNum.toString())),
        DataCell(Text(dataSet.kClass.toString())),
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
                onPressed: () => authedAPI.downloadModel(dataSet.id),
                child: const Text('下载'),
              ),
              width4,
              ElevatedButton(
                onPressed: () => authedAPI.deleteModel(dataSet.id),
                child: const Text('删除'),
              ),
            ],
          ),
        ),
      ]);
    }

    return DataRow(
      selected: !widget.selectAble ? false : widget.selected.contains(dataSet),
      cells: cells,
      onSelectChanged: !widget.selectAble ? null : onSelectChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final columns = <DataColumn>[];
    // print('build table<T>: $T, widget.data.first.runtimeType: ${widget.data.first.runtimeType}');
    if (widget.data.first is DataSet) {
      final data = widget.data as List<DataSet>;
      columns.addAll([
        DataColumn(
            label: const Text('Name'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.name, b.name));
              });
            }),
        DataColumn(
            label: const Text('ID'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.id, b.id));
              });
            }),
        DataColumn(
            label: const Text('Create Time'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.createTime, b.createTime));
              });
            }),
        DataColumn(
            label: const Text('Line Num'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.lineNum, b.lineNum));
              });
            }),
        DataColumn(
            label: const Text('Feature Num'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.featureNum, b.featureNum));
              });
            }),
        DataColumn(
            label: const Text('K Class'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.kClass, b.kClass));
              });
            }),
        DataColumn(
            label: const Text('Label State'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.labelState, b.labelState));
              });
            }),
        DataColumn(
            label: const Text('Source'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.source, b.source));
              });
            }),
        const DataColumn(label: SizedBox(width: 340, child: Align(child: Text('Actions')))),
      ]);
    } else if (widget.data.first is Model) {
      final data = widget.data as List<Model>;
      columns.addAll([
        DataColumn(
            label: const Text('Name'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.name, b.name));
              });
            }),
        DataColumn(
            label: const Text('ID'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.id, b.id));
              });
            }),
        DataColumn(
            label: const Text('Type'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.type, b.type));
              });
            }),
        DataColumn(
            label: const Text('Status'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.status, b.status));
              });
            }),
        DataColumn(
            label: const Text('Create Time'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.createTime, b.createTime));
              });
            }),
        DataColumn(
            label: const Text('Macro F1'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.macroF1, b.macroF1));
              });
            }),
        DataColumn(
            label: const Text('Feature Num'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.featureNum, b.featureNum));
              });
            }),
        DataColumn(
            label: const Text('K Class'),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortColumnIndex = columnIndex;
                _sortAscending = sortAscending;
                data.sort((a, b) => _sort(a.kClass, b.kClass));
              });
            }),
        const DataColumn(label: SizedBox(width: 340, child: Align(child: Text('Actions')))),
      ]);
    }

    return DataTable(
      sortAscending: _sortAscending,
      sortColumnIndex: _sortColumnIndex,
      columnSpacing: 24,
      horizontalMargin: 16,
      columns: columns,
      rows: widget.data.map(_buildRow).toList(),
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
