import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

// MODELS
import 'package:list_timer/models/collection_model.dart';
import 'package:list_timer/models/timer_model.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "timerlist.db"),
    onCreate: (db, version) {
      // Create a Collection table.
      db.execute('''CREATE TABLE collection (
          id TEXT PRIMARY KEY,
          title TEXT
          )''');

      // Create a Timer table.
      db.execute('''CREATE TABLE timer (
          id TEXT PRIMARY KEY,
          title TEXT,
          duration INT,
          unit TEXT,
          collectionId TEXT
          )''');
    },
    version: 1,
  );
  return db;
}

class CollectionNotifier extends StateNotifier<List<Collection>> {
  CollectionNotifier() : super([]);

  Future<void> loadCollection() async {
    final db = await _getDatabase();
    final collectionData = await db.query("collection");
    final timerData = await db.query("timer");

    // Load all collections.
    final collections = collectionData
        .map(
          (row) => Collection(
            id: row["id"] as String,
            title: row["title"] as String,
            timersList: [],
          ),
        )
        .toList();

    // Load all timers and add to loaded collection.
    timerData.map(
      (row) {
        final timer = Timer(
          id: row["id"] as String,
          title: row["title"] as String,
          duration: int.parse(row["duration"] as String),
          unit: switch (row["unit"] as String) {
            "minute" => TimerUnit.minute,
            "hour" => TimerUnit.hour,
            _ => TimerUnit.second
          },
        );

        collections
            .firstWhere(
                (element) => element.id == row["collectionId"] as String)
            .timersList
            .add(timer);
      },
    );

    state = collections;
  }

  void addNewCollection(Collection newCollection) async {
    state = [...state, newCollection];

    // Add newCollection to database.
    final db = await _getDatabase();
    db.insert("collection", {
      "id": newCollection.id,
      "title": newCollection.title,
    });

    // Add timer in newCollection to database.
    for (final timer in newCollection.timersList) {
      db.insert("timer", {
        "id": timer.id,
        "title": timer.title,
        "duration": timer.duration,
        "unit": timer.unit.name,
        "collectionId": newCollection.id
      });
    }
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
