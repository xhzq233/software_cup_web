import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

//{
// 	name:		// 模型名称，字符串
// 	id:			// 模型id，整型
// 	type:		 // 使用的模型类型名称，字符串
// 	status:		//模型状态：训练中/已完成
// 	createTime:  // 创建时间，字符串
// 	macro_f1:   // f1得分
// feature_num：// 输入特征
// k_class：	 //k分类（输出）
// },

@JsonSerializable(explicitToJson: true)
class Model {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'createTime')
  final String createTime;
  @JsonKey(name: 'macro_f1')
  final double macroF1;
  @JsonKey(name: 'feature_num')
  final int featureNum;
  @JsonKey(name: 'k_class')
  final int kClass;

  Model({
    required this.name,
    required this.id,
    required this.type,
    required this.status,
    required this.createTime,
    required this.macroF1,
    required this.featureNum,
    required this.kClass,
  });

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

// 200：获取成功
// 2.	model_num:
// 3.	model_list:
@JsonSerializable()
class ModelListResponse {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'model_num')
  final int modelNum;
  @JsonKey(name: 'model_list')
  final List<Model> modelList;

  ModelListResponse({
    required this.message,
    required this.modelNum,
    required this.modelList,
  });

  factory ModelListResponse.fromJson(Map<String, dynamic> json) => _$ModelListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModelListResponseToJson(this);
}

// 200：成功
// 404：模型不存在
// 2.  params: // 训练时设定的参数
// {
// epoch:
// …
// }
// 	3.	k_class:	//class数量
// 	4.	feature:	// 每个类别对应的feature,以字符串列表的形式给出,直接显示
// 		形如:[“class1: feature1, feature2”,“class2: feature4,feature11”,…]
// 	5.	report_num: //报告数量
// 6.  report:		//模型报告列表，可以看到对应的数据集
// [
// {
// 	dataset_id:	//该报告对应的数据集
// 	precision:
// 	recall:
// 	f1:
// class_res:		//类型列表，列表元素个数等于k_class
// [
// 		{			//每类的结果
// 			precision:
// 			recall:
// 			f1:
//    },
// …
// ]
// },
// ……
// ]
// 7. remark:		//用户对模型的备注
// 备注：模型详情页面主要显示三个模块：（1）params（2）模型的report列表（3）remark
@JsonSerializable()
class ModelDetail {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'params')
  final Map<String, dynamic> params;
  @JsonKey(name: 'k_class')
  final int kClass;
  @JsonKey(name: 'feature')
  final List<String> feature;
  @JsonKey(name: 'report_num')
  final int reportNum;
  @JsonKey(name: 'report')
  final List<ModelReport> report;
  @JsonKey(name: 'remark')
  final String remark;

  ModelDetail({
    required this.message,
    required this.params,
    required this.kClass,
    required this.feature,
    required this.reportNum,
    required this.report,
    required this.remark,
  });

  factory ModelDetail.fromJson(Map<String, dynamic> json) => _$ModelDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ModelDetailToJson(this);

  @override
  String toString() {
    return codec.convert(toJson());
  }
}

// {
//       "class_res": [
//         {
//           "f1": 0.89,
//           "precision": 0.9,
//           "recall": 0.9
//         },
//         {
//           "f1": 0.89,
//           "precision": 0.9,
//           "recall": 0.9
//         }
//       ],
//       "macro_f1": 0.89,
//       "model_id": 10000,
//       "precision": 0.9,
//       "recall": 0.9
//     }
@JsonSerializable()
class DataSetReport {
  @JsonKey(name: 'model_id')
  final int modelId;
  @JsonKey(name: 'precision')
  final double precision;
  @JsonKey(name: 'recall')
  final double recall;
  @JsonKey(name: 'macro_f1')
  final double macroF1;
  @JsonKey(name: 'class_res')
  final List<ClassRes> classRes;

  DataSetReport({
    required this.modelId,
    required this.precision,
    required this.recall,
    required this.macroF1,
    required this.classRes,
  });

  factory DataSetReport.fromJson(Map<String, dynamic> json) => _$DataSetReportFromJson(json);

  Map<String, dynamic> toJson() => _$DataSetReportToJson(this);
}

@JsonSerializable()
class ModelReport {
  @JsonKey(name: 'dataset_id')
  final int datasetId;
  @JsonKey(name: 'precision')
  final double precision;
  @JsonKey(name: 'recall')
  final double recall;
  @JsonKey(name: 'macro_f1')
  final double macroF1;
  @JsonKey(name: 'class_res')
  final List<ClassRes> classRes;

  ModelReport({
    required this.datasetId,
    required this.precision,
    required this.recall,
    required this.macroF1,
    required this.classRes,
  });

  factory ModelReport.fromJson(Map<String, dynamic> json) => _$ModelReportFromJson(json);

  Map<String, dynamic> toJson() => _$ModelReportToJson(this);
}

@JsonSerializable()
class ClassRes {
  @JsonKey(name: 'precision')
  final double precision;
  @JsonKey(name: 'recall')
  final double recall;
  @JsonKey(name: 'f1')
  final double f1;

  ClassRes({
    required this.precision,
    required this.recall,
    required this.f1,
  });

  factory ClassRes.fromJson(Map<String, dynamic> json) => _$ClassResFromJson(json);

  Map<String, dynamic> toJson() => _$ClassResToJson(this);
}

// 2.	dataset_num:
// 3.	dataset_list:
// [
// {
// 	name:
// 	id:
// 	createTime:
// line_num：
// feature_num：
// k_class：
// label_state：
// source：
// },
// …
// ]
@JsonSerializable()
class DataSetListResponse {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'dataset_num')
  final int datasetNum;
  @JsonKey(name: 'dataset_list')
  final List<DataSet> datasetList;

  DataSetListResponse({
    required this.message,
    required this.datasetNum,
    required this.datasetList,
  });

  factory DataSetListResponse.fromJson(Map<String, dynamic> json) => _$DataSetListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DataSetListResponseToJson(this);
}

@JsonSerializable()
class DataSet {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'createTime')
  final String createTime;
  @JsonKey(name: 'line_num')
  final int lineNum;
  @JsonKey(name: 'feature_num')
  final int featureNum;
  @JsonKey(name: 'k_class')
  final int kClass;
  @JsonKey(name: 'label_state')
  final String labelState;
  @JsonKey(name: 'source')
  final String source;

  DataSet({
    required this.name,
    required this.id,
    required this.createTime,
    required this.lineNum,
    required this.featureNum,
    required this.kClass,
    required this.labelState,
    required this.source,
  });

  factory DataSet.fromJson(Map<String, dynamic> json) => _$DataSetFromJson(json);

  Map<String, dynamic> toJson() => _$DataSetToJson(this);
}

// 	2.  k_class:		//class数量
// 3.	report_num: //报告数量
// 4.  report:		//数据集报告列表，可以看到对应的模型（基本同模型报告）
// [
// {
// 	model_id:	//对应的模型
// 	precision:
// 	recall:
// 	f1:
// class_res:		//类型列表,列表元素个数等于k_class
// [
// 		{			//每类的结果
// 			precision:
// 			recall:
// 			f1:
// },
// …
// ]
// },
// ……
// ]
@JsonSerializable()
class DataSetDetail {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'k_class')
  final int kClass;
  @JsonKey(name: 'report_num')
  final int reportNum;
  @JsonKey(name: 'report')
  final List<DataSetReport> report;

  DataSetDetail({
    required this.message,
    required this.kClass,
    required this.reportNum,
    required this.report,
  });

  factory DataSetDetail.fromJson(Map<String, dynamic> json) => _$DataSetDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DataSetDetailToJson(this);

  @override
  String toString() {
    return codec.convert(toJson());
  }
}

// 1．status/message：
// 200：	//成功
// 400：	//所选的数据集不存在/模型与数据集不匹配
// 2．pred_res_num: //预测结果数量
// 3．pred_res: // 预测结果，需要逐条展示
// {
// “0”:2,		//每条测试数据的结果是一个键值对
// …
// }
// 4.macro_f1:	//f1
// 5.precision:	//准确率
// 6. recall:	 //召回率
// 7．k_class:// 每类型测试精度列表长度
// 8．class_res:		// 每类型测试精度列表
// [
// 	{
// 		precision:
// 		recall:
// 		f1:
// },
// …
// ]
@JsonSerializable()
class PredictionResp {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'pred_res_num')
  final int predResNum;
  @JsonKey(name: 'pred_res')
  final Map<String, int> predRes;
  @JsonKey(name: 'macro_f1')
  final double macroF1;
  @JsonKey(name: 'precision')
  final double precision;
  @JsonKey(name: 'recall')
  final double recall;
  @JsonKey(name: 'k_class')
  final int kClass;
  @JsonKey(name: 'class_res')
  final List<ClassRes> classRes;

  PredictionResp({
    required this.message,
    required this.predResNum,
    required this.predRes,
    required this.macroF1,
    required this.precision,
    required this.recall,
    required this.kClass,
    required this.classRes,
  });

  factory PredictionResp.fromJson(Map<String, dynamic> json) => _$PredictionRespFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionRespToJson(this);

  @override
  String toString() {
    return codec.convert(toJson());
  }
}

// 1.	status/message：
// 200：模型训练开始
// 400：参数错误（可能涉及多类型的错误）/名称过长
// 403：模型数量达到上限（待定）
// 2.	code:	//训练成功开始时用于指示训练状态，失败时用于提示参数错误类型
// 0：正在训练
// 1：训练成功结束
// 2：训练异常终止（可能没有）
// 1000：（参数/token缺失）
// 1001：model_name过长或过短
// 1002：dataset_id不存在
// 1003：model_type不存在
// 100x：指示哪个param错误，根据model_type确定（待定）
// 3.	model_type		//仅在code=100x时包含，方便确定参数错误内容
// 4.	process:		//训练进度，仅在code=0时包含
// 5.	log:			//训练时的输出，仅在code=0时包含
// 6．result:		//训练结果，仅在code=1时包含该内容
// 	{
// 		basic:		//模型基础信息，可用于更新模型列表，不显示
// 		{
// 			name:		// 模型名称，字符串
// 			id:			// 模型id，整型
// 			type:		 // 使用的模型类型名称，字符串
// 			status:		//模型状态：训练中/已完成
// 			createTime:  // 创建时间，字符串
// 			macro_f1:   // f1得分
//      feature_num：// 输入特征
//      k_class：	 //k分类（输出）
//     }
//     class_feature: // 每个class对应的feature,json形式，作为结果显示
// {
// “class1”:[“feature1”, “feature10”],
// …
// {
// 	}

@JsonSerializable()
class TrainStreamData {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'code')
  final int? code;

  //仅在code=100x时包含，方便确定参数错误内容
  @JsonKey(name: 'model_type')
  final String? modelType;

  //训练进度，仅在code=0时包含
  @JsonKey(name: 'process')
  final double? process;

  //训练时的输出，仅在code=0时包含
  @JsonKey(name: 'log')
  final String? log;

  //训练结果，仅在code=1时包含该内容
  @JsonKey(name: 'result')
  final TrainResult? result;

  TrainStreamData({
    required this.message,
    required this.code,
    required this.modelType,
    required this.process,
    required this.log,
    required this.result,
  });

  factory TrainStreamData.fromJson(Map<String, dynamic> json) => _$TrainStreamDataFromJson(json);

  Map<String, dynamic> toJson() => _$TrainStreamDataToJson(this);
}

@JsonSerializable()
class TrainResult {
  @JsonKey(name: 'basic')
  final TrainResultBasic basic;
  @JsonKey(name: 'class_feature')
  final Map<String, List<String>> classFeature;

  TrainResult({
    required this.basic,
    required this.classFeature,
  });

  factory TrainResult.fromJson(Map<String, dynamic> json) => _$TrainResultFromJson(json);

  Map<String, dynamic> toJson() => _$TrainResultToJson(this);

  @override
  String toString() {
    return codec.convert(this);
  }
}

@JsonSerializable()
class TrainResultBasic {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'createTime')
  final String createTime;
  @JsonKey(name: 'macro_f1')
  final double macroF1;
  @JsonKey(name: 'feature_num')
  final int featureNum;
  @JsonKey(name: 'k_class')
  final int kClass;

  TrainResultBasic({
    required this.name,
    required this.id,
    required this.type,
    required this.status,
    required this.createTime,
    required this.macroF1,
    required this.featureNum,
    required this.kClass,
  });

  factory TrainResultBasic.fromJson(Map<String, dynamic> json) => _$TrainResultBasicFromJson(json);

  Map<String, dynamic> toJson() => _$TrainResultBasicToJson(this);
}

const codec = JsonEncoder.withIndent('  ');
