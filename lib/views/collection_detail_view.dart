import 'package:flutter/material.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';

class CollectionDetailView extends StatefulWidget {
  const CollectionDetailView({super.key, required this.collection});

  final Collection collection;

  @override
  State<CollectionDetailView> createState() => _CollectionDetailViewState();
}

class _CollectionDetailViewState extends State<CollectionDetailView> {
  bool _isPlaying = false;

  void _addNewItem() {}

  void _play() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: Text(widget.collection.title),
        actions: [
          IconButton(
            onPressed: _addNewItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            // LISTVIEW
            Expanded(
              child: ListView.builder(
                itemCount: widget.collection.itemsList.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(widget.collection.itemsList[index].title),
                  trailing: Text(
                      "${widget.collection.itemsList[index].duration} minutes"),
                ),
              ),
            ),

            // PLAY BUTTON
            IconButton(
              onPressed: _addNewItem,
              icon: _isPlaying
                  ? const Icon(
                      Icons.stop_circle,
                      size: 50,
                    )
                  : const Icon(
                      Icons.play_circle,
                      size: 50,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
