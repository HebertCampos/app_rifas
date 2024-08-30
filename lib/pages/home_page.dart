import 'package:app_rifas/models/numeros_model.dart';
import 'package:app_rifas/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/api_constants.dart';

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
                              onTap: () => showPopup(numero.id),
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
              Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.bottomCenter,
                height: 120,
                child: Image.asset(
                    'assets/img_rifa_foot.png'), // Caminho para sua imagem de rodapé
              ),
            ],
          ),
          Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(
                  8.0), // Para adicionar um pequeno espaçamento
              child: InkWell(
                onTap: () async {
                  final url = Uri.parse(instaUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw "Não encontrado $url";
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Link do \nsorteio',
                      style: TextStyle(
                          color: Color.fromARGB(255, 12, 77, 89),
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                    SizedBox(
                      height: 26,
                      child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEBFXCirT08g-Mqzt1m6oD1Z6Dw4Oc9XqwDw&s'),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void showPopup(int id) async {
    final comprado = await apiService.getComprados(id);
    if (comprado != null) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                "${comprado.nome.toUpperCase()} é o dono do número ${comprado.id}!\nEscolha outro 😅😅! \nBoa sorte...",
              ),
              content: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Você pode realizar o pagamente via QR Code ou coipando a chave PIX Copia e Cola',
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Image.asset('assets/pix.png'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Chave PIX',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 242, 92, 132),
                    ),
                    onPressed: () {
                      Clipboard.setData(
                        const ClipboardData(
                            text:
                                '00020126870014BR.GOV.BCB.PIX013664af769b-5063-4c60-b5b0-01eeed2227b80225Rifa da fralda Maria Ísis520400005303986540550.005802BR5925Hebert Douglas da Silva C6009SAO PAULO62140510toOHuBni7I6304237B'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PIX Copia e Cola copiado!'),
                        ),
                      );
                    },
                    child: const Text(
                      'Copiar chave PIX!',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    "Fechar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        },
      );
    } else {
      _showInscricaoForm(id);
    }
  }

  void _showInscricaoForm(int id) {
    final nomeController = TextEditingController();
    final telefoneController = TextEditingController();

    final maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
    );

    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 255, 243, 243),
            title: Text('Pegando o número $id 👏👏👏!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: const Text(
                    '* Após realizar a escolha do seu número, volte no seu número escolhido e pegue a chave PIX!\n* Envie o comprovante para a mamãe ou para o papai!',
                  ),
                ),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Seu Nome',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 242, 92, 132),
                      ),
                    ),
                  ),
                  cursorColor: const Color.fromARGB(255, 242, 92, 132),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 242, 92, 132),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: telefoneController,
                  decoration: const InputDecoration(
                    labelText: 'Seu Telefone',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 242, 92, 132),
                      ),
                    ),
                  ),
                  cursorColor: const Color.fromARGB(255, 242, 92, 132),
                  style:
                      const TextStyle(color: Color.fromARGB(255, 242, 92, 132)),
                  inputFormatters: [maskFormatter],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (nomeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Por favor, insira seu nome!"),
                      ),
                    );
                    return;
                  }
                  if (telefoneController.text.isEmpty ||
                      !RegExp(r'^\(\d{2}\) \d{5}-\d{4}$')
                          .hasMatch(telefoneController.text)) {
                    const SnackBar(
                        content: Text("Por favor, insira seu telefone!"));
                    return;
                  }

                  apiService
                      .inscrever(
                          nomeController.text, telefoneController.text, id)
                      .then((_) {
                    setState(() {
                      futureNumeros = apiService.getNumeros();
                    });
                    Navigator.of(context).pop();
                  });
                },
                child: const Text(
                  'Pegar',
                  style: TextStyle(
                    color: Color.fromARGB(255, 189, 64, 87),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
