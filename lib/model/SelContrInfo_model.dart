class SelContrInfomodel{
  late final String sCONTR_NO;
  late final String sOT_PLN_DT;
  late final String sCC_PLN_DT;
  late final String sBP_NM;
  late final String sCUSTOMER;

  SelContrInfomodel(
      this.sCONTR_NO,
      this.sOT_PLN_DT,
      this.sCC_PLN_DT,
      this.sBP_NM,
      this.sCUSTOMER,
      );
}

class SelContrInfoResponsemodel{
  final String sCONTR_NO;
  final String sOT_PLN_DT;
  final String sCC_PLN_DT;
  final String sBP_NM;
  final String sCUSTOMER;

  SelContrInfoResponsemodel({
    required this.sCONTR_NO,
    required this.sOT_PLN_DT,
    required this.sCC_PLN_DT,
    required this.sBP_NM,
    required this.sCUSTOMER,
  });

  factory SelContrInfoResponsemodel.fromJson(Map<String, dynamic> json) {
    return SelContrInfoResponsemodel(
      sCONTR_NO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
      sBP_NM: json['BP_NM'] != null ? json['BP_NM'] as String : "",
      sOT_PLN_DT: json['OT_PLN_DT'] != null ? json['OT_PLN_DT'] as String : "",
      sCC_PLN_DT: json['CC_PLN_DT'] != null ? json['CC_PLN_DT'] as String : "",
      sCUSTOMER: json['CUSTOMER'] != null ? json['CUSTOMER'] as String : "",
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