// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/AddContrTestList_model.dart';
import '../model/models.dart';

class APIAddContrTestList {
  var url = Uri.parse('https://easycontainer.kuls.co.kr/ext/Ezcon/USPWCY0300.php');
  String token = "ba7da079703c28825269ae6d44fc7fa3";

  Future getUpdate(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode({
      "TYPE": "UPDATE",
      "FUNCNAME": sFunctionName,
      "TOKEN": token,
      "PARAMS": sParam,
    });
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "USP_WCY0300_U10":
        final response = await http.post(url, body: sBody, headers: headers);
        result = AddContrTestListResultModel.fromJson(json.decode(response.body));
        break;
    }
    return result;
  }
}
