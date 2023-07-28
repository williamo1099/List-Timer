import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// VIEWS
import 'package:list_timer/views/collection_list_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "List Timer",
      home: CollectionListView(),
    );
  }
}
