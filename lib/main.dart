import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaleo_frontend/core/theme/app_theme.dart';
import 'package:kaleo_frontend/features/welcome/presentation/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const KaleoApp());
}

class KaleoApp extends StatelessWidget {
  const KaleoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaleo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const WelcomeScreen(),
      );
  }
}
