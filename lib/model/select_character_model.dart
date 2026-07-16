import 'package:language_app/model/character_model.dart';

class SelectCharacter {
  final Character character;
  bool selected;

  SelectCharacter({required this.character, required this.selected});

  void toggle() {
    if (selected) {
      selected = false;
    } else {
      selected = true;
    }
  }
}
