class CountContrInfomodel{
  late final String sCONTR_NO;
  late final String sCONTR_KEY;
  late final String sOT_PLN_DT;
  late final String sCC_PLN_DT;
  late final String sCC_DT;
  late final String sBP_NM;

  CountContrInfomodel(
      this.sCONTR_NO,
      this.sCONTR_KEY,
      this.sOT_PLN_DT,
      this.sCC_PLN_DT,
      this.sCC_DT,
      this.sBP_NM,
      );
}

class CountContrInfoResponsemodel{
  final String sCONTR_NO;
  final String sCONTR_KEY;
  final String sOT_PLN_DT;
  final String sCC_PLN_DT;
  final String sCC_DT;
  final String sBP_NM;

  CountContrInfoResponsemodel({
    required this.sCONTR_NO,
    required this.sCONTR_KEY,
    required this.sOT_PLN_DT,
    required this.sCC_PLN_DT,
    required this.sCC_DT,
    required this.sBP_NM,
  });

  factory CountContrInfoResponsemodel.fromJson(Map<String, dynamic> json) {
    return CountContrInfoResponsemodel(
      sCONTR_NO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
      sCONTR_KEY: json['CONTR_KEY'] != null ? json['CONTR_KEY'] as String : "",
      sOT_PLN_DT: json['OT_PLN_DT'] != null ? json['OT_PLN_DT'] as String : "",
      sCC_PLN_DT: json['CC_PLN_DT'] != null ? json['CC_PLN_DT'] as String : "",
      sCC_DT: json['CC_DT'] != null ? json['CC_DT'] as String : "",
      sBP_NM: json['BP_NM'] != null ? json['BP_NM'] as String : "",
    );
  }
}

class CountContrInfoResultmodel {
  List<CountContrInfoResponsemodel> countcontrinfo;

  CountContrInfoResultmodel({required this.countcontrinfo});

  factory CountContrInfoResultmodel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<CountContrInfoResponsemodel> countcontrinfoList =
    list.map((i) => CountContrInfoResponsemodel.fromJson(i)).toList();
    return CountContrInfoResultmodel(countcontrinfo: countcontrinfoList);
  }
}