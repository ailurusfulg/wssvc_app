// ignore_for_file: file_names, non_constant_identifier_names
class AddCheakContrResponseModel {
  final String rsCode;
  final String rsMsg;

  AddCheakContrResponseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory AddCheakContrResponseModel.fromJson(Map<String, dynamic> json) {
    return AddCheakContrResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class AddCheakContrResultModel {
  List<AddCheakContrResponseModel> result;

  AddCheakContrResultModel({required this.result});

  factory AddCheakContrResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<AddCheakContrResponseModel> resultList =
    list.map((i) => AddCheakContrResponseModel.fromJson(i)).toList();
    return AddCheakContrResultModel(result: resultList);
  }
}
