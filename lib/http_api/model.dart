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

// 1.	status/message：
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

// 1.	status/message：
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
  @JsonKey(name: 'status')
  final int status;
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
  final List<Report> report;
  @JsonKey(name: 'remark')
  final String remark;

  ModelDetail({
    required this.status,
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
}

@JsonSerializable()
class Report {
  @JsonKey(name: 'dataset_id')
  final int datasetId;
  @JsonKey(name: 'precision')
  final double precision;
  @JsonKey(name: 'recall')
  final double recall;
  @JsonKey(name: 'f1')
  final double f1;
  @JsonKey(name: 'class_res')
  final List<ClassRes> classRes;

  Report({
    required this.datasetId,
    required this.precision,
    required this.recall,
    required this.f1,
    required this.classRes,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
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


// 1.	status/message：
// 200：获取成功
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