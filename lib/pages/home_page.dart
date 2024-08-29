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
    super.initState();
    futureNumeros = apiService.getNumeros();
  }

  Color getColor(int marcado) {
    switch (marcado) {
      case 0:
        return const Color.fromARGB(255, 242, 92, 132); //LIVRE;
      case 1:
        return const Color.fromARGB(255, 12, 77, 89); //CONFIRMADO
      case 2:
        return const Color.fromARGB(255, 189, 64, 87); //ESPERANDO CONFIRMACAO
      default:
        return Colors.white;
    }
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
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 1020 ? 25 : 10;
                    return FutureBuilder<List<Numeros>>(
                      future: futureNumeros,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Erro: ${snapshot.error}",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        final numeros = snapshot.data!;
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 1,
                          ),
                          itemCount: numeros.length,
                          itemBuilder: (context, index) {
                            final numero = numeros[index];
                            return GestureDetector(
                              onTap: () => _showInscricaoForm(numero.id),
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getColor(numero.marcado),
                                ),
                                child: Center(
                                  child: Text(
                                    '${numero.id}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showInscricaoForm(int id) {
    final nomeController = TextEditingController();
    final telefoneController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text('Pegando o número $id 👏👏👏!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Text(
                      '* Após realizar a escolha do seu número, volte no seu número escolhido e pegue a chave pix!\n* Envie o comprovante para a mamãe ou o papai!',
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
