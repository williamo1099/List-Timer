import 'package:riverpod/riverpod.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';

class CollectionNotifier extends StateNotifier<List<Collection>> {
  CollectionNotifier() : super([]);

  void addNewCollection(Collection newCollection) {
    state = [newCollection, ...state];
  }

  void removeCollection(String id) {
    state = [
      for (final collection in state)
        if (collection.id != id) collection,
    ];
  }
}

final collectionProvider =
    StateNotifierProvider<CollectionNotifier, List<Collection>>(
        (ref) => CollectionNotifier());
