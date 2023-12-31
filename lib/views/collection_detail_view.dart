import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

// VIEWS
import 'package:list_timer/views/widgets/empty_view.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';
import 'package:list_timer/providers/collection_provider.dart';
import 'package:list_timer/views/collection_editor_view.dart';

class CollectionDetailView extends ConsumerStatefulWidget {
  final String collectionId;

  const CollectionDetailView({super.key, required this.collectionId});

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

  void _playTimers() async {
    final textToSpeech = FlutterTts();
    if (!_isPlaying) {
      setState(() {
        _isPlaying = true;
      });

      Collection collection = ref
          .watch(collectionProvider)
          .firstWhere((element) => element.id == widget.collectionId);
      await Future.forEach(collection.timersList, (timer) async {
        final duration = Duration(seconds: timer.durationInSecond);
        textToSpeech.speak(timer.title);
        await Future.delayed(duration);
      });

      setState(() {
        _isPlaying = false;
      });
    } else {
      textToSpeech.stop();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Collection collection = ref.watch(collectionProvider).firstWhere(
          (element) => element.id == widget.collectionId,
        );

    Widget body = Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          // LISTVIEW
          Expanded(
            child: ListView.builder(
              itemCount: collection.timersList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(collection.timersList[index].title),
                trailing: Text(collection.timersList[index].durationWithUnit),
              ),
            ),
          ),

          // PLAY BUTTON
          IconButton(
            onPressed: _playTimers,
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
    );

    if (collection.timersList.isEmpty) {
      body = const EmptyView(
          message:
              "Welp, there's no timer here.\nAdd a new timer by editing this collection.");
    }

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
        body: body);
  }
}
