// ignore_for_file: non_constant_identifier_names

class LoadModel {
  late final String sCONTR_KEY; //------ 컨테이너 키
  late final String sContrNO; //-------- 컨테이너 번호
  late final String sCONTR_LOAD_STS; //- 컨테이너 상태
  late final String sWRK_PLN_DT; //----- 작업 예정일
  late final String sWRK_DT; //--------- 작업일
  late final String sOT_PLN_DT; //------ 반출 예정일
  late final String sORD_EMP; //-------- 담당자(다큐)
  late final String sARR_CD; //--------- 반출지
  late final String sLINER_CD; //------- 선사
  late final String sVES_CD; //--------- 모선
  late final String sWC_CD; //---------- 야드
  late final String sBlock; //---------- 블록
  late final String sBlock_NM; //------- 블록명
  late final int iBay; //--------------- 베이
  late final int iRow; //--------------- 로우(열)
  late final int iTier; //-------------- 티어(단)
  late final String sVehicle; //-------- 차량번호

  LoadModel(
    this.sCONTR_KEY,
    this.sContrNO,
    this.sCONTR_LOAD_STS,
    this.sWRK_PLN_DT,
    this.sWRK_DT,
    this.sOT_PLN_DT,
    this.sORD_EMP,
    this.sARR_CD,
    this.sLINER_CD,
    this.sVES_CD,
    this.sWC_CD,
    this.sBlock,
    this.sBlock_NM,
    this.iBay,
    this.iRow,
    this.iTier,
    this.sVehicle,
  );
}

class LoadResponseModel {
  final String sContrNO; //-------- 컨테이너 번호
  final String sCONTR_KEY; //------ 컨테이너 키
  final String sCONTR_LOAD_STS; //- 컨테이너 상태
  final String sWRK_PLN_DT; //----- 작업 예정일
  final String sWRK_DT; //--------- 작업일
  final String sOT_PLN_DT; //------ 반출 예정일
  final String sORD_EMP; //--------- 모선
  final String sARR_CD; //--------- 모선
  final String sLINER_CD; //--------- 모선
  final String sVES_CD; //--------- 모선
  final String sWC_CD; //---------- 야드
  final String sBlock; //---------- 블록
  final String sBlock_NM; //------- 블록명
  final int iBay; //--------------- 베이
  final int iRow; //--------------- 로우(열)
  final int iTier; //-------------- 티어(단)
  final String sVehicle; //-------- 차량번호
  LoadResponseModel({
    required this.sCONTR_KEY,
    required this.sContrNO,
    required this.sCONTR_LOAD_STS,
    required this.sWRK_PLN_DT,
    required this.sWRK_DT,
    required this.sOT_PLN_DT,
    required this.sORD_EMP,
    required this.sARR_CD,
    required this.sLINER_CD,
    required this.sVES_CD,
    required this.sWC_CD,
    required this.sBlock,
    required this.sBlock_NM,
    required this.iBay,
    required this.iRow,
    required this.iTier,
    required this.sVehicle,
  });

  factory LoadResponseModel.fromJson(Map<String, dynamic> json) {
    return LoadResponseModel(
      sCONTR_KEY: json['CONTR_KEY'] != null ? json['CONTR_KEY'] as String : "",
      sContrNO: json['CONTR_NO'] != null ? json['CONTR_NO'] as String : "",
      sCONTR_LOAD_STS: json['CONTR_LOAD_STS'] != null
          ? json['CONTR_LOAD_STS'] as String
          : "",
      sWRK_PLN_DT:
          json['WRK_PLN_DT'] != null ? json['WRK_PLN_DT'] as String : "",
      sWRK_DT: json['WRK_DT'] != null ? json['WRK_DT'] as String : "",
      sOT_PLN_DT: json['OT_PLN_DT'] != null ? json['OT_PLN_DT'] as String : "",
      sORD_EMP: json['ORD_EMP'] != null ? json['ORD_EMP'] as String : "",
      sARR_CD: json['ARR_CD'] != null ? json['ARR_CD'] as String : "",
      sLINER_CD: json['LINER_CD'] != null ? json['LINER_CD'] as String : "",
      sVES_CD: json['VES_CD'] != null ? json['VES_CD'] as String : "",
      sWC_CD: json['WC_CD'] != null ? json['WC_CD'] as String : "",
      sBlock: json['BLOCK_CD'] != null ? json['BLOCK_CD'] as String : "",
      sBlock_NM: json['BLOCK_NM'] != null ? json['BLOCK_NM'] as String : "",
      iBay: json['BAY_ID'] != null ? json['BAY_ID'] as int : 0,
      iRow: json['ROW_ID'] != null ? json['ROW_ID'] as int : 0,
      iTier: json['TIER_ID'] != null ? json['TIER_ID'] as int : 0,
      sVehicle: json['VEH_NO'] != null ? json['VEH_NO'] as String : "",
    );
  }
}

class LoadResultModel {
  List<LoadResponseModel> approval;

  LoadResultModel({required this.approval});

  factory LoadResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<LoadResponseModel> approvalList =
        list.map((i) => LoadResponseModel.fromJson(i)).toList();
    return LoadResultModel(approval: approvalList);
  }
}
