// ignore_for_file: file_names, non_constant_identifier_names

class MachModel {
  late final String sMach_ID;
  late final String sMach_Type;

  MachModel(
    this.sMach_ID,
    this.sMach_Type,
  );
}

class MachResponseModel {
  final String sMach_ID;
  final String sMach_Type;

  MachResponseModel({
    required this.sMach_ID,
    required this.sMach_Type,
  });

  factory MachResponseModel.fromJson(Map<String, dynamic> json) {
    return MachResponseModel(
      sMach_ID: json['MACH_ID'] != null ? json['MACH_ID'] as String : "",
      sMach_Type: json['MACH_TYPE'] != null ? json['MACH_TYPE'] as String : "",
    );
  }
}

class MachResultModel {
  List<MachResponseModel> Mach;

  MachResultModel({required this.Mach});

  factory MachResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<MachResponseModel> MachList =
        list.map((i) => MachResponseModel.fromJson(i)).toList();
    return MachResultModel(Mach: MachList);
  }
}
