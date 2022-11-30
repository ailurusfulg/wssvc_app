// ignore_for_file: file_names, non_constant_identifier_names

class CountContrmodel{
  late final String sBP_CD;
  late final String sBP_NM;
  late final String sCNT_CNTR;
  late final String sIN_PLN_DT;

  CountContrmodel(
      this.sBP_CD,
      this.sBP_NM,
      this.sCNT_CNTR,
      this.sIN_PLN_DT,
  );
}

class CountContrResponsemodel{
  final String sBP_CD;
  final String sBP_NM;
  final String sCNT_CNTR;
  final String sIN_PLN_DT;


  CountContrResponsemodel({
    required this.sBP_CD,
    required this.sBP_NM,
    required this.sCNT_CNTR,
    required this.sIN_PLN_DT,

  });

  factory CountContrResponsemodel.fromJson(Map<String, dynamic> json) {
    return CountContrResponsemodel(
        sBP_CD: json['BP_CD'] != null ? json['BP_CD'] as String : "",
        sBP_NM: json['BP_NM'] != null ? json['BP_NM'] as String : "",
        sCNT_CNTR: json['CNT_CNTR'] != null ? json['CNT_CNTR'] as String : "",
        sIN_PLN_DT: json['IN_PLN_DT'] != null ? json['IN_PLN_DT'] as String : "",
    );
  }
}

class CountContrResultmodel {
  List<CountContrResponsemodel> countcontr;

  CountContrResultmodel({required this.countcontr});

  factory CountContrResultmodel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<CountContrResponsemodel> countcontrList =
      list.map((i) => CountContrResponsemodel.fromJson(i)).toList();
    return CountContrResultmodel(countcontr: countcontrList);
  }
}