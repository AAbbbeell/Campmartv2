import 'api/product.dart' as api;
import 'api/service.dart' as api;
import 'api/user.dart' as api;
import 'product.dart' as ui;
import 'service.dart' as ui;
import 'vendor.dart' as ui;

// Extension methods to convert API models to UI models
extension ApiProductToUiProduct on api.Product {
  ui.Product toUiProduct() {
    return ui.Product(
      id: id.toString(),
      name: title,
      price: price,
      currency: '₦',
      seller: seller?.fullName ?? 'Unknown',
      sellerId: seller?.id.toString() ?? '',
      location: 'Campus', // API doesn't provide location in product
      imageUrl: primaryImage ?? '',
      description: description,
      category: category?.name,
      isVerified: false, // API doesn't provide verification status
      stock: stockQuantity,
    );
  }
}

extension UiProductToApiProduct on ui.Product {
  // Note: This is a partial conversion since UI product has fewer fields
  Map<String, dynamic> toApiPartial() {
    return {
      'title': name,
      'price': price,
      'description': description,
    };
  }
}

extension ApiServiceToUiService on api.Service {
  ui.Service toUiService() {
    return ui.Service(
      id: id.toString(),
      title: title,
      description: description,
      category: category?.name ?? 'General',
      price: price,
      currency: '₦',
      providerName: provider?.fullName ?? 'Unknown',
      providerAvatarUrl: provider?.profileImage ?? '',
      rating: rating,
      reviewCount: totalRatings,
      imageUrl: portfolioImages?.first ?? '',
      isAvailable: availability == 'available',
    );
  }
}

extension UiServiceToApiService on ui.Service {
  // Note: This is a partial conversion since UI service has fewer fields
  Map<String, dynamic> toApiPartial() {
    return {
      'title': title,
      'description': description,
      'price': price,
    };
  }
}

extension ApiUserToUiVendor on api.User {
  ui.Vendor toUiVendor() {
    return ui.Vendor(
      id: id.toString(),
      name: fullName ?? username ?? email,
      rating: 0.0, // API doesn't provide rating in user object
      imageUrl: profileImage ?? '',
      isVerified: status == 'active',
      productCount: 0, // API doesn't provide product count in user object
    );
  }
}
