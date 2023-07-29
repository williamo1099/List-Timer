import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// VIEWS
import 'package:list_timer/views/collection_list_view.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 70, 130, 169),
  onPrimary: const Color.fromARGB(255, 246, 244, 235),
  onBackground: const Color.fromARGB(255, 145, 200, 228),
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "List Timer",
      theme: ThemeData(
        colorScheme: kColorScheme,
      ),
      home: const CollectionListView(),
    );
  }
}
