import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// VIEWS
import 'package:list_timer/views/drawer_view.dart';
import 'package:list_timer/views/collection_add_view.dart';
import 'package:list_timer/views/collection_detail_view.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';

// PROVIDERS
import 'package:list_timer/providers/collection_provider.dart';

class CollectionListView extends ConsumerWidget {
  const CollectionListView({super.key});

  void _addNewCollection(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CollectionAddView(),
    ));
  }

  void _viewCollectionDetail(BuildContext context, Collection collection) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CollectionDetailView(
        collection: collection,
      ),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Collection> collectionList = ref.watch(collectionProvider);

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
      body: ListView.builder(
        itemCount: collectionList.length,
        itemBuilder: (context, index) => ListTile(
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
  }
}
