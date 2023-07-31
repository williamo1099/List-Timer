import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// VIEWS
import 'package:list_timer/views/drawer_view.dart';
import 'package:list_timer/views/widgets/empty_view.dart';
import 'package:list_timer/views/collection_editor_view.dart';
import 'package:list_timer/views/collection_detail_view.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';

// PROVIDERS
import 'package:list_timer/providers/collection_provider.dart';

class CollectionListView extends ConsumerStatefulWidget {
  const CollectionListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CollectionListViewState();
}

class _CollectionListViewState extends ConsumerState<CollectionListView> {
  late Future<void> _futureCollection;

  @override
  void initState() {
    super.initState();
    _futureCollection = ref.read(collectionProvider.notifier).loadCollection();
  }

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
  Widget build(BuildContext context) {
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
          subtitle: Text(collectionList[index].totalDurations),
          trailing: Text(collectionList[index].totalTimers),
          onTap: () {
            _viewCollectionDetail(context, collectionList[index]);
          },
        ),
      ),
    );

    if (collectionList.isEmpty) {
      body = const EmptyView(
          message:
              "It's kinda lonely here.\nStart by adding a new collection.");
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
      body: FutureBuilder(
          future: _futureCollection,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : body),
    );
  }
}
