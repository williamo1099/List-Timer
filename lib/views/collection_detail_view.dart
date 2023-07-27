import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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

  void _play() async {
    setState(() {
      _isPlaying = true;
    });

    await Future.forEach(widget.collection.itemsList, (item) async {
      final duration = Duration(seconds: item.duration);
      FlutterTts().speak(item.title);
      await Future.delayed(duration);
    });

    setState(() {
      _isPlaying = false;
    });
  }

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
                      "${widget.collection.itemsList[index].duration} seconds"),
                ),
              ),
            ),

            // PLAY BUTTON
            IconButton(
              onPressed: _play,
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
