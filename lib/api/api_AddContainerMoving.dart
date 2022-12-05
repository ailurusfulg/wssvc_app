// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/models.dart';

class APIAddContrMove {
  var url = Uri.parse('https://easycontainer.kuls.co.kr/ext/Ezcon_BNP/AddContainerMoving.php');
  String token = "ba7da079703c28825269ae6d44fc7fa3";

  Future getUpdate(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode({
      "TYPE": "UPDATE",
      "FUNCNAME": sFunctionName,
      "PARAMS": sParam,
    });
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "USP_ADD_CONTR_MOVE":
        final response = await http.post(url, body: sBody, headers: headers);
        result = AddContrMoveResultModel.fromJson(json.decode(response.body));
        break;
    }
    return result;
  }
}
