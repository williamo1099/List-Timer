import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Item {
  Item({
    required this.title,
    required this.duration,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final int duration;
}
