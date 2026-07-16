import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_app/data/character_dao.dart';
import 'package:language_app/model/character_model.dart';

class CharacterTrainerNotifier extends ChangeNotifier {
  final List<Character> _characterList;
  final CharacterDao _characterDao;
  final _player = AudioPlayer();
  final _stopwatch = Stopwatch()..start();
  final Set _errors = {};
  int _index = 0;
  Color _boxColor = Colors.white;
  Timer? _flashTimer;

  CharacterTrainerNotifier({
    required List<Character> characters,
    required CharacterDao characterDao,
  }) : _characterList = List.of(characters)..shuffle(),
       _characterDao = characterDao;

  // Getters
  Character get character =>
      _characterList[min(_index, _characterList.length - 1)];
  List<Character> get characterList => _characterList;
  Color get widgetColor => _boxColor;
  bool get isFinished => _index >= _characterList.length;
  Duration get duration => _stopwatch.elapsed;
  Set get errors => _errors;

  // next character
  void nextCharacter() {
    _index += 1;
    print('new _index $_index');
    notifyListeners();
  }

  void _flash(Color color) {
    _flashTimer?.cancel();
    _boxColor = color;
    notifyListeners();
    _flashTimer = Timer(Duration(milliseconds: 700), () {
      _boxColor = Colors.white;
      notifyListeners();
    });
  }

  // check answer
  void checkAnswer(String answer) {
    print("checking answer in notifier $answer");
    if (answer.toLowerCase().trim() ==
        character.translation.toLowerCase().trim()) {
      character.correctAnswer();

      print('correct answer');
      _player.play(AssetSource(character.audio));
      _flash(const Color(0xFF00FFCC).withOpacity(0.2)); // Neon green/teal tint
      nextCharacter();
    } else {
      character.wrongAnswer();
      _flash(const Color(0xFFFF0055).withOpacity(0.2)); // Neon red/pink tint
      print('wrong answer, correct answer is ${character.translation}');
      _errors.add(character.id!);
    }
  }

  Future<void> saveSession() async {
    for (var char in _characterList) {
      await _characterDao.update(char);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _flashTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}
