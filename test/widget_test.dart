import 'package:flutter_test/flutter_test.dart';
import 'package:campmartv2/services/auth_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final authService = AuthService();
    await authService.init();
    expect(authService.isAuthenticated, false);
  });
}
