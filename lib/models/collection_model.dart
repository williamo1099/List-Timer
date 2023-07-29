import 'package:uuid/uuid.dart';

// MODELS
import 'package:list_timer/models/timer_model.dart';

const uuid = Uuid();

class Collection {
  final String id;
  final String title;
  final List<Timer> timersList;

  Collection({
    required this.title,
    String? id,
    List<Timer>? timersList,
  })  : id = id ?? uuid.v4(),
        timersList = timersList ?? [];
}
