import 'package:get/get.dart';
import 'package:software_cup_web/http_api/http_api.dart';
import 'package:software_cup_web/http_api/model.dart';
import 'package:software_cup_web/pages/home/main/main_index.dart';

final storageProvider = Get.put(StorageProvider());

class StorageProvider extends GetxService {
  final Rx<DataSetListResponse?> dataSetListResponse = Rx(null);
  final Rx<ModelListResponse?> modelListResponse = Rx(null);

  void switchedMainPageTab(MainPageIndex index) {
    switch (index) {
      case MainPageIndex.data:
        if (dataSetListResponse() == null) {
          authedAPI.getDatasetList().then(dataSetListResponse);
        }
      case MainPageIndex.model:
        if (modelListResponse() == null) {
          authedAPI.getModelList().then(modelListResponse);
        }
      default:
        break;
    }
  }

  void refresh() {
    dataSetListResponse(null);
    modelListResponse(null);
  }

}
