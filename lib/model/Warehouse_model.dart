
// ignore_for_file: non_constant_identifier_names

class WarehouseModel {
  late final String sWH_CD;
  late final String sWH_NM;
  late final String sBLOCK_CD;

  WarehouseModel(
      this.sWH_CD,
      this.sWH_NM,
      this.sBLOCK_CD,
      );
}

class WarehouseResponseModel {
  final String sWH_CD;
  final String sWH_NM;
  final String sBLOCK_CD;

  WarehouseResponseModel({
    required this.sWH_CD,
    required this.sWH_NM,
    required this.sBLOCK_CD,
  });

  factory WarehouseResponseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseResponseModel(
      sWH_CD: json['WH_CD'] != null ? json['WH_CD'] as String : "",
      sWH_NM: json['WH_NM'] != null ? json['WH_NM'] as String : "",
      sBLOCK_CD: json['BLOCK_CD'] != null ? json['BLOCK_CD'] as String : "",
    );
  }
}

class WarehouseResultModel {
  List<WarehouseResponseModel> warehouse;

  WarehouseResultModel({required this.warehouse});

  factory WarehouseResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<WarehouseResponseModel> warehouseList =
    list.map((i) => WarehouseResponseModel.fromJson(i)).toList();
    return WarehouseResultModel(warehouse: warehouseList);
  }
}
