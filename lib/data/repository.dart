import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dolar/data/model/dolar_response.dart';
import 'package:http/http.dart' as http;


class DolarRepository {
  
  Future<List<DolarResponse?>> fetchDolarInfo() async {
    final response = await http.get(Uri.parse('https://ve.dolarapi.com/v1/dolares'));

    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
      // evitar print en producción; usar debugPrint para memoria limitada
      debugPrint(response.body);
      return decodedJson.map((json) => DolarResponse.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
