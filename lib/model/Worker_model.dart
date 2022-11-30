// ignore_for_file: file_names, non_constant_identifier_names

class WorkerModel {
  late final String sEMP_NO;
  late final String sEMP_NM;

  WorkerModel(
    this.sEMP_NO,
    this.sEMP_NM,
  );
}

class WorkerResponseModel {
  final String sEMP_NO;
  final String sEMP_NM;

  WorkerResponseModel({
    required this.sEMP_NO,
    required this.sEMP_NM,
  });

  factory WorkerResponseModel.fromJson(Map<String, dynamic> json) {
    return WorkerResponseModel(
      sEMP_NO: json['EMP_NO'] != null ? json['EMP_NO'] as String : "",
      sEMP_NM: json['EMP_NM'] != null ? json['EMP_NM'] as String : "",
    );
  }
}

class WorkerResultModel {
  List<WorkerResponseModel> Worker;

  WorkerResultModel({required this.Worker});

  factory WorkerResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<WorkerResponseModel> WorkerList =
        list.map((i) => WorkerResponseModel.fromJson(i)).toList();
    return WorkerResultModel(Worker: WorkerList);
  }
}
