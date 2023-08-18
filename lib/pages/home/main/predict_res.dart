/// software_cup_web - predict_res
/// Created by xhz on 8/18/23

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../http_api/http_api.dart';

class PredictRes extends StatelessWidget {
  const PredictRes({
    super.key,
    required this.url,
    required this.predResTable,
    required this.evaTable,
    required this.classEvaTable,
    required this.resCountTable,
  });

  final String url;

  final Widget predResTable;

  final Widget evaTable;

  final Widget classEvaTable;

  final Widget resCountTable;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                  Image.network('$baseUrl$url'),
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
    );
  }
}
