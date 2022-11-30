// ignore_for_file: file_names, non_constant_identifier_names
class AddContrLoadResponseModel {
  final String rsCode;
  final String rsMsg;

  AddContrLoadResponseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory AddContrLoadResponseModel.fromJson(Map<String, dynamic> json) {
    return AddContrLoadResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class AddContrLoadResultModel {
  List<AddContrLoadResponseModel> result;

  AddContrLoadResultModel({required this.result});

  factory AddContrLoadResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<AddContrLoadResponseModel> resultList =
        list.map((i) => AddContrLoadResponseModel.fromJson(i)).toList();
    return AddContrLoadResultModel(result: resultList);
  }
}
