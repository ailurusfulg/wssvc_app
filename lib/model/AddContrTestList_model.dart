// ignore_for_file: file_names, non_constant_identifier_names
class AddContrTestListResponseModel {
  final String rsCode;
  final String rsMsg;

  AddContrTestListResponseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory AddContrTestListResponseModel.fromJson(Map<String, dynamic> json) {
    return AddContrTestListResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class AddContrTestListResultModel {
  List<AddContrTestListResponseModel> result;

  AddContrTestListResultModel({required this.result});

  factory AddContrTestListResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    List<AddContrTestListResponseModel> resultList =
    list.map((i) => AddContrTestListResponseModel.fromJson(i)).toList();
    return AddContrTestListResultModel(result: resultList);
  }
}
