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
}