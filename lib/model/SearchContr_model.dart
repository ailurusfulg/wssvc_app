// ignore_for_file: file_names, non_constant_identifier_names

class SearchContrModel {
  late final String sBlock_CD;
  late final String sBlock_NM;
  late final int sBay_ID;
  late final int sRow_ID;
  late final int sTier_ID;
  late final String sBP_CD;
  late final String sContr_NO;

  SearchContrModel(
    this.sBlock_CD,
    this.sBlock_NM,
    this.sBay_ID,
    this.sRow_ID,
    this.sTier_ID,
    this.sBP_CD,
    this.sContr_NO,
  );
}

class SearchContrResponseModel {
  final String sBlock_CD;
  final String sBlock_NM;
  final int sBay_ID;
  final int sRow_ID;
  final int sTier_ID;
  final String sBP_CD;
  final String sContr_NO;

  SearchContrResponseModel({
    required this.sBlock_CD,
    required this.sBlock_NM,
    required this.sBay_ID,
    required this.sRow_ID,
    required this.sTier_ID,
    required this.sBP_CD,
    required this.sContr_NO,
  });

  factory SearchContrResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchContrResponseModel(
      sBlock_CD: json['BLOCK_CD'] != null ? json['BLOCK_CD'] as String : "",
      sBlock_NM: json['BLOCK_NM'] != null ? json['BLOCK_NM'] as String : "",
      sBay_ID: json['BAY_ID'] != null ? json['BAY_ID'] as int : 0,
      sRow_ID: json['ROW_ID'] != null ? json['ROW_ID'] as int : 0,
      sTier_ID: json['TIER_ID'] != null ? json['TIER_ID'] as int : 0,
      sBP_CD: json['BP_CD'] != null ? json['BP_CD'] as String : "",
      sContr_NO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
    );
  }
}

class SearchContrResultModel {
  List<SearchContrResponseModel> contr;

  SearchContrResultModel({required this.contr});

  factory SearchContrResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<SearchContrResponseModel> blockList =
        list.map((i) => SearchContrResponseModel.fromJson(i)).toList();
    return SearchContrResultModel(contr: blockList);
  }
}
