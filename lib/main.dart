import 'package:audio_doc/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(systemNavigationBarColor: Color(0xFF152b51)),
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio doc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF152b51)),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF152b51),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFF152b51),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            iconColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
