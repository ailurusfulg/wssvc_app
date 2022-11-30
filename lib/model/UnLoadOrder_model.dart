// ignore_for_file: file_names, non_constant_identifier_names

class UnLoadModel {
  late final String sCONTR_KEY; //------ 컨테이너 키
  late final String sContrNO; //-------- 컨테이너 번호
  late final String sCONTR_LOAD_STS; //- 컨테이너 상태
  late final String sWRK_PLN_DT; //----- 작업 예정일
  late final String sWRK_DT; //--------- 작업일
  late final String sIN_PLN_DT; //------ 반입 예정일
  late final String sOT_PLN_DT; //------ 반출 예정일
  late final String sORD_EMP; //-------- 담당자(다큐)
  late final String sARR_CD; //--------- 반출지
  late final String sLINER_CD; //------- 선사
  late final String sVES_CD; //--------- 모선
  late final String sWC_CD; //---------- 야드
  late final String sVehicle; //-------- 차량번호
  late final int sVes_Block;  //-------- 하차위치(블록)
  late final int sVes_Bay;    //-------- 하차위치(베이)

  UnLoadModel(
    this.sCONTR_KEY,
    this.sContrNO,
    this.sCONTR_LOAD_STS,
    this.sWRK_PLN_DT,
    this.sWRK_DT,
    this.sIN_PLN_DT,
    this.sOT_PLN_DT,
    this.sORD_EMP,
    this.sARR_CD,
    this.sLINER_CD,
    this.sVES_CD,
    this.sWC_CD,
    this.sVehicle,
    this.sVes_Block,
    this.sVes_Bay,
  );
}

class UnLoadResponseModel {
  final String sCONTR_KEY; //------ 컨테이너 키
  final String sContrNO; //-------- 컨테이너 번호
  final String sCONTR_LOAD_STS; //- 컨테이너 상태
  final String sWRK_PLN_DT; //----- 작업 예정일
  final String sWRK_DT; //--------- 작업일
  final String sIN_PLN_DT; //------ 반입 예정일
  final String sOT_PLN_DT; //------ 반출 예정일
  final String sORD_EMP; //-------- 담당자(다큐)
  final String sARR_CD; //--------- 반출지
  final String sLINER_CD; //------- 선사
  final String sVES_CD; //--------- 모선
  final String sWC_CD; //---------- 야드
  final String sVehicle; //-------- 차량번호
  final int sVes_Block; //-------- 하차위치(블록)
  final int sVes_Bay;   //-------- 하차위치(베이)

  UnLoadResponseModel({
    required this.sCONTR_KEY,
    required this.sContrNO,
    required this.sCONTR_LOAD_STS,
    required this.sWRK_PLN_DT,
    required this.sWRK_DT,
    required this.sIN_PLN_DT,
    required this.sOT_PLN_DT,
    required this.sORD_EMP,
    required this.sARR_CD,
    required this.sLINER_CD,
    required this.sVES_CD,
    required this.sWC_CD,
    required this.sVehicle,
    required this.sVes_Block,
    required this.sVes_Bay,
  });

  factory UnLoadResponseModel.fromJson(Map<String, dynamic> json) {
    return UnLoadResponseModel(
      sCONTR_KEY: json['CONTR_KEY'] != null ? json['CONTR_KEY'] as String : "",
      sContrNO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
      sCONTR_LOAD_STS: json['CONTR_LOAD_STS'] != null
          ? json['CONTR_LOAD_STS'] as String
          : "",
      sWRK_PLN_DT:
          json['WRK_PLN_DT'] != null ? json['WRK_PLN_DT'] as String : "",
      sWRK_DT: json['WRK_DT'] != null ? json['WRK_DT'] as String : "",
      sIN_PLN_DT: json['IN_PLN_DT'] != null ? json['IN_PLN_DT'] as String : "",
      sOT_PLN_DT: json['OT_PLN_DT'] != null ? json['OT_PLN_DT'] as String : "",
      sORD_EMP: json['ORD_EMP'] != null ? json['ORD_EMP'] as String : "",
      sARR_CD: json['ARR_CD'] != null ? json['ARR_CD'] as String : "",
      sLINER_CD: json['LINER_CD'] != null ? json['LINER_CD'] as String : "",
      sVES_CD: json['VES_CD'] != null ? json['VES_CD'] as String : "",
      sWC_CD: json['WC_CD'] != null ? json['WC_CD'] as String : "",
      sVehicle: json['VEH_NO'] != null ? json['VEH_NO'] as String : "",
      sVes_Block: json['VES_BLOCK'] != null ? json['VES_BLOCK'] as int : 0,
      sVes_Bay: json['VES_BAY'] != null ? json['VES_BAY'] as int : 0
    );
  }
}

class UnLoadResultModel {
  List<UnLoadResponseModel> approval;

  UnLoadResultModel({required this.approval});

  factory UnLoadResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<UnLoadResponseModel> approvalList =
        list.map((i) => UnLoadResponseModel.fromJson(i)).toList();
    return UnLoadResultModel(approval: approvalList);
  }
}
