class ContrTestmodel {
  late final String sCONTR_KEY;
  late final String sBP_NM;
  late final String sCONTR_NO;
  late final String sOT_PLN_DT;
  late final String sCC_DT;
  late final String sCUSTOMER;
  late final String sREMK;

  ContrTestmodel(
      this.sCONTR_KEY,
      this.sBP_NM,
      this.sCONTR_NO,
      this.sOT_PLN_DT,
      this.sCC_DT,
      this.sCUSTOMER,
      this.sREMK,
      );
}

class ContrTestResponsemodel{
  final String sCONTR_KEY;
  final String sBP_NM;
  final String sCONTR_NO;
  final String sOT_PLN_DT;
  final String sCC_DT;
  final String sCUSTOMER;
  final String sREMK;

  ContrTestResponsemodel({
    required this.sCONTR_KEY,
    required this.sBP_NM,
    required this.sCONTR_NO,
    required this.sOT_PLN_DT,
    required this.sCC_DT,
    required this.sCUSTOMER,
    required this.sREMK,
  });

  factory ContrTestResponsemodel.fromJson(Map<String, dynamic> json) {
    return ContrTestResponsemodel(
      sCONTR_KEY: json['CONTR_KEY'] != null ? json['CONTR_KEY'] as String : "",
      sBP_NM: json['BP_NM'] != null ? json['BP_NM'] as String : "",
      sCONTR_NO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
      sOT_PLN_DT: json['OT_PLN_DT'] != null ? json['OT_PLN_DT'] as String : "",
      sCC_DT: json['CC_DT'] != null ? json['CC_DT'] as String : "",
      sCUSTOMER: json['CUSTOMER'] != null ? json['CUSTOMER'] as String : "",
      sREMK: json['REMK'] != null ? json['REMK'] as String : "",
    );
  }
}

class ContrTestResultmodel {
  List<ContrTestResponsemodel> contrtest;

  ContrTestResultmodel({required this.contrtest});

  factory ContrTestResultmodel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ContrTestResponsemodel> contrtestList =
    list.map((i) => ContrTestResponsemodel.fromJson(i)).toList();
    return ContrTestResultmodel(contrtest: contrtestList);
  }
}