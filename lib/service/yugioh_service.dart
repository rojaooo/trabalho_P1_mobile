import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class YugiohService {
  Future<List<dynamic>> getRandomCard() async {
    try {
      final uri = Uri.parse("https://db.ygoprodeck.com/api/v7/cardinfo.php?language=pt&num=1&offset=0&sort=random&cachebust");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final cardData = decoded['data'][0];

        // Busca a cotação do Dólar atual em Reais
        double exchangeRate = 5.0;
        try {
          final rateUri = Uri.parse("https://economia.awesomeapi.com.br/last/USD-BRL");
          final rateResponse = await http.get(rateUri);
          if (rateResponse.statusCode == 200) {
            final rateDecoded = json.decode(rateResponse.body);
            exchangeRate = double.parse(rateDecoded['USDBRL']['bid']);
          }
        } catch (_) {} // Se falhar, usa o valor de segurança

        cardData['usd_to_brl'] = exchangeRate;
        return [cardData]; // Agora retorna uma lista com a carta única
      }
      throw Exception("Erro ${response.statusCode}: ao buscar carta");
    } on SocketException {
      throw Exception("Erro de conexão com a internet.");
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> searchCardByName(String name) async {
    try {
      // fname faz uma busca ampla (fuzzy) pelo nome digitado
      final encodedName = Uri.encodeComponent(name);
      final uri = Uri.parse("https://db.ygoprodeck.com/api/v7/cardinfo.php?language=pt&fname=$encodedName");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final cardsData = decoded['data'] as List<dynamic>; // Pega TODAS as cartas

        double exchangeRate = 5.0;
        try {
          final rateUri = Uri.parse("https://economia.awesomeapi.com.br/last/USD-BRL");
          final rateResponse = await http.get(rateUri);
          if (rateResponse.statusCode == 200) {
            final rateDecoded = json.decode(rateResponse.body);
            exchangeRate = double.parse(rateDecoded['USDBRL']['bid']);
          }
        } catch (_) {} 

        // Aplica o valor do câmbio em todas as cartas da lista
        for (var card in cardsData) {
          card['usd_to_brl'] = exchangeRate;
        }
        return cardsData;
      } else if (response.statusCode == 400) {
        throw Exception("Nenhuma carta encontrada com o termo '$name'.");
      }
      throw Exception("Erro ${response.statusCode}: ao buscar carta");
    } on SocketException {
      throw Exception("Erro de conexão com a internet.");
    } catch (e) {
      rethrow;
    }
  }
}