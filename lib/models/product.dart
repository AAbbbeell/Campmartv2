class Product {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String seller;
  final String sellerId;
  final String location;
  final String imageUrl;
  final String? description;
  final String? category;
  final bool isVerified;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.currency = '₦',
    required this.seller,
    this.sellerId = '',
    required this.location,
    required this.imageUrl,
    this.description,
    this.category,
    this.isVerified = false,
    this.stock = 0,
  });

  String get formattedPrice => '$currency${price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? currency,
    String? seller,
    String? sellerId,
    String? location,
    String? imageUrl,
    String? description,
    String? category,
    bool? isVerified,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      seller: seller ?? this.seller,
      sellerId: sellerId ?? this.sellerId,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      isVerified: isVerified ?? this.isVerified,
      stock: stock ?? this.stock,
    );
  }

  static List<Product> sampleProducts = [
    const Product(
      id: '1',
      name: 'Bracelet',
      price: 4500,
      seller: 'Amina Adamu',
      location: 'Kwakuti',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD_VW3b4Egcz_tmi6Nd0an_nwgN25Ba3wpB6Mn1C5JhFhazUi4mQP2-mPPY3g6U4frzjAIvh9Syo2eqeKh5kS9BY8VYAS0u87kzNNMV5jKg76dI5nO8Y0PDWaZ2TVY8hx9GOiqOJ2tTA6f_jl2oJ5NDnUSUpRwni3h6-Okk06G0CgKaYYSGBfW2bdri3X5wJ32OxKVIEa4UAG48aUK977zduLObVomyfzDCjsxL3vrl0U48_zwf-wX6XImlFI9me8wrRdVk4caPRPKA',
      description: 'Beautiful handmade bracelet crafted with premium materials. Perfect for casual and formal occasions.',
      category: 'Accessories',
      stock: 10,
    ),
    const Product(
      id: '2',
      name: 'Pearl necklace set',
      price: 4500,
      seller: 'Amina Adamu',
      location: 'Kwakuti',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCdxIQAz--O7K5EwVLDAIwhhnyYtxl91f0GbDNOduo5DnwxuQFiCxjIPuSbxh31qNNw00odayVkrKfPEa9BjvY2CY-9qa5-07mkjdLdg-of-T8JjzCoZhqcRddm46nQmd7KFnQIW0Qf--iJtqbbvKXks7dClahXIB8eVEI08QGnUhqjlS1QnupamA56I4ffbFuMp_xvzNXZdJSryFCyUWMj9PhpvQHH-2gbZ85KSabZhUDKqt37mQi5jyfbQcVeWQDuAZWEWTXAFbo7',
      description: 'Elegant pearl necklace set that adds a touch of class to any outfit. Includes matching earrings.',
      category: 'Jewelry',
      stock: 5,
    ),
    const Product(
      id: '3',
      name: 'Necklace',
      price: 5000,
      seller: 'Amina Adamu',
      location: 'Kwakuti',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBz2xI6dgNp5bznMGN-_v9PaBp7daHosepzNa19VWUXpeo7TQTMStzhLD8dTtlhSURjCs8_XEpd3CJiguCDhUMohXM-da81g2hPnZxLIm-CXCCnMjqd9faq3348r6Fbp_k0sJFzxY6ZEI-2aNNRuY6JnRkf7TJFOZGMTvTUxB_BG3C4ddggdE6VXaw41zyHL0oj-YvrRCZE7UNaffPhAY4eTmuT_Yk9qVD93D9tdAknT7D9FUeXXlnP4pn5yhmVH1YwMWd3MpGgGGCV',
      description: 'Stunning handcrafted necklace with intricate detailing. Lightweight and comfortable for all-day wear.',
      category: 'Jewelry',
      stock: 3,
    ),
    const Product(
      id: '4',
      name: 'Necklace',
      price: 4000,
      seller: 'Amina Adamu',
      location: 'Kwakuti',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCh5DDdWUOdVm3pGtYqaF-dcwMGznt9wuzVAO9-u6fT5YOFFTjTLa-W3XzjUh-jHUZJ3W2t2_lNgTRN3VnmAR4sd5fX5jfVlohUC0v0TwXyesGfDjw4DAjhTzaCS0hgjoynd2sngq5AFfl41tTLCAxO3uuz70wEZNAaszKflp88YWbuR2oU28y6ZCExVkjeL5bOoQCLDJfl3R5hhiFKCnYcoYFn77NNgMxhKyRFUyGlxJ7DZVRSd7LVrRml7PMgBsvGMvf0zjT1_VUN',
      description: 'Affordable yet stylish necklace. Great for daily wear or as a thoughtful gift for loved ones.',
      category: 'Jewelry',
      stock: 8,
    ),
    const Product(
      id: '5',
      name: 'Handmade Bag',
      price: 8500,
      seller: 'Fatima Bello',
      location: 'Main Campus',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD_VW3b4Egcz_tmi6Nd0an_nwgN25Ba3wpB6Mn1C5JhFhazUi4mQP2-mPPY3g6U4frzjAIvh9Syo2eqeKh5kS9BY8VYAS0u87kzNNMV5jKg76dI5nO8Y0PDWaZ2TVY8hx9GOiqOJ2tTA6f_jl2oJ5NDnUSUpRwni3h6-Okk06G0CgKaYYSGBfW2bdri3X5wJ32OxKVIEa4UAG48aUK977zduLObVomyfzDCjsxL3vrl0U48_zwf-wX6XImlFI9me8wrRdVk4caPRPKA',
      description: 'Spacious and durable handmade bag. Features multiple compartments for organized storage. Made from eco-friendly materials.',
      category: 'Bags',
      stock: 2,
    ),
    const Product(
      id: '6',
      name: 'Wireless Earbuds',
      price: 12000,
      seller: 'Ibrahim Suleiman',
      location: 'Tech Hub',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCdxIQAz--O7K5EwVLDAIwhhnyYtxl91f0GbDNOduo5DnwxuQFiCxjIPuSbxh31qNNw00odayVkrKfPEa9BjvY2CY-9qa5-07mkjdLdg-of-T8JjzCoZhqcRddm46nQmd7KFnQIW0Qf--iJtqbbvKXks7dClahXIB8eVEI08QGnUhqjlS1QnupamA56I4ffbFuMp_xvzNXZdJSryFCyUWMj9PhpvQHH-2gbZ85KSabZhUDKqt37mQi5jyfbQcVeWQDuAZWEWTXAFbo7',
      description: 'High-quality wireless earbuds with noise cancellation. Up to 8 hours of battery life. Comfortable fit for all ear sizes.',
      category: 'Electronics',
      stock: 15,
    ),
  ];

  static List<Product> sampleServices = [
    const Product(
      id: 's1',
      name: 'Laundry Service',
      price: 2000,
      seller: 'ABC Laundry',
      location: 'Main Campus',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAwefuL1jENS2Z0LXyaAxBGFF7fn7F-2k1KP87zqAEaQf6VuwmfNNhP16egXhjeNizrYgeILA8ymf8jXHAnXLmC_WtM--XSIuTJcqCv27OQpGUxYwpzKPkauJVEIPffaKV9mCIidrJu87_GrqrTOfUlYPA0Py9xCQ4_gn_Yc0TUSd0LYr1MhcQixYudGvN1yzq21NeAyAFspd2YnVMfl6AKdxONlXkrHACW2ZunEQOHN3zsnHD-wSR8WsvI7YKnMBUj70IFj1QeikJT',
      category: 'Services',
      isVerified: true,
    ),
    const Product(
      id: 's2',
      name: 'Tutorial Session',
      price: 3500,
      seller: 'Dr. Okonkwo',
      location: 'Federal University of Technology',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA8mgA1KYFIVdftse8YJKrPUMR_qYGyxA6M9tzLO8lyLwHuZ50twAK5TfyaTwCFn53UhKpT8pBhAiDJ5UprndgBvGPFGYyx6SgG6B9dWEi3vVegyVhPjJh5eajmssgVOSuvOnTIngF1hpvZ-ebNoWvlF06lOLeBWbQFGGSPaMv0EIXbCPPq1P3WUB5e9c5xct6aLIR1D9Wijfe-vc_GBqGokWNnyOp5306x7cPETt1omlLGWkDLFSSxBlD9BeZmeYqx9X-bwEirkvDI',
      category: 'Services',
    ),
    const Product(
      id: 's3',
      name: 'Hair Styling',
      price: 5000,
      seller: 'Salon Classique',
      location: 'Student Village',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBz2xI6dgNp5bznMGN-_v9PaBp7daHosepzNa19VWUXpeo7TQTMStzhLD8dTtlhSURjCs8_XEpd3CJiguCDhUMohXM-da81g2hPnZxLIm-CXCCnMjqd9faq3348r6Fbp_k0sJFzxY6ZEI-2aNNRuY6JnRkf7TJFOZGMTvTUxB_BG3C4ddggdE6VXaw41zyHL0oj-YvrRCZE7UNaffPhAY4eTmuT_Yk9qVD93D9tdAknT7D9FUeXXlnP4pn5yhmVH1YwMWd3MpGgGGCV',
      category: 'Services',
      isVerified: true,
    ),
  ];
}
12