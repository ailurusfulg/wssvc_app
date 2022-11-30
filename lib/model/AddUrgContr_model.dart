// ignore_for_file: file_names, non_constant_identifier_names
class AddUrgContrResponseModel {
  final String rsCode;
  final String rsMsg;

  AddUrgContrResponseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory AddUrgContrResponseModel.fromJson(Map<String, dynamic> json) {
    return AddUrgContrResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class AddUrgContrResultModel {
  List<AddUrgContrResponseModel> result;

  AddUrgContrResultModel({required this.result});

  factory AddUrgContrResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<AddUrgContrResponseModel> resultList =
        list.map((i) => AddUrgContrResponseModel.fromJson(i)).toList();
    return AddUrgContrResultModel(result: resultList);
  }
}
