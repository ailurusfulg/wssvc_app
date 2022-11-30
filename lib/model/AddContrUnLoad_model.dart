// ignore_for_file: file_names, non_constant_identifier_names
class AddContrUnLoadResponseModel {
  final String rsCode;
  final String rsMsg;

  AddContrUnLoadResponseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory AddContrUnLoadResponseModel.fromJson(Map<String, dynamic> json) {
    return AddContrUnLoadResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class AddContrUnLoadResultModel {
  List<AddContrUnLoadResponseModel> result;

  AddContrUnLoadResultModel({required this.result});

  factory AddContrUnLoadResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<AddContrUnLoadResponseModel> resultList =
        list.map((i) => AddContrUnLoadResponseModel.fromJson(i)).toList();
    return AddContrUnLoadResultModel(result: resultList);
  }
}
