class WebProduct {
  final String title;
  final String? price;
  final String source;
  final String url;
  final String? description;

  const WebProduct({
    required this.title,
    this.price,
    required this.source,
    required this.url,
    this.description,
  });

  factory WebProduct.fromJson(Map<String, dynamic> json) {
    return WebProduct(
      title: json['title'] as String? ?? 'Unknown product',
      price: json['price'] as String?,
      source: json['source'] as String? ?? '',
      url: json['url'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}
