import 'package:flutter/material.dart';

// VIEWS
import 'package:list_timer/views/widgets/drawer_view.dart';

class CollectionListView extends StatelessWidget {
  const CollectionListView({super.key});

  void _addNewCollection() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text("List Timer"),
        actions: [
          IconButton(
            onPressed: _addNewCollection,
            icon: const Icon(Icons.add),
          )
        ],
      ),

      // DRAWER
      drawer: DrawerView(),
    );
  }
}
