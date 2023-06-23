import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

const baseUrl = kReleaseMode ? 'http://150.158.91.154:5000' : 'http://150.158.91.154:5000';

abstract class API extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    log('$runtimeType, baseUrl: $baseUrl');
    // log
    httpClient.addRequestModifier<Object?>((request) {
      log('${request.method} ${request.url} headers: ${request.headers}');
      request.bodyBytes.toBytes().then((value) => log('body: ${utf8.decode(value.toList())}'));
      return request;
    });
    httpClient.addResponseModifier((request, response) {
      log('${response.statusCode} ${response.body}');
      return response;
    });
    httpClient.defaultContentType = 'application/json';
    super.onInit();
  }
}

class UnAuthAPIProvider extends API {
// 登录
// URL：/users/login
// 请求类型：POST
// 参数：
// 1.	username
// 2.	passwd
// 响应内容：
// 1.	status/message：
// 200：登录成功
// 401：用户名或密码错误
// 2.	token：	//登录成功时返回
  Future<Response> login(String username, String passwd) =>
      post('/users/login', {'username': username, 'passwd': passwd});

// 注册
// URL：/users/register
// 请求类型：POST
// 参数：
// 1.	username
// 2.	passwd
// 响应内容：
// 1.	status/message：
// 200：注册成功
// 400：用户名/密码过长/过短
// 409：用户名已存在
// 备注：400为暂定，可能需要细分
  Future<Response> register(String username, String password) =>
      post('/users/register', {'username': username, 'passwd': password});
}

class AuthedProvider extends API {
  final String token;

  AuthedProvider(this.token);

  @override
  void onInit() {
    httpClient.addRequestModifier<Object?>((request) {
      request.headers['token'] = token;
      return request;
    });
    super.onInit();
  }

// 登出
// URL：/users/logout
// 请求类型：POST
// 参数：无
// 请求头：token
// 响应内容：
// 1.	status/message：
// 200：登出成功
// 备注：用于消除token。但不检查username是否安全？
  Future<Response> logout() => post('/users/logout', {});

// 修改密码
// URL：/users/chPasswd
// 请求：POST
// 参数：
// 1.	old_passwd
// 2.	new_passwd
// 请求头：token
// 响应内容：
// 1.	status/message：
// 200：修改成功
// 401：原密码错误
// 备注：
// 1.	暂定登录后允许修改密码
// 2.	对于该api，401可能表示token错误或者原密码错误，视情况而定
  Future<Response> changePassword(String oldPassword, String newPassword) =>
      post('/users/chPasswd', {'old_passwd': oldPassword, 'new_passwd': newPassword});

// 获取模型列表
// URL：/model/getList
// 请求类型：GET
// 参数：
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：获取成功
// 2.	model_num:
// 3.	model_list:
// [
// {
// 	name:		// 模型名称，字符串
// 	id:			// 模型id，整型
// 	type:		 // 使用的模型类型名称，字符串
// 	status:		//模型状态：训练中/已完成
// 	createTime:  // 创建时间，字符串
// 	macro_f1:   // f1得分
// feature_num：// 输入特征
// k_class：	 //k分类（输出）
// },
// …
// ]

  Future<Response> getModelList() => get('/model/getList');

// 删除模型
// URL：/model/del
// 请求类型：POST
// 参数：
// 1.	model_id
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：删除成功
// 403：模型正在训练中不允许删除
// 404：模型不存在
// 备注：因为未设置取消训练功能，暂定训练中的模型不可被删除(前端禁止点击)

  Future<Response> deleteModel(int modelId) => post('/model/del', {'model_id': modelId});

// 修改模型信息
// URL：/model/chInfo
// 请求类型：POST
// 参数：
// 1.	model_id：
// 2.	model_name：	//前端中用户输入获取
// 3.	remark：   	//前端中用户输入获取
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：修改成功
// 400：模型名称/备注过长
// 403：禁止修改
// 404：模型不存在
// 备注：
// 1.	参数model_name和remark是可选的，至少一个
// 2.	403留给公共模型，禁止修改名称和备注（暂定）

  Future<Response> changeModelInfo(int modelId, String modelName, String remark) =>
      post('/model/chInfo', {'model_id': modelId, 'model_name': modelName, 'remark': remark});

// 下载模型
// URL：/download/model/model_id=?
// 请求类型：GET
// 参数：
// 1.	model_id：
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：下载成功
// 404：模型不存在
// 备注：
// 1.	下载类api如果成功就直接返回文件，下同
// 2.	默认流式下载（也可以选择以附件的形式，不知道有什么区别）
// 3.	是否需要限制用户下载数量（返回403）

  Future<Response> downloadModel(int modelId) => get('/download/model/model_id=$modelId');

// 下载模型报告
// URL：/download/report/model_id=?
// 请求类型：GET
// 参数：
// 1.	model_id：
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：下载成功
// 404：模型不存在

  Future<Response> downloadReport(int modelId) => get('/download/report/model_id=$modelId');

// 获取模型详情
// URL：/model/getDetail
// 请求类型：GET
// 参数：
// 1.	model_id：
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：成功
// 404：模型不存在
// 	2.	precision:
// 	3.  lastPred:		//上一次模型使用的结果
// 	{
// 		precision:
// 		recall:
// 		f1:
// }
// 4.  params: // 训练时设定的参数
// {
// epoch:
// …
// }
// 5.  report:		//模型报告
// {
// class_res_num:	//类型列表长度
// class_res:		//类型列表
// [
// 		{			//每类的结果
// 			precision:
// 			recall:
// 			f1:
// 			features: // 每个类别对应的feature,以字符串列表的形式给出
// [
// ,
// ]
// },
// ]
// }
// 6. remark:		//用户对模型的备注

  Future<Response> getModelDetail(int modelId) => get('/model/getDetail?model_id=$modelId');

// 获取数据集列表
// URL：/dataset/getList
// 请求：GET
// 请求头：
// 1.	token
// 响应内容：
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

  Future<Response> getDatasetList() => get('/dataset/getList');

// 数据集拆分
// URL： /dataset/split
// 请求类型：POST
// 参数：
// 1.	dataset_id：
// 2.	ratio:<a:b>	//字符串
// 3.	name1
// 4.	name2
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：成功拆分
// 400：name1/name2名称过长或缺失，或比例不合法
// 404：数据集不存在
// 	2. new_dataset	//两个新的数据集信息
// [
// {
// 				name:
// 				id:
// 				createTime:
// line_num：
// feature_num：
// k_class：
// label_state：
// source：	//数据集来源，如果是拆分得到的则显示源数据集名称
// },
// {}
// ]
// 备注：关于拆分比例，是否需要拆分成两个参数传递

  Future<Response> splitDataset(int datasetId, String ratio, String name1, String name2) =>
      post('/dataset/split', {'dataset_id': datasetId, 'ratio': ratio, 'name1': name1, 'name2': name2});

// 数据集删除
// URL： /dataset/del
// 请求类型：POST
// 参数：
// 1.	dataset_id：
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：成功删除
// 404：数据集不存在

  Future<Response> deleteDataset(int datasetId) => post('/dataset/del', {'dataset_id': datasetId});

// 数据集下载
// URL： /download/dataset/dataset_id=?
// 请求类型：GET
// 参数：
// 1.	dataset_id：
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：下载成功
// 404：数据集不存在

  Future<Response> downloadDataset(int datasetId) => get('/download/dataset/dataset_id=$datasetId');

// 数据集上传
// URL：/upload/dataset/
// 请求类型：POST
// 参数：
// 1.	name：	//数据集的名称并非文件名称
// 2.	file：
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：成功
// 403：文件个数超过上限（待定）
// 413：文件过大
// 2.  new_dataset
// [
// {
// 				name:
// 				id:
// 				createTime:
// line_num：
// feature_num：
// k_class：
// label_state：
// source：
// }
// ]
// 备注：具体如何判断文件过大，以什么标准待定

  Future<Response> uploadDataset(String name, List<int> file, String filename) =>
      post('/upload/dataset', FormData({'name': name, 'file': MultipartFile(file, filename: filename)}));

// 模型训练
// URL：/train
// 请求类型：POST
// 参数：
// 1.	model_name:
// 2.	dataset_id:
// 3.	model_type:		//模型类型
// 4.	params:			//模型参数，每个模型可能不同
// {
// epoch:
// …
// }
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：模型训练开始
// 400：参数错误（可能涉及多类型的错误）/名称过长
// 403：模型数量达到上限（待定）
// 2.	code:	//训练成功开始时用于指示训练状态，失败时用于提示参数错误类型
// 0：正在训练
// 1：训练成功结束
// 2：训练异常终止（可能没有）
// 1001：dataset_id不存在
// 1002：model_type不存在
// 100x：指示param错误，根据model_type确定（待定）
// 3.	model_type		//仅在code=100x时包含，方便确定参数错误内容
// 4.	process:	//训练进度
// 	5.	log:		//训练时的输出
// 	6．	result:		//训练结果，仅在code=1时包含该内容
// 	{
// 		basic:		//模型基础信息，可用于更新模型列表
// 		{
// 			name:		// 模型名称，字符串
// 			id:			// 模型id，整型
// 			type:		 // 使用的模型类型名称，字符串
// 			status:		//模型状态：训练中/已完成
// 			createTime:  // 创建时间，字符串
// 			macro_f1:   // f1得分
// feature_num：// 输入特征
// k_class：	 //k分类（输出）
// }
// precision:	//模型精度
// class_res_num:	//类型列表长度
// class_res:		//类型列表
// [
// 		{			//每类的结果
// 			precision:
// 			recall:
// 			f1:
// 			features: // 每个类别对应的feature,字符串列表
// [
// ,
// ]
// },
// …
// ]
// 	}
// 备注：训练无法开始时返回内容仅包含status、code、message等，具体的错误会在code和message中给出。训练成功开始时持续返回JSON，每个JSON都包含上述内容（1、2、4、5）

  Future<Response> train(String modelName, int datasetId, String modelType, Map<String, dynamic> params) =>
      post('/train', {'model_name': modelName, 'dataset_id': datasetId, 'model_type': modelType, 'params': params});

// 获取正在训练的模型
// URL：/train/training
// 请求类型：GET
// 参数：无
// 请求头：token
// 响应内容：
// 1.	status/message：
// 200：成功
// 404：该用户没有正在训练的模型
// 2.	其他同“模型训练”
// 备注：如果请求成功，则会持续返回训练信息（是否需要禁止重复请求？）

  Future<Response> getTraining() => get('/train/training');

// 模型使用
// URL：/predict
// 请求类型：POST
// 参数：
// 1.	model_id:
// 2.	dataset_id：
// 请求头：
// 1.	token
// 响应内容：
// 1．status/message：
// 200：	//成功
// 400：	//所选的数据集不存在/模型与数据集不匹配
// 2．pred_res_num: //预测结果列表长度
// 3．pred_res: // 预测结果列表
// [
// ans,		//每条测试数据的结果，形如{“id”：“class”}
// …
// ]
// 4．class_res_num:// 每类型测试精度列表长度
// 5．class_res:		// 每类型测试精度列表
// [
// 	{
// 		precision:
// 		recall:
// 		f1:
// },
// ]
  Future<Response> predict(int modelId, int datasetId) =>
      post('/predict', {'model_id': modelId, 'dataset_id': datasetId});

// 预测结果下载
// URL：/download/predict
// 请求类型：GET
// 参数：无
// 请求头：
// 1.	token
// 响应内容：
// 1.	status/message：
// 200：下载成功
// 404：无预测结果可供下载
// 备注：默认返回上一次的结果

  Future<Response> downloadPredict() => get('/download/predict');
}
