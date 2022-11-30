// ignore_for_file: file_names, non_constant_identifier_names
class AddContrMoveResponseModel {
  final String rsCode;
  final String rsMsg;

  AddContrMoveResponseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory AddContrMoveResponseModel.fromJson(Map<String, dynamic> json) {
    return AddContrMoveResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class AddContrMoveResultModel {
  List<AddContrMoveResponseModel> result;

  AddContrMoveResultModel({required this.result});

  factory AddContrMoveResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<AddContrMoveResponseModel> resultList =
        list.map((i) => AddContrMoveResponseModel.fromJson(i)).toList();
    return AddContrMoveResultModel(result: resultList);
  }
}
