class SelContrInfomodel{
  late final String sCONTR_NO;
  late final String sOT_PLN_DT;
  late final String sCC_PLN_DT;
  late final String sBP_NM;

  SelContrInfomodel(
      this.sCONTR_NO,
      this.sOT_PLN_DT,
      this.sCC_PLN_DT,
      this.sBP_NM,
      );
}

class SelContrInfoResponsemodel{
  final String sCONTR_NO;
  final String sOT_PLN_DT;
  final String sCC_PLN_DT;
  final String sBP_NM;

  SelContrInfoResponsemodel({
    required this.sCONTR_NO,
    required this.sOT_PLN_DT,
    required this.sCC_PLN_DT,
    required this.sBP_NM,
  });

  factory SelContrInfoResponsemodel.fromJson(Map<String, dynamic> json) {
    return SelContrInfoResponsemodel(
      sCONTR_NO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
      sBP_NM: json['BP_NM'] != null ? json['BP_NM'] as String : "",
      sOT_PLN_DT: json['OT_PLN_DT'] != null ? json['OT_PLN_DT'] as String : "",
      sCC_PLN_DT: json['CC_PLN_DT'] != null ? json['CC_PLN_DT'] as String : "",
    );
  }
}

class SelContrInfoResultmodel {
  List<SelContrInfoResponsemodel> selectcontrinfo;

  SelContrInfoResultmodel({required this.selectcontrinfo});

  factory SelContrInfoResultmodel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<SelContrInfoResponsemodel> selectcontrinfoList =
    list.map((i) => SelContrInfoResponsemodel.fromJson(i)).toList();
    return SelContrInfoResultmodel(selectcontrinfo: selectcontrinfoList);
  }
}