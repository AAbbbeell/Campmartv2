import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/wallet_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  final walletService = WalletService();
  await authService.init();
  await walletService.init();
  runApp(MyApp(authService: authService, walletService: walletService));
}

class MyApp extends StatefulWidget {
  final AuthService authService;
  final WalletService walletService;
  const MyApp({
    super.key,
    required this.authService,
    required this.walletService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() => _showSplash = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(onComplete: _onSplashComplete),
      );
    }

    return ListenableBuilder(
      listenable: widget.authService,
      builder: (context, _) {
        return MaterialApp(
          title: 'CampMart',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4D44E3),
              brightness: Brightness.light,
            ),
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFFF0FDF4),
            useMaterial3: true,
          ),
          home: widget.authService.isAuthenticated
              ? HomeScreen(
                  authService: widget.authService,
                  walletService: widget.walletService,
                )
              : LoginScreen(
                  authService: widget.authService,
                  walletService: widget.walletService,
                ),
        );
      },
    );
  }
}
