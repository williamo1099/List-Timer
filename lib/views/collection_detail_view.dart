import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';
import 'package:list_timer/providers/collection_provider.dart';
import 'package:list_timer/views/collection_editor_view.dart';

class CollectionDetailView extends ConsumerStatefulWidget {
  const CollectionDetailView({super.key, required this.collectionId});

  final String collectionId;

  @override
  ConsumerState<CollectionDetailView> createState() =>
      _CollectionDetailViewState();
}

class _CollectionDetailViewState extends ConsumerState<CollectionDetailView> {
  bool _isPlaying = false;

  void _editCollection() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CollectionEditorView(
        currentCollection: ref
            .watch(collectionProvider)
            .firstWhere((element) => element.id == widget.collectionId),
      ),
    ));
  }

  void _playItems() async {
    setState(() {
      _isPlaying = true;
    });

    Collection collection = ref
        .watch(collectionProvider)
        .firstWhere((element) => element.id == widget.collectionId);
    await Future.forEach(collection.itemsList, (item) async {
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
    Collection collection = ref.watch(collectionProvider).firstWhere(
          (element) => element.id == widget.collectionId,
        );

    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: Text(collection.title),
        actions: [
          IconButton(
            onPressed: _editCollection,
            icon: const Icon(Icons.edit),
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
                itemCount: collection.itemsList.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(collection.itemsList[index].title),
                  trailing:
                      Text("${collection.itemsList[index].duration} seconds"),
                ),
              ),
            ),

            // PLAY BUTTON
            IconButton(
              onPressed: _playItems,
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
