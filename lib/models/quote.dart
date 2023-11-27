class Quote{
  String quoteText;
  String quoteAuthor;
  String quoteCategory;

  Quote({required this.quoteText, required this.quoteAuthor, required this.quoteCategory});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'quote': String quoteText,
        'author': String quoteAuthor,
        'category': String quoteCategory,
      } =>
        Quote(
          quoteText: quoteText,
          quoteAuthor: quoteAuthor,
          quoteCategory: quoteCategory,
        ),
      _ => throw const FormatException('Failed to load Quote.'),
    };
  }
}