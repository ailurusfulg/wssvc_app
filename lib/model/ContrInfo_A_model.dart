// ignore_for_file: file_names, non_constant_identifier_names

class ContrInfoAModel {
  late final String sBlockCD;
  late final int iBay_ID;
  late final int iCapa20;
  late final int iQty20;
  late final int iCan20;
  late final int iCapa40;
  late final int iQty40;
  late final int iCan40;

  ContrInfoAModel(
    this.sBlockCD,
    this.iBay_ID,
    this.iCapa20,
    this.iQty20,
    this.iCan20,
    this.iCapa40,
    this.iQty40,
    this.iCan40,
  );
}

class ContrInfoAResponseModel {
  final String sBlockCD;
  final int iBay_ID;
  final int iCapa20;
  final int iQty20;
  final int iCan20;
  final int iCapa40;
  final int iQty40;
  final int iCan40;
  ContrInfoAResponseModel({
    required this.sBlockCD,
    required this.iBay_ID,
    required this.iCapa20,
    required this.iQty20,
    required this.iCan20,
    required this.iCapa40,
    required this.iQty40,
    required this.iCan40,
  });

  factory ContrInfoAResponseModel.fromJson(Map<String, dynamic> json) {
    return ContrInfoAResponseModel(
      sBlockCD: json['BLOCK_CD'] != null ? json['BLOCK_CD'] as String : "",
      iBay_ID: json['BAY_ID'] != null ? json['BAY_ID'] as int : 0,
      iCapa20: json['CAPA20'] != null ? json['CAPA20'] as int : 0,
      iQty20: json['QTY20'] != null ? json['QTY20'] as int : 0,
      iCan20: json['CAN20'] != null ? json['CAN20'] as int : 0,
      iCapa40: json['CAPA40'] != null ? json['CAPA40'] as int : 0,
      iQty40: json['QTY40'] != null ? json['QTY40'] as int : 0,
      iCan40: json['CAN40'] != null ? json['CAN40'] as int : 0,
    );
  }
}

class ContrInfoAResultModel {
  List<ContrInfoAResponseModel> ContrInfoA;

  ContrInfoAResultModel({required this.ContrInfoA});

  factory ContrInfoAResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ContrInfoAResponseModel> ContrInfoAList =
        list.map((i) => ContrInfoAResponseModel.fromJson(i)).toList();
    return ContrInfoAResultModel(ContrInfoA: ContrInfoAList);
  }
}
