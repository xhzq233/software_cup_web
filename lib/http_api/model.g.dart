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
      'model_list': instance.modelList,
    };

ModelDetail _$ModelDetailFromJson(Map<String, dynamic> json) => ModelDetail(
      status: json['status'] as int,
      message: json['message'] as String,
      params: json['params'] as Map<String, dynamic>,
      kClass: json['k_class'] as int,
      feature:
          (json['feature'] as List<dynamic>).map((e) => e as String).toList(),
      reportNum: json['report_num'] as int,
      report: (json['report'] as List<dynamic>)
          .map((e) => Report.fromJson(e as Map<String, dynamic>))
          .toList(),
      remark: json['remark'] as String,
    );

Map<String, dynamic> _$ModelDetailToJson(ModelDetail instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'params': instance.params,
      'k_class': instance.kClass,
      'feature': instance.feature,
      'report_num': instance.reportNum,
      'report': instance.report,
      'remark': instance.remark,
    };

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      datasetId: json['dataset_id'] as int,
      precision: (json['precision'] as num).toDouble(),
      recall: (json['recall'] as num).toDouble(),
      f1: (json['f1'] as num).toDouble(),
      classRes: (json['class_res'] as List<dynamic>)
          .map((e) => ClassRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'dataset_id': instance.datasetId,
      'precision': instance.precision,
      'recall': instance.recall,
      'f1': instance.f1,
      'class_res': instance.classRes,
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
      'dataset_list': instance.datasetList,
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
