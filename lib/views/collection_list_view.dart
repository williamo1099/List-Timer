import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// VIEWS
import 'package:list_timer/views/drawer_view.dart';
import 'package:list_timer/views/collection_editor_view.dart';
import 'package:list_timer/views/collection_detail_view.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';

// PROVIDERS
import 'package:list_timer/providers/collection_provider.dart';

class CollectionListView extends ConsumerWidget {
  const CollectionListView({super.key});

  void _addNewCollection(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CollectionEditorView(
        currentCollection: null,
      ),
    ));
  }

  void _viewCollectionDetail(BuildContext context, Collection collection) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CollectionDetailView(
        collectionId: collection.id,
      ),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Collection> collectionList = ref.watch(collectionProvider);

    Widget body = ListView.builder(
      itemCount: collectionList.length,
      itemBuilder: (context, index) => Dismissible(
        key: Key(collectionList[index].id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          ref
              .read(collectionProvider.notifier)
              .removeCollection(collectionList[index].id);

          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Collection successfully removed.")));
        },
        background: Container(
          color: Colors.red,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete),
              SizedBox(width: 25),
            ],
          ),
        ),
        child: ListTile(
          title: Text(collectionList[index].title),
          subtitle: Text(
              "${collectionList[index].itemsList.fold(0, (previousValue, element) => previousValue + element.duration)} seconds"),
          trailing: Text(
              "${collectionList[index].itemsList.length.toString()} items"),
          onTap: () {
            _viewCollectionDetail(context, collectionList[index]);
          },
        ),
      ),
    );

    if (collectionList.isEmpty) {
      body = const Center(
        child: Text("Start by adding a new collection."),
      );
    }

    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: const Text("List Timer"),
        actions: [
          IconButton(
            onPressed: () {
              _addNewCollection(context);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),

      // DRAWER
      drawer: const DrawerView(),

      // BODY
      body: body,
    );
  }
}
