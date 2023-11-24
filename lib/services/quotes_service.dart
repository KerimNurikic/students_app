import '../models/quote.dart';

class QuotesService {
  static const endpoint = 'https://api.api-ninjas.com/v1/quotes';
  static var happinessQuotes = [
    Quote(
        quoteText: 'The grand essentials of happiness are: something to do, something to love, and something to hope for.',
        quoteAuthor: 'Chambers, Allan K.',
        quoteCategory: 'happiness'),
    Quote(
      quoteText: 'We always deceive ourselves twice about the people we love - first to their advantage, then to their disadvantage.', 
      quoteAuthor: 'Albert Camus', 
      quoteCategory: 'love'),
    Quote(
        quoteText: 'We know from our own history that democratic institutions take decades to mature, and we know from past conflicts that freedom is not free.',
        quoteAuthor: 'Jim DeMint',
        quoteCategory: 'history'),
    Quote(
        quoteText: 'Fortunately, somewhere between chance and mystery lies imagination, the only thing that protects our freedom, despite the fact that people keep trying to reduce it or kill it off altogether.',
        quoteAuthor: 'Luis Bunuel',
        quoteCategory: 'imagination'),
    Quote(
        quoteText: 'In oneself lies the whole world and if you know how to look and learn, the door is there and the key is in your hand. Nobody on earth can give you either the key or the door to open, except yourself.',
        quoteAuthor: 'Jiddu Krishnamurti',
        quoteCategory: 'inspirational'),
  ];

  static var loveQuotes = [
    Quote(
        quoteText: 'The grand essentials of happiness are: something to do, something to love, and something to hope for.',
        quoteAuthor: 'Chambers, Allan K.',
        quoteCategory: 'happiness'),
    Quote(
      quoteText: 'We always deceive ourselves twice about the people we love - first to their advantage, then to their disadvantage.', 
      quoteAuthor: 'Albert Camus', 
      quoteCategory: 'love'),
    Quote(
        quoteText: 'We know from our own history that democratic institutions take decades to mature, and we know from past conflicts that freedom is not free.',
        quoteAuthor: 'Jim DeMint',
        quoteCategory: 'history'),
    Quote(
        quoteText: 'Fortunately, somewhere between chance and mystery lies imagination, the only thing that protects our freedom, despite the fact that people keep trying to reduce it or kill it off altogether.',
        quoteAuthor: 'Luis Bunuel',
        quoteCategory: 'imagination'),
    Quote(
        quoteText: 'In oneself lies the whole world and if you know how to look and learn, the door is there and the key is in your hand. Nobody on earth can give you either the key or the door to open, except yourself.',
        quoteAuthor: 'Jiddu Krishnamurti',
        quoteCategory: 'inspirational'),
  ];

  static var imaginationQuotes = [
    Quote(
        quoteText: 'The grand essentials of happiness are: something to do, something to love, and something to hope for.',
        quoteAuthor: 'Chambers, Allan K.',
        quoteCategory: 'happiness'),
    Quote(
      quoteText: 'We always deceive ourselves twice about the people we love - first to their advantage, then to their disadvantage.', 
      quoteAuthor: 'Albert Camus', 
      quoteCategory: 'love'),
    Quote(
        quoteText: 'We know from our own history that democratic institutions take decades to mature, and we know from past conflicts that freedom is not free.',
        quoteAuthor: 'Jim DeMint',
        quoteCategory: 'history'),
    Quote(
        quoteText: 'Fortunately, somewhere between chance and mystery lies imagination, the only thing that protects our freedom, despite the fact that people keep trying to reduce it or kill it off altogether.',
        quoteAuthor: 'Luis Bunuel',
        quoteCategory: 'imagination'),
    Quote(
        quoteText: 'In oneself lies the whole world and if you know how to look and learn, the door is there and the key is in your hand. Nobody on earth can give you either the key or the door to open, except yourself.',
        quoteAuthor: 'Jiddu Krishnamurti',
        quoteCategory: 'inspirational'),
  ];

  static var inspirationalQuotes = [
    Quote(
        quoteText: 'The grand essentials of happiness are: something to do, something to love, and something to hope for.',
        quoteAuthor: 'Chambers, Allan K.',
        quoteCategory: 'happiness'),
    Quote(
      quoteText: 'We always deceive ourselves twice about the people we love - first to their advantage, then to their disadvantage.', 
      quoteAuthor: 'Albert Camus', 
      quoteCategory: 'love'),
    Quote(
        quoteText: 'We know from our own history that democratic institutions take decades to mature, and we know from past conflicts that freedom is not free.',
        quoteAuthor: 'Jim DeMint',
        quoteCategory: 'history'),
    Quote(
        quoteText: 'Fortunately, somewhere between chance and mystery lies imagination, the only thing that protects our freedom, despite the fact that people keep trying to reduce it or kill it off altogether.',
        quoteAuthor: 'Luis Bunuel',
        quoteCategory: 'imagination'),
    Quote(
        quoteText: 'In oneself lies the whole world and if you know how to look and learn, the door is there and the key is in your hand. Nobody on earth can give you either the key or the door to open, except yourself.',
        quoteAuthor: 'Jiddu Krishnamurti',
        quoteCategory: 'inspirational'),
  ];

  static var historyQuotes = [
    Quote(
        quoteText: 'The grand essentials of happiness are: something to do, something to love, and something to hope for.',
        quoteAuthor: 'Chambers, Allan K.',
        quoteCategory: 'happiness'),
    Quote(
      quoteText: 'We always deceive ourselves twice about the people we love - first to their advantage, then to their disadvantage.', 
      quoteAuthor: 'Albert Camus', 
      quoteCategory: 'love'),
    Quote(
        quoteText: 'We know from our own history that democratic institutions take decades to mature, and we know from past conflicts that freedom is not free.',
        quoteAuthor: 'Jim DeMint',
        quoteCategory: 'history'),
    Quote(
        quoteText: 'Fortunately, somewhere between chance and mystery lies imagination, the only thing that protects our freedom, despite the fact that people keep trying to reduce it or kill it off altogether.',
        quoteAuthor: 'Luis Bunuel',
        quoteCategory: 'imagination'),
    Quote(
        quoteText: 'In oneself lies the whole world and if you know how to look and learn, the door is there and the key is in your hand. Nobody on earth can give you either the key or the door to open, except yourself.',
        quoteAuthor: 'Jiddu Krishnamurti',
        quoteCategory: 'inspirational'),
  ];
  static var favoriteQuotes = <Quote>[];

  List<Quote> getQuotesByCategory(String category) {
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

  List<Quote> getFavoriteQuotes(){
    return favoriteQuotes;
  }

  bool isFavorite(Quote quote){
    return favoriteQuotes.contains(quote);
  }

  bool removeFromFavorites(Quote quote){
    favoriteQuotes.remove(quote);
    return true;
  }

  bool addToFavorites(Quote quote, [int index = -1]){
    if(index >= 0){
      favoriteQuotes.insert(index, quote);
    } else{
      favoriteQuotes.add(quote);
    }
    return true;
  }
}
