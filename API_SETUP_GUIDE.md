# API Integration Setup Guide

The codebase has been prepared for API integration. Here's what has been set up:

## Dependencies Added

- **dio**: ^5.7.0 - HTTP client for making API requests
- **flutter_secure_storage**: ^9.2.4 - Secure storage for tokens
- **json_annotation**: ^4.12.0 - JSON serialization annotations
- **build_runner**: ^2.4.15 - Code generation for JSON serialization
- **json_serializable**: ^6.9.2 - JSON serialization code generation

## Structure Created

### Configuration
- `lib/config/api_config.dart` - API configuration including base URL, endpoints, and constants

### Services
- `lib/services/api_client.dart` - Base HTTP client with error handling and token management
- `lib/services/token_service.dart` - Token storage and management
- `lib/services/auth_api_service.dart` - Authentication service (login, signup, logout)
- `lib/services/products_api_service.dart` - Products CRUD operations
- `lib/services/services_api_service.dart` - Services CRUD operations
- `lib/services/cart_api_service.dart` - Shopping cart operations
- `lib/services/orders_api_service.dart` - Order management
- `lib/services/bookmarks_api_service.dart` - Bookmark management
- `lib/services/notifications_api_service.dart` - Notification handling
- `lib/services/messages_api_service.dart` - Messaging/conversation operations
- `lib/services/categories_api_service.dart` - Categories and universities

### API Models
- `lib/models/api/api_response.dart` - Generic API response wrappers
- `lib/models/api/user.dart` - User and authentication models
- `lib/models/api/category.dart` - Category model
- `lib/models/api/product.dart` - Product model
- `lib/models/api/service.dart` - Service model
- `lib/models/api/cart.dart` - Cart and cart item models
- `lib/models/api/order.dart` - Order model
- `lib/models/api/notification.dart` - Notification model
- `lib/models/api/bookmark.dart` - Bookmark model
- `lib/models/api/message.dart` - Message and conversation models

### Model Mappers
- `lib/models/model_mappers.dart` - Extension methods to convert between API models and existing UI models

## How to Use

### 1. Configure API Base URL

Set the API base URL using environment variables or modify the default in `lib/config/api_config.dart`:

```dart
// For development with environment variable
flutter run --dart-define=API_BASE_URL=https://your-api-url.com

// Or modify the default in api_config.dart
static const String baseUrl = 'https://your-api-url.com/campmartv2/api/v1';
```

### 2. Use Authentication Service

```dart
import 'package:campmartv2/services/services.dart';

final authService = AuthApiService();

// Initialize (check for existing session)
await authService.init();

// Login
final error = await authService.login(
  emailOrPhone: 'user@example.com',
  password: 'password',
);
if (error != null) {
  // Handle error
}

// Signup
final error = await authService.signup(
  firstname: 'John',
  lastname: 'Doe',
  email: 'john@example.com',
  phone: '1234567890',
  password: 'password',
  universityId: 1,
);

// Logout
await authService.logout();

// Check authentication status
if (authService.isAuthenticated) {
  // User is logged in
}
```

### 3. Use API Services

```dart
import 'package:campmartv2/services/services.dart';

// Products
final productsService = ProductsApiService();
final products = await productsService.getProducts(
  category: 1,
  search: 'phone',
  page: 1,
);

// Services
final servicesService = ServicesApiService();
final services = await servicesService.getServices();

// Cart
final cartService = CartApiService();
final cart = await cartService.getCart();
```

### 4. Convert API Models to UI Models

```dart
import 'package:campmartv2/models/model_mappers.dart';

// Convert API product to UI product
final apiProduct = await productsService.getProduct(1);
final uiProduct = apiProduct.data.toUiProduct();
```

## Features

### Automatic Token Management
- Tokens are automatically stored securely
- Authorization headers are added to requests
- Automatic token refresh on 401 errors
- Automatic logout on failed token refresh

### Error Handling
- Custom `ApiException` with user-friendly messages
- Network error handling (timeout, no connection, etc.)
- Server error handling with status codes

### Pagination Support
- Built-in pagination models
- Easy pagination with page/per_page parameters

### Type Safety
- Strongly typed models with JSON serialization
- Compile-time type checking
- Auto-generated JSON serialization code

## Next Steps

1. **Update API Base URL**: Set your actual API base URL in `api_config.dart`
2. **Test Authentication**: Test login/signup with your API
3. **Replace Mock Data**: Gradually replace existing mock data with API calls
4. **Handle Loading States**: Add loading indicators in your UI
5. **Error UI**: Add error handling UI for API failures
6. **Environment Configuration**: Set up different base URLs for dev/staging/prod

## Regenerating JSON Serialization Code

If you modify any API models, regenerate the serialization code:

```bash
flutter pub run build_runner build
```

## Existing Local Services

The existing local services (`auth_service.dart`, `wallet_service.dart`) are still intact. You can gradually migrate to the new API services as needed.

## OpenAPI Specification

The API models are based on the `openapi.json` file in the project root. Update this file if the API specification changes and regenerate models accordingly.
