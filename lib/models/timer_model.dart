import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum TimerUnit {
  second,
  minute,
  hour,
}

class Timer {
  final String id;
  final String title;
  final int duration;
  final TimerUnit unit;

  Timer({
    required this.title,
    required this.duration,
    String? id,
    TimerUnit? unit,
  })  : id = id ?? uuid.v4(),
        unit = unit ?? TimerUnit.second;

  int get durationInSecond => switch (unit) {
        TimerUnit.second => duration,
        TimerUnit.minute => duration * 60,
        TimerUnit.hour => duration * 3600
      };

  String get durationWithUnit =>
      "$duration ${unit.name}${duration > 1 ? "s" : ""}";

  @override
  String toString() {
    return "A timer with id $id, title $title and $durationWithUnit.";
  }
}
