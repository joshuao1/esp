import 'package:Esp/model/vocab_model.dart';
import 'package:sqflite/sqflite.dart';

class VocabDao {
  final Database _database;
  VocabDao(this._database);

  Future<List<Vocab>> getAll() async {
    final maps = await _database.query('vocab', orderBy: 'id ASC');
    return maps.map(Vocab.fromMap).toList();
  }

  Future<void> update(Vocab vocab) async {
    print('Updating vocab: ${vocab.toMap()}');
    final rowsAffected = await _database.update(
      'vocab',
      vocab.toMap(),
      where: 'id = ?',
      whereArgs: [vocab.id],
    );
    print('Rows affected: $rowsAffected');
  }
}
