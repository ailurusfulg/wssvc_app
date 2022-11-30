// ignore_for_file: file_names, non_constant_identifier_names

class PartnerModel {
  late final String sBP_CD;
  late final String sBP_NM;
  late final String sBP_SHORT_NM;

  PartnerModel(
      this.sBP_CD,
      this.sBP_NM,
      this.sBP_SHORT_NM,
      );
}

class PartnerResponseModel {
  late final String sBP_CD;
  late final String sBP_NM;
  late final String sBP_SHORT_NM;

  PartnerResponseModel({
    required this.sBP_CD,
    required this.sBP_NM,
    required this.sBP_SHORT_NM,
  });

  factory PartnerResponseModel.fromJson(Map<String, dynamic> json) {
    return PartnerResponseModel(
      sBP_CD: json['BP_CD'] != null ? json['BP_CD'] as String : "",
      sBP_NM: json['BP_NM'] != null ? json['BP_NM'] as String : "",
      sBP_SHORT_NM: json['BP_SHORT_NM'] != null ? json['BP_SHORT_NM'] as String : "",
    );
  }
}

class PartnerResultModel {
  List<PartnerResponseModel> partner;

  PartnerResultModel({required this.partner});

  factory PartnerResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<PartnerResponseModel> partnerList =
      list.map((i) => PartnerResponseModel.fromJson(i)).toList();
    return PartnerResultModel(partner: partnerList);
  }
}
