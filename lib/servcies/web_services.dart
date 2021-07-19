import 'dart:convert';

import 'package:http/http.dart' as http;

class WebServices {
  Future<http.Response> post(String url, data) async{
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: json.encode(data),
    );
    return response;
  }

  Future<http.Response> get(String url) async{
    var response = await http.get(
      Uri.parse(url),
      headers: {"Content-type": "application/json"},
    );
    return response;
  }
}