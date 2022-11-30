// ignore_for_file: file_names, non_constant_identifier_names

class CheakContrmodel{
  late final String sTEST_NO;
  late final String sTEST_CONTENT;
  late final String sTEST_STS;
  late final String sTEST_DT;
  late final String sREMK;
  late final String sCONTR_KEY;

  CheakContrmodel(
      this.sTEST_NO,
      this.sTEST_CONTENT,
      this.sTEST_STS,
      this.sTEST_DT,
      this.sREMK,
      this.sCONTR_KEY,
      );
}

class CheakContrResponsemodel{
  final String sTEST_NO;
  final String sTEST_CONTENT;
  final String sTEST_STS;
  final String sTEST_DT;
  final String sREMK;
  final String sCONTR_KEY;


  CheakContrResponsemodel({
    required this.sTEST_NO,
    required this.sTEST_CONTENT,
    required this.sTEST_STS,
    required this.sTEST_DT,
    required this.sREMK,
    required this.sCONTR_KEY,

  });

  factory CheakContrResponsemodel.fromJson(Map<String, dynamic> json) {
    return CheakContrResponsemodel(
      sTEST_NO: json['TEST_NO'] != null ? json['TEST_NO'] as String : "",
      sTEST_CONTENT: json['TEST_CONTENT'] != null ? json['TEST_CONTENT'] as String : "",
      sTEST_STS: json['TEST_STS'] != null ? json['TEST_STS'] as String : "",
      sTEST_DT: json['TEST_DT'] != null ? json['TEST_DT'] as String : "",
      sREMK: json['REMK'] != null ? json['REMK'] as String : "",
      sCONTR_KEY: json['CONTR_KEY'] != null ? json['CONTR_KEY'] as String : "",
    );
  }
}

class CheakContrResultmodel {
  List<CheakContrResponsemodel> cheakcontr;

  CheakContrResultmodel({required this.cheakcontr});

  factory CheakContrResultmodel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<CheakContrResponsemodel> cheakcontrList =
    list.map((i) => CheakContrResponsemodel.fromJson(i)).toList();
    return CheakContrResultmodel(cheakcontr: cheakcontrList);
  }
}