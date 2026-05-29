import 'package:flutter/material.dart';
import 'package:yugioh_app/service/yugioh_service.dart';
import 'package:yugioh_app/service/card_translator.dart';

class YugiohPage extends StatefulWidget {
  const YugiohPage({super.key});

  @override
  State<YugiohPage> createState() => _YugiohPageState();
}

class _YugiohPageState extends State<YugiohPage> {
  final YugiohService _apiService = YugiohService();
  Future<List<dynamic>>? _cardsFuture;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomCard();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Atualiza o estado para buscar uma nova carta
  void _fetchRandomCard() {
    _searchController.clear(); // Limpa o conteúdo da barra de pesquisa
    setState(() {
      _isSearchVisible = false; // Esconde a barra ao buscar carta aleatória
      _cardsFuture = _apiService.getRandomCard();
    });
  }

  // Calcula a média de preço a partir dos mercados retornados na API
  double _calculateAveragePrice(Map<String, dynamic> priceData) {
    double total = 0.0;
    int count = 0;

    final keys = [
      'cardmarket_price',
      'tcgplayer_price',
      'ebay_price',
      'amazon_price',
      'coolstuffinc_price',
    ];

    for (var key in keys) {
      if (priceData[key] != null) {
        double? price = double.tryParse(priceData[key].toString());
        if (price != null && price > 0) {
          total += price;
          count++;
        }
      }
    }

    return count > 0 ? total / count : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yu-Gi-Oh! Carta Aleatória',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.amber),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  FocusScope.of(context).unfocus(); // Esconde o teclado se fechar a barra
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imgs/carta.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true, // Faz o teclado abrir automaticamente
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar carta (ex: Dragão Branco)',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black87,
                    suffixIcon: const Icon(Icons.search, color: Colors.amber),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _cardsFuture = _apiService.searchCardByName(value);
                      });
                    }
                  },
                ),
              ),
            Expanded(
              child: Center(
                child: FutureBuilder<List<dynamic>>(
                  future: _cardsFuture,
                  builder: (context, snapshot) {
                    // Tela de Carregamento
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      );
                    }
                    // Tratamento de Erro
                    else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Erro ao carregar carta:\n${snapshot.error}",
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _fetchRandomCard,
                              child: const Text("Tentar Novamente"),
                            ),
                          ],
                        ),
                      );
                    }
                    // Exibição dos Dados
                    else if (snapshot.hasData) {
                      final cards = snapshot.data!;
                      if (cards.isEmpty) {
                        return const Text("Nenhuma carta encontrada", style: TextStyle(color: Colors.white));
                      }

                      // O PageView vai iterar em todos os resultados
                      return PageView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          final name = card['name'] ?? 'Nome Desconhecido';
                          final type = (card['type'] as String? ?? 'Tipo Desconhecido').translated;

                          String imageUrl = '';
                          if (card['card_images'] != null && card['card_images'].isNotEmpty) {
                            imageUrl = card['card_images'][0]['image_url'] ?? '';
                          }

                          double avgPrice = 0.0;
                          if (card['card_prices'] != null && card['card_prices'].isNotEmpty) {
                            avgPrice = _calculateAveragePrice(card['card_prices'][0]);
                          }

                          final exchangeRate = card['usd_to_brl'] ?? 5.0;
                          final avgPriceBrl = avgPrice * exchangeRate;

                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Só exibe a contagem se a busca retornar mais de 1 resultado
                                  if (cards.length > 1)
                                    Text(
                                      "Resultado ${index + 1} de ${cards.length} (Deslize 👉)",
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  if (cards.length > 1) const SizedBox(height: 16),
                                  if (imageUrl.isNotEmpty)
                                    Image.network(
                                      imageUrl,
                                      height: 400,
                                      fit: BoxFit.contain,
                                    ),
                                  const SizedBox(height: 24),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Tipo: $type",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Média de Preço: R\$ ${avgPriceBrl.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const Text(
                      "Nenhum dado encontrado",
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _fetchRandomCard,
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.refresh, color: Colors.black),
        label: const Text(
          "Outra Carta",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
