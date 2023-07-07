import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/http_api/model.dart';
import '../../../http_api/http_api.dart';
import '../../../http_api/storage.dart';

class SplitDataSetPopUp extends StatefulWidget {
  const SplitDataSetPopUp({super.key, required this.dataSet});

  final DataSet dataSet;

  @override
  State<SplitDataSetPopUp> createState() => _SplitDataSetPopUpState();
}

class _SplitDataSetPopUpState extends State<SplitDataSetPopUp> {
  final name1 = TextEditingController();
  final name2 = TextEditingController();
  double ratio = 0.5;

  void _submit() {
    final int firstQty = (widget.dataSet.lineNum * ratio).toInt();
    final int secondQty = widget.dataSet.lineNum - firstQty;
    authedAPI.splitDataset(widget.dataSet.id, name1.text, name2.text, firstQty, secondQty).then((value) {
      if (value != null) {
        storageProvider.forceGetDatasetList();
        Get.back(result: true);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('拆分数据集'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name1,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              label: Text('数据集1'),
              hintText: '输入数据集名称',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: name2,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              label: Text('数据集2'),
              hintText: '输入数据集名称',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('比例'),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(value: ratio, onChanged: (value) => setState(() => ratio = value)),
              ),
              SizedBox(width: 50, child: Align(child: Text('${(ratio * 100).toInt()}%'))),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text('取消')),
        TextButton(onPressed: _submit, child: const Text('确定')),
      ],
    );
  }
}
