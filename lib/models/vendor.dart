class Vendor {
  final String id;
  final String name;
  final double rating;
  final String imageUrl;
  final bool isVerified;
  final int productCount;

  const Vendor({
    required this.id,
    required this.name,
    required this.rating,
    required this.imageUrl,
    this.isVerified = false,
    this.productCount = 0,
  });

  Vendor copyWith({
    String? id,
    String? name,
    double? rating,
    String? imageUrl,
    bool? isVerified,
    int? productCount,
  }) {
    return Vendor(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      isVerified: isVerified ?? this.isVerified,
      productCount: productCount ?? this.productCount,
    );
  }

  static List<Vendor> sampleVendors = [
    const Vendor(
      id: 'v1',
      name: 'ABC Laundry',
      rating: 4.8,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAwefuL1jENS2Z0LXyaAxBGFF7fn7F-2k1KP87zqAEaQf6VuwmfNNhP16egXhjeNizrYgeILA8ymf8jXHAnXLmC_WtM--XSIuTJcqCv27OQpGUxYwpzKPkauJVEIPffaKV9mCIidrJu87_GrqrTOfUlYPA0Py9xCQ4_gn_Yc0TUSd0LYr1MhcQixYudGvN1yzq21NeAyAFspd2YnVMfl6AKdxONlXkrHACW2ZunEQOHN3zsnHD-wSR8WsvI7YKnMBUj70IFj1QeikJT',
      isVerified: true,
      productCount: 12,
    ),
    const Vendor(
      id: 'v2',
      name: 'Amina Accessories',
      rating: 4.6,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD_VW3b4Egcz_tmi6Nd0an_nwgN25Ba3wpB6Mn1C5JhFhazUi4mQP2-mPPY3g6U4frzjAIvh9Syo2eqeKh5kS9BY8VYAS0u87kzNNMV5jKg76dI5nO8Y0PDWaZ2TVY8hx9GOiqOJ2tTA6f_jl2oJ5NDnUSUpRwni3h6-Okk06G0CgKaYYSGBfW2bdri3X5wJ32OxKVIEa4UAG48aUK977zduLObVomyfzDCjsxL3vrl0U48_zwf-wX6XImlFI9me8wrRdVk4caPRPKA',
      isVerified: true,
      productCount: 8,
    ),
    const Vendor(
      id: 'v3',
      name: 'Salon Classique',
      rating: 4.9,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBz2xI6dgNp5bznMGN-_v9PaBp7daHosepzNa19VWUXpeo7TQTMStzhLD8dTtlhSURjCs8_XEpd3CJiguCDhUMohXM-da81g2hPnZxLIm-CXCCnMjqd9faq3348r6Fbp_k0sJFzxY6ZEI-2aNNRuY6JnRkf7TJFOZGMTvTUxB_BG3C4ddggdE6VXaw41zyHL0oj-YvrRCZE7UNaffPhAY4eTmuT_Yk9qVD93D9tdAknT7D9FUeXXlnP4pn5yhmVH1YwMWd3MpGgGGCV',
      isVerified: true,
      productCount: 5,
    ),
    const Vendor(
      id: 'v4',
      name: 'Tech Hub Store',
      rating: 4.5,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCdxIQAz--O7K5EwVLDAIwhhnyYtxl91f0GbDNOduo5DnwxuQFiCxjIPuSbxh31qNNw00odayVkrKfPEa9BjvY2CY-9qa5-07mkjdLdg-of-T8JjzCoZhqcRddm46nQmd7KFnQIW0Qf--iJtqbbvKXks7dClahXIB8eVEI08QGnUhqjlS1QnupamA56I4ffbFuMp_xvzNXZdJSryFCyUWMj9PhpvQHH-2gbZ85KSabZhUDKqt37mQi5jyfbQcVeWQDuAZWEWTXAFbo7',
      isVerified: false,
      productCount: 15,
    ),
  ];
}
