// ignore_for_file: file_names, non_constant_identifier_names

class WRKModel {
  late final String sContr_WRK_DT;
  late final String sMach_ID;
  // late final String sMach_DRV_ID;
  late final int iOT_QTY;
  late final int iIN_QTY;
  late final int iMV_QTY;

  WRKModel(
    this.sContr_WRK_DT,
    this.sMach_ID,
    // this.sMach_DRV_ID,
    this.iOT_QTY,
    this.iIN_QTY,
    this.iMV_QTY,
  );
}

class WRKResponseModel {
  final String sContr_WRK_DT;
  final String sMach_ID;
  // final String sMach_DRV_ID;
  final int iOT_QTY;
  final int iIN_QTY;
  final int iMV_QTY;

  WRKResponseModel({
    required this.sContr_WRK_DT,
    required this.sMach_ID,
    // required this.sMach_DRV_ID,
    required this.iOT_QTY,
    required this.iIN_QTY,
    required this.iMV_QTY,
  });

  factory WRKResponseModel.fromJson(Map<String, dynamic> json) {
    return WRKResponseModel(
      sContr_WRK_DT:
          json['CONTR_WRK_DT'] != null ? json['CONTR_WRK_DT'] as String : "",
      sMach_ID: json['MACH_ID'] != null ? json['MACH_ID'] as String : " ",
      // sMach_DRV_ID:
      // json['MACH_DRV_ID'] != null ? json['MACH_DRV_ID'] as String : " ",
      iOT_QTY: json['OT_QTY'] != null ? json['OT_QTY'] as int : 0,
      iIN_QTY: json['IN_QTY'] != null ? json['IN_QTY'] as int : 0,
      iMV_QTY: json['MV_QTY'] != null ? json['MV_QTY'] as int : 0,
    );
  }
}

class WRKResultModel {
  List<WRKResponseModel> workState;

  WRKResultModel({required this.workState});

  factory WRKResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<WRKResponseModel> workStateList =
        list.map((i) => WRKResponseModel.fromJson(i)).toList();
    return WRKResultModel(workState: workStateList);
  }
}
