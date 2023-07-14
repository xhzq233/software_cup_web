import 'package:flutter/cupertino.dart';
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
  final bool showAction;

  const SCTable({
    super.key,
    required this.data,
    this.selectAble = false,
    this.selected = const {},
    this.limit,
    this.showAction = true,
  });

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

        //report展示
        DataTable reportTable = DataTable(
          columns: const <DataColumn>[
            DataColumn(label: Text('模型')),
            DataColumn(label: Text('precision')),
            DataColumn(label: Text('recall')),
            DataColumn(label: Text('macroF1')),
            DataColumn(label: Text('类别详情'))
          ],
          rows: value.report.map((report) {
            return DataRow(
              cells: [
                DataCell(Text(report.modelId.toString())),
                DataCell(Text(report.precision.toString())),
                DataCell(Text(report.recall.toString())),
                DataCell(Text(report.macroF1.toString())),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('各类别评估结果'),
                          content: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(label: Text('类别序号')),
                                    DataColumn(label: Text('precision')),
                                    DataColumn(label: Text('recall')),
                                    DataColumn(label: Text('macroF1')),
                                  ],
                                  rows: report.classRes.map((e) {
                                    return DataRow(cells: [
                                      DataCell(Text(report.classRes.indexOf(e).toString())),
                                      DataCell(Text(e.precision.toString())),
                                      DataCell(Text(e.recall.toString())),
                                      DataCell(Text(e.f1.toString())),
                                    ]);
                                  }).toList())
                            ],
                          )),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('关闭'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        );

        Get.dialog(
          AlertDialog(
            title: Text(data.name),
            content: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const Text('预测报告:\n'), reportTable],
            )),
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

        //params展示
        String paramsText = '';
        paramsText += '模型参数:\n';
        paramsText += codec.convert(value.params);
        paramsText += '\n';

        //class_feature展示
        DataTable classFeatureTable = DataTable(
            columns: const <DataColumn>[DataColumn(label: Text('故障类别')), DataColumn(label: Text('相关特征'))],
            rows: value.feature.entries
                .map((e) => DataRow(cells: [DataCell(Text(e.key)), DataCell(Text(e.value.join(' ')))]))
                .toList());

        //remark展示
        String remarkText = '';
        remarkText += '备注:\n';
        remarkText += value.remark;
        remarkText += '\n\n';

        //report展示
        DataTable reportTable = DataTable(
          columns: const <DataColumn>[
            DataColumn(label: Text('数据集')),
            DataColumn(label: Text('precision')),
            DataColumn(label: Text('recall')),
            DataColumn(label: Text('macroF1')),
            DataColumn(label: Text('类别详情'))
          ],
          rows: value.report.map((report) {
            return DataRow(
              cells: [
                DataCell(Text(report.datasetId.toString())),
                DataCell(Text(report.precision.toString())),
                DataCell(Text(report.recall.toString())),
                DataCell(Text(report.macroF1.toString())),
                DataCell(
                  IconButton(
                    icon: const Icon(CupertinoIcons.info_circle),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('各类别评估结果'),
                          content: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(label: Text('类别序号')),
                                    DataColumn(label: Text('precision')),
                                    DataColumn(label: Text('recall')),
                                    DataColumn(label: Text('macroF1')),
                                  ],
                                  rows: report.classRes.map((e) {
                                    return DataRow(cells: [
                                      DataCell(Text(report.classRes.indexOf(e).toString())),
                                      DataCell(Text(e.precision.toString())),
                                      DataCell(Text(e.recall.toString())),
                                      DataCell(Text(e.f1.toString())),
                                    ]);
                                  }).toList())
                            ],
                          )),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('关闭'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        );

        Get.dialog(
          AlertDialog(
            title: Text(data.name),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(paramsText),
                  const Text('故障-异常特征对应关系'),
                  classFeatureTable,
                  Text(remarkText),
                  //const SizedBox(height: 10),
                  const Text("预测报告:"),
                  reportTable
                ],
              ),
            ),
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
        if (widget.showAction)
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
        if (widget.showAction)
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
    if (widget.data.isEmpty) {
      return const Center(child: Text('无数据'));
    }
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
        if (widget.showAction) const DataColumn(label: SizedBox(width: 340, child: Align(child: Text('Actions')))),
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
        if (widget.showAction) const DataColumn(label: SizedBox(width: 340, child: Align(child: Text('Actions')))),
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
