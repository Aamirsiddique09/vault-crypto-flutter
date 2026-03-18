import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF111318),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const VaultApp());
}

class VaultApp extends StatelessWidget {
  const VaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vault - Ethereal Ledger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111318),
        primaryColor: const Color(0xFF00FF94),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF94),
          secondary: Color(0xFF14D1FF),
          surface: Color(0xFF1A1C20),
          background: Color(0xFF111318),
          error: Color(0xFFFFB4AB),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
