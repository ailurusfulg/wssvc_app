// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_declarations, curly_braces_in_flow_control_structures, avoid_types_as_parameter_names, use_key_in_widget_constructors
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  setItem(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future getItem(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value;
  }

  deleteItem(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
