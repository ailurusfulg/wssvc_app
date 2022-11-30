// ignore_for_file: file_names, non_constant_identifier_names

class BlockModel {
  late final String sBlock_CD;
  late final String sBlock_NM;
  late final String sPlate_Top;

  BlockModel(
    this.sBlock_CD,
    this.sBlock_NM,
    this.sPlate_Top,
  );
}

class BlockResponseModel {
  final String sBlock_CD;
  final String sBlock_NM;
  final String sPlate_Top;

  BlockResponseModel({
    required this.sBlock_CD,
    required this.sBlock_NM,
    required this.sPlate_Top,
  });

  factory BlockResponseModel.fromJson(Map<String, dynamic> json) {
    return BlockResponseModel(
      sBlock_CD: json['BLOCK_CD'] != null ? json['BLOCK_CD'] as String : "",
      sBlock_NM: json['BLOCK_NM'] != null ? json['BLOCK_NM'] as String : "",
      sPlate_Top: json['PLACE_TOP'] != null ? json['PLACE_TOP'] as String : "",
    );
  }
}

class BlockResultModel {
  List<BlockResponseModel> block;

  BlockResultModel({required this.block});

  factory BlockResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<BlockResponseModel> blockList =
        list.map((i) => BlockResponseModel.fromJson(i)).toList();
    return BlockResultModel(block: blockList);
  }
}
