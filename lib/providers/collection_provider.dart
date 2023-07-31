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
    path.join(dbPath, "listtimer.db"),
    onCreate: (db, version) async {
      // Create a Collection table.
      await db.execute('''CREATE TABLE collection (
          id TEXT PRIMARY KEY,
          title TEXT
          )''');

      // Create a Timer table.
      await db.execute('''CREATE TABLE timer (
          id TEXT PRIMARY KEY,
          title TEXT,
          duration INT,
          unit TEXT,
          collection_id TEXT,
          FOREIGN KEY(collection_id) REFERENCES collection(id)
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
    timerData
        .map(
          (row) => collections
              .firstWhere(
                  (element) => element.id == row["collection_id"] as String)
              .timersList
              .add(
                Timer(
                  id: row["id"] as String,
                  title: row["title"] as String,
                  duration: row["duration"] as int,
                  unit: switch (row["unit"] as String) {
                    "minute" => TimerUnit.minute,
                    "hour" => TimerUnit.hour,
                    _ => TimerUnit.second
                  },
                ),
              ),
        )
        .toList();

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
        "collection_id": newCollection.id
      });
    }
  }

  void removeCollection(String id) async {
    state = [
      for (final collection in state)
        if (collection.id != id) collection,
    ];

    // Remove collection with id from database.
    final db = await _getDatabase();
    db.delete("collection", where: "id = ?", whereArgs: [id]);

    // Remove timers connected to collection.
    db.delete("timer", where: "collection_id = ?", whereArgs: [id]);
  }

  void replaceCollection(String id, Collection newCollection) {
    state = [
      for (final collection in state)
        if (collection.id != id) collection else newCollection,
    ];

    // Update the collection by removing the old version and adding the updated version to the database.
    removeCollection(id);
    addNewCollection(newCollection);
  }
}

final collectionProvider =
    StateNotifierProvider<CollectionNotifier, List<Collection>>(
        (ref) => CollectionNotifier());
