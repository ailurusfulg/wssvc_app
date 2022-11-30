// ignore_for_file: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/models.dart';

class APIGetContrInfo {
  var url = Uri.parse('https://easycontainer.kuls.co.kr/ext/Ezcon_BNP/GetContainerInfo.php');
  String token = "ba7da079703c28825269ae6d44fc7fa3";

  Future getSelect(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode({
      "TYPE": "SELECT",
      "FUNCNAME": sFunctionName,
      "TOKEN": token,
      "PARAMS": sParam,
    });
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "USP_GET_CONTR_INFO_A":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ContrInfoAResultModel.fromJson(json.decode(response.body));
        break;
      case "USP_GET_CONTR_INFO_B":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ContrInfoBResultModel.fromJson(json.decode(response.body));
        break;
    }
    return result;
  }
}
