// ignore_for_file: file_names, non_constant_identifier_names

class ContrSKTModel {
  late final int iBay_ID;
  late final String sTier1;
  late final String sTier2;
  late final String sTier3;
  late final String sTier4;
  late final String sTier5;
  late final String sTier6;
  late final String sTier7;

  ContrSKTModel(
    this.iBay_ID,
    this.sTier1,
    this.sTier2,
    this.sTier3,
    this.sTier4,
    this.sTier5,
    this.sTier6,
    this.sTier7,
  );
}

class ContrSKTResponseModel {
  final int iBay_ID;
  final String sTier1;
  final String sTier2;
  final String sTier3;
  final String sTier4;
  final String sTier5;
  final String sTier6;
  final String sTier7;

  ContrSKTResponseModel({
    required this.iBay_ID,
    required this.sTier1,
    required this.sTier2,
    required this.sTier3,
    required this.sTier4,
    required this.sTier5,
    required this.sTier6,
    required this.sTier7,
  });

  factory ContrSKTResponseModel.fromJson(Map<String, dynamic> json) {
    return ContrSKTResponseModel(
      iBay_ID: json['BAY_ID'] != null ? json['BAY_ID'] as int : 0,
      sTier1: json['1'] != null ? json['1'] as String : "",
      sTier2: json['2'] != null ? json['2'] as String : "",
      sTier3: json['3'] != null ? json['3'] as String : "",
      sTier4: json['4'] != null ? json['4'] as String : "",
      sTier5: json['5'] != null ? json['5'] as String : "",
      sTier6: json['6'] != null ? json['6'] as String : "",
      sTier7: json['7'] != null ? json['7'] as String : "",
    );
  }
}

class ContrSKTResultModel {
  List<ContrSKTResponseModel> ContrSKT;

  ContrSKTResultModel({required this.ContrSKT});

  factory ContrSKTResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ContrSKTResponseModel> ContrSKTList =
        list.map((i) => ContrSKTResponseModel.fromJson(i)).toList();
    return ContrSKTResultModel(ContrSKT: ContrSKTList);
  }
}
