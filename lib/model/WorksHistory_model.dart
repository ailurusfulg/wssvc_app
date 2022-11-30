// ignore_for_file: file_names, non_constant_identifier_names

class WRKHistoryModel {
  late final String sContr_WRK_NO;
  late final String sContr_WRK_Type;
  late final String sContr_WRK_DT;
  late final String sContr_WRK_TM;
  late final String sCONTR_KEY;
  late final String sContr_NO;
  late final String sORD_EMP;
  late final String sBP_SHORT_NM;
  late final String sBlock_CD;
  late final int iBay_ID;
  late final int iRow_ID;
  late final int iTier_ID;
  late final String sVehicle_NO;

  WRKHistoryModel(
    this.sContr_WRK_NO,
    this.sContr_WRK_Type,
    this.sContr_WRK_DT,
    this.sContr_WRK_TM,
    this.sCONTR_KEY,
    this.sContr_NO,
    this.sORD_EMP,
    this.sBP_SHORT_NM,
    this.sBlock_CD,
    this.iBay_ID,
    this.iRow_ID,
    this.iTier_ID,
    this.sVehicle_NO,
  );
}

class WRKHistoryResponseModel {
  final String sContr_WRK_NO;
  final String sContr_WRK_Type;
  final String sContr_WRK_DT;
  final String sContr_WRK_TM;
  final String sCONTR_KEY;
  final String sContr_NO;
  final String sORD_EMP;
  final String sBP_SHORT_NM;
  final String sBlock_CD;
  final int iBay_ID;
  final int iRow_ID;
  final int iTier_ID;
  final String sVehicle_NO;

  WRKHistoryResponseModel({
    required this.sContr_WRK_NO,
    required this.sContr_WRK_Type,
    required this.sContr_WRK_DT,
    required this.sContr_WRK_TM,
    required this.sCONTR_KEY,
    required this.sContr_NO,
    required this.sORD_EMP,
    required this.sBP_SHORT_NM,
    required this.sBlock_CD,
    required this.iBay_ID,
    required this.iRow_ID,
    required this.iTier_ID,
    required this.sVehicle_NO,
  });

  factory WRKHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return WRKHistoryResponseModel(
      sContr_WRK_NO:
          json['CONTR_WRK_NO'] != null ? json['CONTR_WRK_NO'] as String : "",
      sContr_WRK_Type: json['CONTR_WRK_TYPE'] != null
          ? json['CONTR_WRK_TYPE'] as String
          : " ",
      sContr_WRK_DT:
          json['CONTR_WRK_DT'] != null ? json['CONTR_WRK_DT'] as String : "",
      sContr_WRK_TM:
          json['CONTR_WRK_TM'] != null ? json['CONTR_WRK_TM'] as String : "",
      sCONTR_KEY: json['CONTR_KEY'] != null ? json['CONTR_KEY'] as String : "",
      sContr_NO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
      sORD_EMP: json['ORD_EMP'] != null ? json['ORD_EMP'] as String : "",
      sBP_SHORT_NM:
          json['BP_SHORT_NM'] != null ? json['BP_SHORT_NM'] as String : "",
      sBlock_CD: json['BLOCK_CD'] != null ? json['BLOCK_CD'] as String : "",
      iBay_ID: json['BAY_ID'] != null ? json['BAY_ID'] as int : 0,
      iRow_ID: json['ROW_ID'] != null ? json['ROW_ID'] as int : 0,
      iTier_ID: json['TIER_ID'] != null ? json['TIER_ID'] as int : 0,
      sVehicle_NO:
          json['VEH_NO'] != null ? json['VEH_NO'] as String : "",
    );
  }
}

class WRKHistoryResultModel {
  List<WRKHistoryResponseModel> workHistory;

  WRKHistoryResultModel({required this.workHistory});

  factory WRKHistoryResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<WRKHistoryResponseModel> workHistoryList =
        list.map((i) => WRKHistoryResponseModel.fromJson(i)).toList();
    return WRKHistoryResultModel(workHistory: workHistoryList);
  }
}
