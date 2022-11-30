// ignore_for_file: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/models.dart';

class APIGetContrTestList {
  var url = Uri.parse('http://LES.kuls.co.kr/ext/Ezcon/USPWCY0300.php');
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
      case "USP_WCY0300":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ContrTestResultmodel.fromJson(json.decode(response.body));
        break;
    }
    return result;
  }
}