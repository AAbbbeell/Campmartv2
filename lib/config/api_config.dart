class ApiConfig {
  // Base URL configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.campmart.ng/campmartv2/api/v1',
  );

  // API endpoints
  static const String auth = '/auth';
  static const String products = '/products';
  static const String services = '/services';
  static const String users = '/users';
  static const String orders = '/orders';
  static const String cart = '/cart';
  static const String bookmarks = '/bookmarks';
  static const String messages = '/messages';
  static const String conversations = '/conversations';
  static const String notifications = '/notifications';
  static const String reviews = '/reviews';
  static const String categories = '/categories';
  static const String universities = '/universities';

  // Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Pagination defaults
  static const int defaultPerPage = 20;
  static const int maxPerPage = 100;

  // Token storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
}
