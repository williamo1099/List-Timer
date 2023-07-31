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

  String get totalTimers =>
      "${timersList.length} timer${timersList.length > 1 ? "s" : ""}";

  String get totalDurations {
    int totalSeconds = timersList.fold(0,
        (previousValue, element) => previousValue + element.durationInSecond);

    int totalTime = totalSeconds;
    String totalDurations = "$totalTime ${TimerUnit.second.name}";
    if (totalSeconds >= 3600) {
      totalTime = totalSeconds ~/ 3600;
      totalDurations = "$totalTime ${TimerUnit.hour.name}";
    } else if (totalSeconds >= 60) {
      totalTime = totalSeconds ~/ 60;
      totalDurations = "$totalTime ${TimerUnit.minute.name}";
    }
    return "$totalDurations${totalTime > 1 ? "s" : ""}";
  }

  @override
  String toString() {
    return "A collection with id $id, title $title and $totalTimers.";
  }
}
