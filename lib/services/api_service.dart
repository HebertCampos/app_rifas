import 'package:app_rifas/models/numeros_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = '';

  Future<List<Numeros>> getNumeros() async {
    final response = await http.get(Uri.parse('$baseUrl/numerosDaSorte'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => Numeros(id: item['id'], marcado: item['marcado']))
          .toList();
    } else {
      throw Exception('Falha ao carregar números');
    }
  }
}
