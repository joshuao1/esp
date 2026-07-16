import 'package:flutter/material.dart';
import 'package:language_app/data/history_dao.dart';
import 'package:language_app/notifier/character_notifier.dart';
import 'package:language_app/notifier/history_notifier.dart';
import 'package:language_app/widget/home_page.dart';
import 'package:provider/provider.dart';

import 'package:language_app/data/app_database.dart';
import 'package:language_app/data/character_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await AppDatabase.instance.database;
  final characterDao = CharacterDao(database);
  final historyDao = HistoryDao(database);
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => characterDao),
        Provider(create: (context) => historyDao),
        ChangeNotifierProvider(
          create: (context) =>
              CharacterNotifier(context.read<CharacterDao>())..load(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              HistoryNotifier(context.read<HistoryDao>())..load(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character Trainer',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFCC), // Neon teal
          secondary: Color(0xFFFF00FF), // Neon pink
          surface: Color(0xFF1A1A2E), // Darker surface
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0D1A),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF00FFCC),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Color(0xFF00FFCC), blurRadius: 10)],
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF00FFCC),
            shadows: [Shadow(color: Color(0xFF00FFCC), blurRadius: 10)],
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: const Color(0xFF00FFCC),
            side: const BorderSide(color: Color(0xFF00FFCC), width: 2),
            shadowColor: const Color(0xFF00FFCC),
            elevation: 10,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF00FF),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A2E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF00FFCC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF00FFCC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFFF00FF), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF00FFCC)),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateProperty.all(const Color(0xFF0D0D1A)),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF00FFCC);
            }
            return const Color(0xFF1A1A2E);
          }),
          side: const BorderSide(color: Color(0xFF00FFCC), width: 2),
        ),
      ),
      routes: {'/': (context) => HomePage()},
      initialRoute: '/',
      // home: HomePage(),
      // CharacterList(),
    );
  }
}
