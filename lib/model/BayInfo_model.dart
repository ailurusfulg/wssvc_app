// ignore_for_file: file_names, non_constant_identifier_names

class BayModel {
  late final String sLOC_CD;
  late final int iROW_ID;

  BayModel(
    this.sLOC_CD,
    this.iROW_ID,
  );
}

class BayResponseModel {
  final String sLOC_CD;
  final int iROW_ID;

  BayResponseModel({
    required this.sLOC_CD,
    required this.iROW_ID,
  });

  factory BayResponseModel.fromJson(Map<String, dynamic> json) {
    return BayResponseModel(
      sLOC_CD: json['LOC_CD'] != null ? json['LOC_CD'] as String : "",
      iROW_ID: json['BAY_ID'] != null ? json['BAY_ID'] as int : 0,
    );
  }
}

class BayResultModel {
  List<BayResponseModel> bay;

  BayResultModel({required this.bay});

  factory BayResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<BayResponseModel> bayList =
        list.map((i) => BayResponseModel.fromJson(i)).toList();
    return BayResultModel(bay: bayList);
  }
}
