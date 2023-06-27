import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:software_cup_web/http_api/http_api.dart';

class ChooseDatasetPopUp extends StatefulWidget {
  const ChooseDatasetPopUp({super.key});

  @override
  State<ChooseDatasetPopUp> createState() => _ChooseDatasetPopUpState();
}

class _ChooseDatasetPopUpState extends State<ChooseDatasetPopUp> {
  final Rx<PlatformFile?> file = Rx(null);
  final nameController = TextEditingController();

  void _upload() {
    final name = nameController.text.isEmpty ? file.value!.name : nameController.text;
    if (kIsWeb) {
      authedAPI.uploadDataset(name, file.value!.bytes!, file.value!.name);
    } else {
      authedAPI.uploadDataset(name, file.value!.path, file.value!.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Align(
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '上传数据集',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    label: Text('新建数据集'),
                    hintText: '输入数据集名称',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // file description
                  Obx(() => Visibility(
                        visible: file.value != null,
                        child: Text(
                          file.value?.name ?? '',
                          style: textTheme.bodyMedium,
                        ),
                      )),
                  // choose file
                  TextButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                        allowMultiple: false,
                      );

                      if (result != null && result.files.isNotEmpty) {
                        file.value = result.files.first;
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: const Text('选择文件'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('取消'),
                  ),
                  Obx(() => TextButton(
                        onPressed: file.value == null ? null : _upload,
                        child: const Text('确定'),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
