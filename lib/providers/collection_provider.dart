import 'package:flutter_riverpod/flutter_riverpod.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';

class CollectionNotifier extends StateNotifier<List<Collection>> {
  CollectionNotifier() : super([]);

  void addNewCollection(Collection newCollection) {
    state = [...state, newCollection];
  }

  void removeCollection(String id) {
    state = [
      for (final collection in state)
        if (collection.id != id) collection,
    ];
  }

  void replaceCollection(String id, Collection newCollection) {
    state = [
      for (final collection in state)
        if (collection.id != id) collection else newCollection,
    ];
  }
}

final collectionProvider =
    StateNotifierProvider<CollectionNotifier, List<Collection>>(
        (ref) => CollectionNotifier());
