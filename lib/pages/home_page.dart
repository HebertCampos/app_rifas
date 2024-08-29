import 'package:app_rifas/models/numeros_model.dart';
import 'package:app_rifas/services/api_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Numeros>> futureNumeros;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureNumeros = apiService.getNumeros();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
