import 'package:Esp/model/vocab_model.dart';

class VocabSession {
  int? id;
  DateTime date;
  List errors;
  List<Vocab> content;
  Duration duration;

  VocabSession({
    required this.date,
    required this.content,
    required this.errors,
    required this.duration,
  });

  double accuracy() {
    return (content.length - errors.length) / content.length * 100;
  }
}
