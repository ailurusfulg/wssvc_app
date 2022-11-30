// ignore_for_file: file_names, non_constant_identifier_names
class CnlContrWRKResponseModel {
  final String rsCode;
  final String rsMsg;

  CnlContrWRKResponseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory CnlContrWRKResponseModel.fromJson(Map<String, dynamic> json) {
    return CnlContrWRKResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class CnlContrWRKResultModel {
  List<CnlContrWRKResponseModel> result;

  CnlContrWRKResultModel({required this.result});

  factory CnlContrWRKResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<CnlContrWRKResponseModel> resultList =
        list.map((i) => CnlContrWRKResponseModel.fromJson(i)).toList();
    return CnlContrWRKResultModel(result: resultList);
  }
}
