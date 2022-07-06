import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService{
  static Future<dynamic> get(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
     // final json = "[${response.body}]";
      return json.decode(response.body);
    }else{
      print("Gen erè ki pase");
    }
  }

  static Future<dynamic> post(String url, {required  Map  body}) async {
    final response = await http.post( Uri.parse(url), body:body );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }else{
      print("Gen erè ki pase");
    }
  }
}