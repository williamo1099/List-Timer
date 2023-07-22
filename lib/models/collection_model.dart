import 'package:uuid/uuid.dart';

// MODELS
import 'package:list_timer/models/item_model.dart';

const uuid = Uuid();

class Collection {
  Collection({
    required this.title,
    String? id,
    List<Item>? itemsList,
  })  : id = id ?? uuid.v4(),
        itemsList = itemsList ?? [];

  final String id;
  final String title;
  final List<Item> itemsList;
}
