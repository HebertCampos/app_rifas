import 'package:app_rifas/models/numeros_model.dart';
import 'package:app_rifas/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    super.initState();
    futureNumeros = apiService.getNumeros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img_rifa_fundo.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Container(
                height: 250,
                alignment: Alignment.topCenter,
                child: Image.asset('assets/img_rifa_topo.png'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
