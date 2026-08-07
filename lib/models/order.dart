enum OrderStatus {
  orderConfirmed,
  pickedUp,
  inTransit,
  nearby,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String productName;
  final double price;
  final String currency;
  final String seller;
  final String deliveryLocation;
  final OrderStatus status;
  final DateTime orderDate;
  final String? imageUrl;

  const Order({
    required this.id,
    required this.productName,
    required this.price,
    this.currency = '₦',
    required this.seller,
    required this.deliveryLocation,
    required this.status,
    required this.orderDate,
    this.imageUrl,
  });

  String get formattedPrice => '$currency${price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';

  String get statusText {
    switch (status) {
      case OrderStatus.orderConfirmed:
        return 'Order Confirmed';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.nearby:
        return 'Nearby';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static List<Order> getSampleOrders() {
    final now = DateTime.now();
    return [
      Order(
        id: 'ORD-001',
        productName: 'Bracelet',
        price: 4500,
        seller: 'Amina Adamu',
        deliveryLocation: 'Kwakuti',
        status: OrderStatus.delivered,
        orderDate: now.subtract(const Duration(days: 2)),
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD_VW3b4Egcz_tmi6Nd0an_nwgN25Ba3wpB6Mn1C5JhFhazUi4mQP2-mPPY3g6U4frzjAIvh9Syo2eqeKh5kS9BY8VYAS0u87kzNNMV5jKg76dI5nO8Y0PDWaZ2TVY8hx9GOiqOJ2tTA6f_jl2oJ5NDnUSUpRwni3h6-Okk06G0CgKaYYSGBfW2bdri3X5wJ32OxKVIEa4UAG48aUK977zduLObVomyfzDCjsxL3vrl0U48_zwf-wX6XImlFI9me8wrRdVk4caPRPKA',
      ),
      Order(
        id: 'ORD-002',
        productName: 'Wireless Earbuds',
        price: 12000,
        seller: 'Ibrahim Suleiman',
        deliveryLocation: 'Tech Hub',
        status: OrderStatus.inTransit,
        orderDate: now.subtract(const Duration(hours: 5)),
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCdxIQAz--O7K5EwVLDAIwhhnyYtxl91f0GbDNOduo5DnwxuQFiCxjIPuSbxh31qNNw00odayVkrKfPEa9BjvY2CY-9qa5-07mkjdLdg-of-T8JjzCoZhqcRddm46nQmd7KFnQIW0Qf--iJtqbbvKXks7dClahXIB8eVEI08QGnUhqjlS1QnupamA56I4ffbFuMp_xvzNXZdJSryFCyUWMj9PhpvQHH-2gbZ85KSabZhUDKqt37mQi5jyfbQcVeWQDuAZWEWTXAFbo7',
      ),
      Order(
        id: 'ORD-003',
        productName: 'Handmade Bag',
        price: 8500,
        seller: 'Fatima Bello',
        deliveryLocation: 'Main Campus',
        status: OrderStatus.orderConfirmed,
        orderDate: now.subtract(const Duration(minutes: 30)),
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD_VW3b4Egcz_tmi6Nd0an_nwgN25Ba3wpB6Mn1C5JhFhazUi4mQP2-mPPY3g6U4frzjAIvh9Syo2eqeKh5kS9BY8VYAS0u87kzNNMV5jKg76dI5nO8Y0PDWaZ2TVY8hx9GOiqOJ2tTA6f_jl2oJ5NDnUSUpRwni3h6-Okk06G0CgKaYYSGBfW2bdri3X5wJ32OxKVIEa4UAG48aUK977zduLObVomyfzDCjsxL3vrl0U48_zwf-wX6XImlFI9me8wrRdVk4caPRPKA',
      ),
    ];
  }
}