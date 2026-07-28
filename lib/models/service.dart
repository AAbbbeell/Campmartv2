class Service {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String currency;
  final String providerName;
  final String providerAvatarUrl;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final bool isAvailable;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.price = 0,
    this.currency = '₦',
    required this.providerName,
    this.providerAvatarUrl = '',
    this.rating = 0,
    this.reviewCount = 0,
    required this.imageUrl,
    this.isAvailable = true,
  });

  String get formattedPrice => '$currency${price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';

  static List<Service> sampleServices = [
    const Service(
      id: '1',
      title: 'Maths tutor',
      description: 'Teaching proper math techniques...',
      category: 'Writing Services',
      providerName: 'Micheal Samson',
      providerAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBr0FH0XuEUnevluZqDEOHq51UpkWZzJ98Has4aPLSzeTFBqNzxQ_-O76v4XNlsOM3WsTmpXRwENW45MK3qriBW_vCuyeSXlIKS9-P7YW9EQ6XH8y9kF9eub5zMsBhW3bpDSefIAmxIrIkoPivgKamOHa1-coXpQDVXmxSapKMP_mh0bmYE0rCZ-eHbwp76f51BcbPYcsSLDaOULF1KXprlHR-0LmTLICsTCAuLvuXxopPb7nfkKhxXuuC-xT_jcQyvc1d7UGu2SfP3',
      rating: 4.0,
      reviewCount: 0,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBOaLUOkWKETMO3Sqk7ahi9f4pYWnHE0g_HaCCdFDX1ef6nddtg_twA5DpCKlmEYYwio7yMhDn-EWDqznWSKPdXlcNkzC-2b3JcgGJcJfPWWaqNpb575BKfkhBqcEO5ygB1RsBZxIr0i6YYMCQP5vT3VTgdrQaTfll1S5_iJgds_QGF24VIQYp973LVs5_nMdsW2kwyhYlwnHCXphOwWSItH1o3OEkp-SosQZE_PQjHnE7XQA194MX2F5v1XfLH9_fuFnrqW0u3R7Dz',
      isAvailable: true,
    ),
    const Service(
      id: '2',
      title: 'Photography Session',
      description: 'Professional campus photography for events...',
      category: 'Photography',
      providerName: 'Sarah Johnson',
      providerAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBr0FH0XuEUnevluZqDEOHq51UpkWZzJ98Has4aPLSzeTFBqNzxQ_-O76v4XNlsOM3WsTmpXRwENW45MK3qriBW_vCuyeSXlIKS9-P7YW9EQ6XH8y9kF9eub5zMsBhW3bpDSefIAmxIrIkoPivgKamOHa1-coXpQDVXmxSapKMP_mh0bmYE0rCZ-eHbwp76f51BcbPYcsSLDaOULF1KXprlHR-0LmTLICsTCAuLvuXxopPb7nfkKhxXuuC-xT_jcQyvc1d7UGu2SfP3',
      rating: 4.8,
      reviewCount: 12,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDaw5fIOjFgtO35V3ndBVu3JITYPSMiuwNR2RCl-qhg__N3g2WRkk7IvgwlB3SSz4N2klQ1dOY6VVQ7YZQ3J9tq02Wb04ytq2FCpzSxoIS_erAdxnk63ySTS04YyRNifhk8ZRgwXlQrtzmCfCFhaHyaq3WzKrWEy_plFJEA8mt8b3S070euKpv9uQMekGw_oeSSwwMmF05PDzPUEVpJcur2wrF_LGPS1FDr-HZ-6OHAEO3zqVcDdiH3TJoRKq285ZieiLIOJdP8Cq1T',
      isAvailable: true,
    ),
    const Service(
      id: '3',
      title: 'Hair Styling',
      description: 'Professional hair styling and braiding...',
      category: 'Beauty',
      providerName: 'Salon Classique',
      providerAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBz2xI6dgNp5bznMGN-_v9PaBp7daHosepzNa19VWUXpeo7TQTMStzhLD8dTtlhSURjCs8_XEpd3CJiguCDhUMohXM-da81g2hPnZxLIm-CXCCnMjqd9faq3348r6Fbp_k0sJFzxY6ZEI-2aNNRuY6JnRkf7TJFOZGMTvTUxB_BG3C4ddggdE6VXaw41zyHL0oj-YvrRCZE7UNaffPhAY4eTmuT_Yk9qVD93D9tdAknT7D9FUeXXlnP4pn5yhmVH1YwMWd3MpGgGGCV',
      rating: 4.9,
      reviewCount: 34,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBOaLUOkWKETMO3Sqk7ahi9f4pYWnHE0g_HaCCdFDX1ef6nddtg_twA5DpCKlmEYYwio7yMhDn-EWDqznWSKPdXlcNkzC-2b3JcgGJcJfPWWaqNpb575BKfkhBqcEO5ygB1RsBZxIr0i6YYMCQP5vT3VTgdrQaTfll1S5_iJgds_QGF24VIQYp973LVs5_nMdsW2kwyhYlwnHCXphOwWSItH1o3OEkp-SosQZE_PQjHnE7XQA194MX2F5v1XfLH9_fuFnrqW0u3R7Dz',
      isAvailable: true,
    ),
    const Service(
      id: '4',
      title: 'Laundry Pickup',
      description: 'Convenient laundry service with same-day delivery...',
      category: 'Laundry',
      providerName: 'ABC Laundry',
      providerAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAwefuL1jENS2Z0LXyaAxBGFF7fn7F-2k1KP87zqAEaQf6VuwmfNNhP16egXhjeNizrYgeILA8ymf8jXHAnXLmC_WtM--XSIuTJcqCv27OQpGUxYwpzKPkauJVEIPffaKV9mCIidrJu87_GrqrTOfUlYPA0Py9xCQ4_gn_Yc0TUSd0LYr1MhcQixYudGvN1yzq21NeAyAFspd2YnVMfl6AKdxONlXkrHACW2ZunEQOHN3zsnHD-wSR8WsvI7YKnMBUj70IFj1QeikJT',
      rating: 4.6,
      reviewCount: 48,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDaw5fIOjFgtO35V3ndBVu3JITYPSMiuwNR2RCl-qhg__N3g2WRkk7IvgwlB3SSz4N2klQ1dOY6VVQ7YZQ3J9tq02Wb04ytq2FCpzSxoIS_erAdxnk63ySTS04YyRNifhk8ZRgwXlQrtzmCfCFhaHyaq3WzKrWEy_plFJEA8mt8b3S070euKpv9uQMekGw_oeSSwwMmF05PDzPUEVpJcur2wrF_LGPS1FDr-HZ-6OHAEO3zqVcDdiH3TJoRKq285ZieiLIOJdP8Cq1T',
      isAvailable: false,
    ),
    const Service(
      id: '5',
      title: 'Graphic Design',
      description: 'Logos, flyers, posters and social media designs...',
      category: 'Design',
      providerName: 'Chidi Obi',
      providerAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBr0FH0XuEUnevluZqDEOHq51UpkWZzJ98Has4aPLSzeTFBqNzxQ_-O76v4XNlsOM3WsTmpXRwENW45MK3qriBW_vCuyeSXlIKS9-P7YW9EQ6XH8y9kF9eub5zMsBhW3bpDSefIAmxIrIkoPivgKamOHa1-coXpQDVXmxSapKMP_mh0bmYE0rCZ-eHbwp76f51BcbPYcsSLDaOULF1KXprlHR-0LmTLICsTCAuLvuXxopPb7nfkKhxXuuC-xT_jcQyvc1d7UGu2SfP3',
      rating: 4.7,
      reviewCount: 21,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBOaLUOkWKETMO3Sqk7ahi9f4pYWnHE0g_HaCCdFDX1ef6nddtg_twA5DpCKlmEYYwio7yMhDn-EWDqznWSKPdXlcNkzC-2b3JcgGJcJfPWWaqNpb575BKfkhBqcEO5ygB1RsBZxIr0i6YYMCQP5vT3VTgdrQaTfll1S5_iJgds_QGF24VIQYp973LVs5_nMdsW2kwyhYlwnHCXphOwWSItH1o3OEkp-SosQZE_PQjHnE7XQA194MX2F5v1XfLH9_fuFnrqW0u3R7Dz',
      isAvailable: true,
    ),
    const Service(
      id: '6',
      title: 'Tailoring',
      description: 'Custom clothing alterations and new designs...',
      category: 'Fashion',
      providerName: 'Amaka Fashion House',
      providerAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBz2xI6dgNp5bznMGN-_v9PaBp7daHosepzNa19VWUXpeo7TQTMStzhLD8dTtlhSURjCs8_XEpd3CJiguCDhUMohXM-da81g2hPnZxLIm-CXCCnMjqd9faq3348r6Fbp_k0sJFzxY6ZEI-2aNNRuY6JnRkf7TJFOZGMTvTUxB_BG3C4ddggdE6VXaw41zyHL0oj-YvrRCZE7UNaffPhAY4eTmuT_Yk9qVD93D9tdAknT7D9FUeXXlnP4pn5yhmVH1YwMWd3MpGgGGCV',
      rating: 4.3,
      reviewCount: 15,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDaw5fIOjFgtO35V3ndBVu3JITYPSMiuwNR2RCl-qhg__N3g2WRkk7IvgwlB3SSz4N2klQ1dOY6VVQ7YZQ3J9tq02Wb04ytq2FCpzSxoIS_erAdxnk63ySTS04YyRNifhk8ZRgwXlQrtzmCfCFhaHyaq3WzKrWEy_plFJEA8mt8b3S070euKpv9uQMekGw_oeSSwwMmF05PDzPUEVpJcur2wrF_LGPS1FDr-HZ-6OHAEO3zqVcDdiH3TJoRKq285ZieiLIOJdP8Cq1T',
      isAvailable: true,
    ),
  ];
}
