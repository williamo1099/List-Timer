import 'package:flutter/material.dart';
import 'package:list_timer/views/collection_detail_view.dart';

// VIEWS
import 'package:list_timer/views/drawer_view.dart';
import 'package:list_timer/views/collection_add_view.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';
import 'package:list_timer/models/item_model.dart';

final collectionList = [
  Collection(title: "Running", itemsList: [
    Item(title: "Run", duration: 2),
    Item(title: "Walk", duration: 5),
    Item(title: "Run", duration: 4),
  ]),
  Collection(title: "Studying", itemsList: [
    Item(title: "Study", duration: 5),
    Item(title: "Rest", duration: 1),
  ]),
];

class CollectionListView extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
      drawer: DrawerView(),

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
