import 'package:language_app/model/character_model.dart';
import 'package:sqflite/sqflite.dart';

class CharacterDao {
  final Database _database;
  CharacterDao(this._database);

  Future<List<Character>> getAll() async {
    final maps = await _database.query('characters', orderBy: 'id ASC');
    return maps.map(Character.fromMap).toList();
  }

  Future<void> update(Character character) async {
    print('Updating character: ${character.toMap()}');
    final rowsAffected = await _database.update(
      'characters',
      character.toMap(),
      where: 'id = ?',
      whereArgs: [character.id],
    );
    print('Rows affected: $rowsAffected');
  }
}
