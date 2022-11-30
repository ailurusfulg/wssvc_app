// ignore_for_file: file_names, non_constant_identifier_names

class ContrInfoBModel {
  late final String sContr_NO;
  late final String sContr_Key;
  late final String sContr_Type_CD;
  late final String sContr_Load_STS;
  late final String sBP_Short_NM;
  late final String sWC_CD;
  late final String sWH_CD;
  late final String sBlock_CD;
  late final int iBay_ID;
  late final int iRow_ID;
  late final int iTier_ID;
  late final String sPLN_DT;
  late final String sContr_STS;
  late final String sEMP_NM;
  late final String sUse_FLG;

  ContrInfoBModel(
    this.sContr_NO,
    this.sContr_Key,
    this.sContr_Type_CD,
    this.sContr_Load_STS,
    this.sBP_Short_NM,
    this.sWC_CD,
    this.sWH_CD,
    this.sBlock_CD,
    this.iBay_ID,
    this.iRow_ID,
    this.iTier_ID,
    this.sPLN_DT,
    this.sContr_STS,
    this.sEMP_NM,
    this.sUse_FLG,
  );
}

class ContrInfoBResponseModel {
  final String sContr_NO;
  final String sContr_Key;
  final String sContr_Type_CD;
  final String sContr_Load_STS;
  final String sBP_Short_NM;
  final String sWC_CD;
  final String sWH_CD;
  final String sBlock_CD;
  final int iBay_ID;
  final int iRow_ID;
  final int iTier_ID;
  final String sIN_DT;
  final String sOT_PLN_DT;
  final String sContr_STS;
  final String sEMP_NM;
  final String sUse_FLG;
  ContrInfoBResponseModel({
    required this.sContr_NO,
    required this.sContr_Key,
    required this.sContr_Type_CD,
    required this.sContr_Load_STS,
    required this.sBP_Short_NM,
    required this.sWC_CD,
    required this.sWH_CD,
    required this.sBlock_CD,
    required this.iBay_ID,
    required this.iRow_ID,
    required this.iTier_ID,
    required this.sIN_DT,
    required this.sOT_PLN_DT,
    required this.sContr_STS,
    required this.sEMP_NM,
    required this.sUse_FLG,
  });

  factory ContrInfoBResponseModel.fromJson(Map<String, dynamic> json) {
    return ContrInfoBResponseModel(
      sContr_NO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
      sContr_Key: json['CONTR_KEY'] != null ? json['CONTR_KEY'] as String : "",
      sContr_Type_CD:
          json['CONTR_TYPE_CD'] != null ? json['CONTR_TYPE_CD'] as String : "",
      sContr_Load_STS: json['CONTR_LOAD_STS'] != null
          ? json['CONTR_LOAD_STS'] as String
          : "",
      sBP_Short_NM:
          json['BP_SHORT_NM'] != null ? json['BP_SHORT_NM'] as String : "",
      sWC_CD: json['WC_CD'] != null ? json['WC_CD'] as String : "",
      sWH_CD: json['WH_CD'] != null ? json['WH_CD'] as String : "",
      sBlock_CD: json['BLOCK_CD'] != null ? json['BLOCK_CD'] as String : "",
      iBay_ID: json['BAY_ID'] != null ? json['BAY_ID'] as int : 0,
      iRow_ID: json['ROW_ID'] != null ? json['ROW_ID'] as int : 0,
      iTier_ID: json['TIER_ID'] != null ? json['TIER_ID'] as int : 0,
      sIN_DT: json['IN_DT'] != null ? json['IN_DT'] as String : "",
      sOT_PLN_DT: json['OT_PLN_DT'] != null ? json['OT_PLN_DT'] as String : "",
      sContr_STS: json['CONTR_STS'] != null ? json['CONTR_STS'] as String : "",
      sEMP_NM: json['EMP_NM'] != null ? json['EMP_NM'] as String : "",
      sUse_FLG: json['USE_FLG'] != null ? json['USE_FLG'] as String : "",
    );
  }
}

class ContrInfoBResultModel {
  List<ContrInfoBResponseModel> ContrInfoB;

  ContrInfoBResultModel({required this.ContrInfoB});

  factory ContrInfoBResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ContrInfoBResponseModel> ContrInfoBList =
        list.map((i) => ContrInfoBResponseModel.fromJson(i)).toList();
    return ContrInfoBResultModel(ContrInfoB: ContrInfoBList);
  }
}
