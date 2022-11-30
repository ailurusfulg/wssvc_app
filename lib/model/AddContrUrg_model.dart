// ignore_for_file: file_names, non_constant_identifier_names
class AddContrUrgResponseModel {
  final String rsCode;
  final String rsMsg;

  AddContrUrgResponseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory AddContrUrgResponseModel.fromJson(Map<String, dynamic> json) {
    return AddContrUrgResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class AddContrUrgResultModel {
  List<AddContrUrgResponseModel> result;

  AddContrUrgResultModel({required this.result});

  factory AddContrUrgResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<AddContrUrgResponseModel> resultList =
        list.map((i) => AddContrUrgResponseModel.fromJson(i)).toList();
    return AddContrUrgResultModel(result: resultList);
  }
}
