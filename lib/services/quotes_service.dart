import 'dart:convert';

import '../models/quote.dart';
import 'package:http/http.dart' as http;
import './static_test_data.dart' as test_data;

class QuotesService {
  static const endpoint = 'api.api-ninjas.com';
  static const apiKey = 'uWiGSE3WlN3ucIi2J5i7dA==zfJpwiZY1IV5C0uc';
  
  static var favoriteQuotes = <Quote>[];

  static var historyQuotes = test_data.historyQuotes;
  static var loveQuotes = test_data.loveQuotes;
  static var happinessQuotes = test_data.happinessQuotes;
  static var imaginationQuotes = test_data.imaginationQuotes;
  static var inspirationalQuotes = test_data.inspirationalQuotes;


  List<Quote> getCurrentQuotes(String category) {
    switch (category) {
      case 'history':
        return historyQuotes;
      case 'love':
        return loveQuotes;
      case 'happiness':
        return happinessQuotes;
      case 'imagination':
        return imaginationQuotes;
      case 'inspirational':
        return inspirationalQuotes;
      default:
        return List.empty();
    }
  }

  Future<List<Quote>> getFiveQuotesByCategory(String category) async {
    var quotes = <Quote>[];
    int retry = 0;
    for (int i = 0; i < 5; i++) {
      final response = await http.get(
          Uri.https(endpoint, '/v1/quotes', {'category': category}),
          headers: {'X-Api-Key': apiKey});
      if (response.statusCode == 200) {
        quotes.add(
            Quote.fromJson(jsonDecode(response.body)[0] as Map<String, dynamic>));
      } else {
        retry++;
        i--;
        if (retry == 3) {
          throw Exception(jsonDecode(response.body)['error']);
        }
      }
    }
    return quotes;
  }

  Future<List<Quote>> fetchQuotesByCategory(String category) async {
    switch (category) {
      case 'history':
        historyQuotes.clear();
        historyQuotes = await getFiveQuotesByCategory(category);
        return historyQuotes;
      case 'love':
        loveQuotes.clear();
        loveQuotes = await getFiveQuotesByCategory(category);
        return loveQuotes;
      case 'happiness':
        happinessQuotes.clear();
        happinessQuotes = await getFiveQuotesByCategory(category);
        return happinessQuotes;
      case 'imagination':
        imaginationQuotes.clear();
        imaginationQuotes = await getFiveQuotesByCategory(category);
        return imaginationQuotes;
      case 'inspirational':
        inspirationalQuotes.clear();
        inspirationalQuotes = await getFiveQuotesByCategory(category);
        return inspirationalQuotes;
      default:
        return List.empty();
    }
  }

  List<Quote> getFavoriteQuotes() {
    return favoriteQuotes;
  }

  bool isFavorite(Quote quote) {
    return favoriteQuotes.contains(quote);
  }

  bool removeFromFavorites(Quote quote) {
    favoriteQuotes.remove(quote);
    return true;
  }

  bool addToFavorites(Quote quote, [int index = -1]) {
    if (index >= 0) {
      favoriteQuotes.insert(index, quote);
    } else {
      favoriteQuotes.add(quote);
    }
    return true;
  }
}
