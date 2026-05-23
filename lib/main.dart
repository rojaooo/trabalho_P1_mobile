import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YugiohScreen extends StatefulWidget {
  @override
  _YugiohScreenState createState() => _YugiohScreenState();
}

class _YugiohScreenState extends State<YugiohScreen> {
  // O Future que vai armazenar o nosso crop de dados
  late Future<Map<String, dynamic>> _cardData;

  @override
  void initState() {
    super.initState();
    _cardData = fetchRandomCard();
  }

  // Função responsável pelo harvest do endpoint
  Future<Map<String, dynamic>> fetchRandomCard() async {
    final response = await http.get(
      Uri.parse('https://db.ygoprodeck.com/api/v7/randomcard.php'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha no crop failure da requisição.');
    }
  }

  // Gatilho para nova semeadura de dados
  void _drawNewCard() {
    setState(() {
      _cardData = fetchRandomCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Random Yu-Gi-Oh! Card'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _cardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: Colors.amber);
            } else if (snapshot.hasError) {
              return Text(
                'Erro na conexão',
                style: TextStyle(color: Colors.red),
              );
            } else if (snapshot.hasData) {
              // Navegando no JSON para pegar o nome e a URL da arte
              final cardName = snapshot.data!['name'];
              final imageUrl = snapshot.data!['card_images'][0]['image_url'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cardName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Renderização com tratamento de loading interno
                  Image.network(
                    imageUrl,
                    height: 400,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _drawNewCard,
        backgroundColor: Colors.amber,
        child: Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }
}