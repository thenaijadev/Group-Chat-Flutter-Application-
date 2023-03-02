import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'crud_exceptions.dart';

class NotesService {
  Database? _db;
  List<DataBaseNote> _notes = [];

//Please take note the the _noteStreamController is the UI facing part of the class that would serve as some sort of an interface between the data and the UI itself.

  final _notesStreamController =
      StreamController<List<DataBaseNote>>.broadcast();

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DataBaseUser> getUser({required String email}) async {
    final db = _getDataBaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ? ",
      whereArgs: [
        email.toLowerCase(),
      ],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DataBaseUser.fromRow(results.first);
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DataBaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      //Create User Table
      await db.execute(createUserTable);
      //Create Note Table
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumnetDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DataBaseNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Database _getDataBaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseNotOpen();
    } else {
      return db;
    }
  }

  Future<void> deleteUser({
    required String email,
  }) async {
    final db = _getDataBaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DataBaseUser> createUser(
      {required String email, required fullName}) async {
    final db = _getDataBaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ? ",
      whereArgs: [
        email.toLowerCase(),
      ],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExist();
    }

    final userId = await db.insert(userTable, {
      email: email.toLowerCase(),
    });
    return DataBaseUser(id: userId, fullName: fullName, email: email);
  }

  Future<DataBaseNote> createNote({required DataBaseUser owner}) async {
    final db = _getDataBaseOrThrow();
    // Make sure owner exist in the database with the correct id.
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const title = "";
    const body = "";
    // Create the note.
    final notesId = await db.insert(notesTable, {
      userIdColumn: owner.id,
      titleColumn: title,
      bodyColumn: body,
      isSyncedWithCloudColumn: 1,
    });

    final note = DataBaseNote(
      id: notesId,
      userId: owner.id,
      title: title,
      body: body,
      isSyncedWithCloud: true,
    );

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteUser();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDataBaseOrThrow();
    final numberOfDeletions = await db.delete(notesTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }

  Future<DataBaseNote> getNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DataBaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DataBaseNote>> getAllNotes() async {
    final db = _getDataBaseOrThrow();
    final notes = await db.query(
      notesTable,
    );

    final result = notes.map(
      (notesRow) => DataBaseNote.fromRow(notesRow),
    );

    return result;
  }

  Future<DataBaseNote> updateNote(
      {required DataBaseNote note,
      required String title,
      required String body}) async {
    final db = _getDataBaseOrThrow();

    //Make sure note exists.
    await getNote(id: note.id);

    //Update Database.
    final updateCount = await db.update(notesTable,
        {titleColumn: title, bodyColumn: body, isSyncedWithCloudColumn: 0});
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<DataBaseUser> getOrCreateUser(
      {required String email, required fullName}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email, fullName: fullName);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }
}

@immutable
class DataBaseUser {
  final int id;
  final String fullName;
  final String email;
  const DataBaseUser(
      {required this.id, required this.fullName, required this.email});

  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String,
        fullName = map[fullNameColumn] as String;

  @override
  String toString() => "Person, ID = $id,email =$email";

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataBaseNote {
  final int id;
  final int userId;
  final String title;
  final String body;
  final bool isSyncedWithCloud;

  DataBaseNote(
      {required this.id,
      required this.userId,
      required this.title,
      required this.body,
      required this.isSyncedWithCloud});

  DataBaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[idColumn] as int,
        title = map[titleColumn] as String,
        body = map[bodyColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() {
    return "Note, ID = $id isSyncedWithCloud = $isSyncedWithCloud ,title = $title, body = $body";
  }

  @override
  bool operator ==(covariant DataBaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//Note that the string are gotten from the name of the columns in the database. They have to match.
const dbName = "notesDb";
const notesTable = "notes";
const userTable = "table";
const idColumn = "id";
const fullNameColumn = "full_name";
const emailColumn = "email";
const userIdColumn = "user_id";
const titleColumn = "title";
const bodyColumn = "body";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL UNIQUE,
	"full_name"	TEXT NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"title"	TEXT,
	"body"	TEXT,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';
