// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      name: json['name'] as String,
      id: json['id'] as int,
      type: json['type'] as String,
      status: json['status'] as String,
      createTime: json['createTime'] as String,
      macroF1: (json['macro_f1'] as num).toDouble(),
      featureNum: json['feature_num'] as int,
      kClass: json['k_class'] as int,
    );

Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'type': instance.type,
      'status': instance.status,
      'createTime': instance.createTime,
      'macro_f1': instance.macroF1,
      'feature_num': instance.featureNum,
      'k_class': instance.kClass,
    };

ModelListResponse _$ModelListResponseFromJson(Map<String, dynamic> json) =>
    ModelListResponse(
      message: json['message'] as String,
      modelNum: json['model_num'] as int,
      modelList: (json['model_list'] as List<dynamic>)
          .map((e) => Model.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModelListResponseToJson(ModelListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'model_num': instance.modelNum,
      'model_list': instance.modelList.map((e) => e.toJson()).toList(),
    };

ModelDetail _$ModelDetailFromJson(Map<String, dynamic> json) => ModelDetail(
      message: json['message'] as String,
      params: json['params'] as Map<String, dynamic>,
      kClass: json['k_class'] as int,
      feature: (json['class_feature'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      reportNum: json['report_num'] as int,
      report: (json['report'] as List<dynamic>)
          .map((e) => ModelReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      remark: json['remark'] as String,
    );

Map<String, dynamic> _$ModelDetailToJson(ModelDetail instance) =>
    <String, dynamic>{
      'message': instance.message,
      'params': instance.params,
      'k_class': instance.kClass,
      'class_feature': instance.feature,
      'report_num': instance.reportNum,
      'report': instance.report.map((e) => e.toJson()).toList(),
      'remark': instance.remark,
    };

DataSetReport _$DataSetReportFromJson(Map<String, dynamic> json) =>
    DataSetReport(
      modelId: json['model_id'] as int,
      precision: (json['precision'] as num).toDouble(),
      recall: (json['recall'] as num).toDouble(),
      macroF1: (json['macro_f1'] as num).toDouble(),
      classRes: (json['class_res'] as List<dynamic>)
          .map((e) => ClassRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataSetReportToJson(DataSetReport instance) =>
    <String, dynamic>{
      'model_id': instance.modelId,
      'precision': instance.precision,
      'recall': instance.recall,
      'macro_f1': instance.macroF1,
      'class_res': instance.classRes.map((e) => e.toJson()).toList(),
    };

ModelReport _$ModelReportFromJson(Map<String, dynamic> json) => ModelReport(
      datasetId: json['dataset_id'] as int,
      precision: (json['precision'] as num).toDouble(),
      recall: (json['recall'] as num).toDouble(),
      macroF1: (json['macro_f1'] as num).toDouble(),
      classRes: (json['class_res'] as List<dynamic>)
          .map((e) => ClassRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModelReportToJson(ModelReport instance) =>
    <String, dynamic>{
      'dataset_id': instance.datasetId,
      'precision': instance.precision,
      'recall': instance.recall,
      'macro_f1': instance.macroF1,
      'class_res': instance.classRes.map((e) => e.toJson()).toList(),
    };

ClassRes _$ClassResFromJson(Map<String, dynamic> json) => ClassRes(
      precision: (json['precision'] as num).toDouble(),
      recall: (json['recall'] as num).toDouble(),
      f1: (json['f1'] as num).toDouble(),
    );

Map<String, dynamic> _$ClassResToJson(ClassRes instance) => <String, dynamic>{
      'precision': instance.precision,
      'recall': instance.recall,
      'f1': instance.f1,
    };

DataSetListResponse _$DataSetListResponseFromJson(Map<String, dynamic> json) =>
    DataSetListResponse(
      message: json['message'] as String,
      datasetNum: json['dataset_num'] as int,
      datasetList: (json['dataset_list'] as List<dynamic>)
          .map((e) => DataSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataSetListResponseToJson(
        DataSetListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'dataset_num': instance.datasetNum,
      'dataset_list': instance.datasetList.map((e) => e.toJson()).toList(),
    };

DataSet _$DataSetFromJson(Map<String, dynamic> json) => DataSet(
      name: json['name'] as String,
      id: json['id'] as int,
      createTime: json['createTime'] as String,
      lineNum: json['line_num'] as int,
      featureNum: json['feature_num'] as int,
      kClass: json['k_class'] as int,
      labelState: json['label_state'] as String,
      source: json['source'] as String,
    );

Map<String, dynamic> _$DataSetToJson(DataSet instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'createTime': instance.createTime,
      'line_num': instance.lineNum,
      'feature_num': instance.featureNum,
      'k_class': instance.kClass,
      'label_state': instance.labelState,
      'source': instance.source,
    };

DataSetDetail _$DataSetDetailFromJson(Map<String, dynamic> json) =>
    DataSetDetail(
      message: json['message'] as String,
      kClass: json['k_class'] as int,
      reportNum: json['report_num'] as int,
      report: (json['report'] as List<dynamic>)
          .map((e) => DataSetReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataSetDetailToJson(DataSetDetail instance) =>
    <String, dynamic>{
      'message': instance.message,
      'k_class': instance.kClass,
      'report_num': instance.reportNum,
      'report': instance.report.map((e) => e.toJson()).toList(),
    };

PredictionResp _$PredictionRespFromJson(Map<String, dynamic> json) =>
    PredictionResp(
      message: json['message'] as String,
      predResNum: json['pred_res_num'] as int,
      predRes: Map<String, int>.from(json['pred_res'] as Map),
      macroF1: (json['macro_f1'] as num).toDouble(),
      precision: (json['precision'] as num).toDouble(),
      recall: (json['recall'] as num).toDouble(),
      kClass: json['k_class'] as int,
      classRes: (json['class_res'] as List<dynamic>)
          .map((e) => ClassRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PredictionRespToJson(PredictionResp instance) =>
    <String, dynamic>{
      'message': instance.message,
      'pred_res_num': instance.predResNum,
      'pred_res': instance.predRes,
      'macro_f1': instance.macroF1,
      'precision': instance.precision,
      'recall': instance.recall,
      'k_class': instance.kClass,
      'class_res': instance.classRes.map((e) => e.toJson()).toList(),
    };

TrainStreamData _$TrainStreamDataFromJson(Map<String, dynamic> json) =>
    TrainStreamData(
      message: json['message'] as String?,
      code: json['code'] as String?,
      modelType: json['model_type'] as String?,
      process: (json['process'] as num?)?.toDouble(),
      log: (json['log'] as num?)?.toDouble(),
      result: json['result'] as String?,
    );

Map<String, dynamic> _$TrainStreamDataToJson(TrainStreamData instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'model_type': instance.modelType,
      'process': instance.process,
      'log': instance.log,
      'result': instance.result,
    };
