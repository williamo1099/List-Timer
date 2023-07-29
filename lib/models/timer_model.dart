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

  String get pluralizedUnit => duration > 1 ? "${unit.name}s" : unit.name;
}
