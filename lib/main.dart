import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// VIEWS
import 'package:list_timer/views/collection_list_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Light app theme.
final lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.rubikTextTheme(),
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(255, 145, 200, 228),
  ),
);

// Dark app theme.
final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  textTheme: GoogleFonts.rubikTextTheme().apply(
    bodyColor: const Color.fromARGB(255, 246, 244, 235),
    displayColor: const Color.fromARGB(255, 246, 244, 235),
  ),
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(255, 70, 130, 169),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "List Timer",
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const CollectionListView(),
    );
  }
}
