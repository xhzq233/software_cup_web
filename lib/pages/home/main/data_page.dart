import 'package:get/get.dart';
import 'package:software_cup_web/http_api/model.dart';
import 'package:software_cup_web/http_api/storage.dart';
import 'package:software_cup_web/pages/home/main/choose_data_set.dart';
import 'package:software_cup_web/pages/home/main/main_index.dart';
import 'package:flutter/material.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  Widget _buildItem(DataSet dataSet) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dataSet.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '数据集大小：${dataSet.lineNum}条',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '上传时间：${dataSet.createTime}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Flexible(child: Text(dataSet.toJson().toString())),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final list = storageProvider.dataSetListResponse.value;
    if (list == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.separated(
      itemBuilder: (ctx, index) {
        return _buildItem(list.datasetList[index]);
      },
      itemCount: list.datasetList.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: ColoredBox(color: Colors.grey, child: SizedBox(height: 1, width: double.infinity)),
        );
      },
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
            const Expanded(
              child: SizedBox(
                height: 44,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: '搜索数据集',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(border: Border.all(width: 1.5), borderRadius: BorderRadius.circular(8)),
            child: Obx(_buildBody),
          ),
        )
      ],
    );
  }
}
