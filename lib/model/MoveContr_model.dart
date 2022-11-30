// ignore_for_file: file_names, non_constant_identifier_names

class LOC_MoveModel {
  late final String sBlock_CD;
  late final int iBay_ID;
  late final int iRow_ID;
  late final String sTier1;
  late final String sTier2;
  late final String sTier3;
  late final String sTier4;
  late final String sTier5;

  LOC_MoveModel(
    this.sBlock_CD,
    this.iBay_ID,
    this.iRow_ID,
    this.sTier1,
    this.sTier2,
    this.sTier3,
    this.sTier4,
    this.sTier5,
  );
}

class LOC_MoveResponseModel {
  final String sBlock_CD;
  final int iBay_ID;
  final int iRow_ID;
  final String sTier1;
  final String sTier2;
  final String sTier3;
  final String sTier4;
  final String sTier5;

  LOC_MoveResponseModel({
    required this.sBlock_CD,
    required this.iBay_ID,
    required this.iRow_ID,
    required this.sTier1,
    required this.sTier2,
    required this.sTier3,
    required this.sTier4,
    required this.sTier5,
  });

  factory LOC_MoveResponseModel.fromJson(Map<String, dynamic> json) {
    return LOC_MoveResponseModel(
      sBlock_CD: json['BLOCK_CD'] != null ? json['BLOCK_CD'] as String : " ",
      iBay_ID: json['BAY_ID'] != null ? json['BAY_ID'] as int : 0,
      iRow_ID: json['ROW_ID'] != null ? json['ROW_ID'] as int : 0,
      sTier1: json['1'] != null ? json['1'] as String : " ",
      sTier2: json['2'] != null ? json['2'] as String : " ",
      sTier3: json['3'] != null ? json['3'] as String : " ",
      sTier4: json['4'] != null ? json['4'] as String : " ",
      sTier5: json['5'] != null ? json['5'] as String : " ",
    );
  }
}

class LOC_MoveResultModel {
  List<LOC_MoveResponseModel> approval;

  LOC_MoveResultModel({required this.approval});

  factory LOC_MoveResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<LOC_MoveResponseModel> approvalList =
        list.map((i) => LOC_MoveResponseModel.fromJson(i)).toList();
    return LOC_MoveResultModel(approval: approvalList);
  }
}
