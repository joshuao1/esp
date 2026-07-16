import 'package:language_app/model/character_model.dart';

class CharacterSession {
  int? id;
  DateTime date;
  List errors;
  List<Character> content;
  Duration duration;

  CharacterSession({
    required this.date,
    required this.content,
    required this.errors,
    required this.duration,
  });

  double accuracy() {
    return (content.length - errors.length) / content.length * 100;
  }
}
