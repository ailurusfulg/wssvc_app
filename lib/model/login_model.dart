// ignore_for_file: non_constant_identifier_names, file_names

class UserModel {
  final String sUserId;
  final String sUserNM;
  final String sCORP_USE_FLG;
  final String sUSER_USE_FLG;
  final String sEFFECT_DT;

  UserModel({
    required this.sUserId,
    required this.sUserNM,
    required this.sCORP_USE_FLG,
    required this.sUSER_USE_FLG,
    required this.sEFFECT_DT,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      sUserId: json['USER_ID'] != null ? json['USER_ID'] as String : "",
      sUserNM: json['USER_NM'] != null ? json['USER_NM'] as String : "",
      sCORP_USE_FLG:
      json['CORP_USE_FLG'] != null ? json['CORP_USE_FLG'] as String : "",
      sUSER_USE_FLG:
      json['USER_USE_FLG'] != null ? json['USER_USE_FLG'] as String : "",
      sEFFECT_DT: json['EFFECT_DT'] != null ? json['EFFECT_DT'] as String : "",
    );
  }

  Map<String, dynamic> toJson() => {
    "USER_ID": sUserId,
    "USER_NM": sUserNM,
    "CORP_USE_FLG": sCORP_USE_FLG,
    "USER_USE_FLG": sUSER_USE_FLG,
    "EFFECT_DT": sEFFECT_DT
  };
}

class ResultModel {
  List<UserModel> user;

  ResultModel({required this.user});

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<UserModel> userList = list.map((i) => UserModel.fromJson(i)).toList();
    return ResultModel(user: userList);
  }
}

class PwdResponseModel {
  final String sResult;

  PwdResponseModel({
    required this.sResult,
  });
  factory PwdResponseModel.fromJson(Map<String, dynamic> json) {
    return PwdResponseModel(
      sResult: json[''] != null ? json[''] as String : "",
    );
  }
}

class PwdResultModel {
  List<PwdResponseModel> result;

  PwdResultModel({required this.result});

  factory PwdResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<PwdResponseModel> resultList =
    list.map((i) => PwdResponseModel.fromJson(i)).toList();
    return PwdResultModel(result: resultList);
  }
}
