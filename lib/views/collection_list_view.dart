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
    Item(title: "Run", duration: 10),
    Item(title: "Walk", duration: 10),
    Item(title: "Run", duration: 10),
  ]),
  Collection(title: "Studying", itemsList: [
    Item(title: "Study", duration: 30),
    Item(title: "Rest", duration: 10),
  ]),
];

class CollectionListView extends StatelessWidget {
  const CollectionListView({super.key});

  void _addNewCollection(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CollectionAddView(),
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
          subtitle: const Text("10 minutes"),
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
