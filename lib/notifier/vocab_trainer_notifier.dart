import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:Esp/data/vocab_dao.dart';
import 'package:Esp/model/vocab_model.dart';

class VocabTrainerNotifier extends ChangeNotifier {
  final List<Vocab> _vocabList;
  final VocabDao _vocabDao;
  final _player = AudioPlayer();
  final _stopwatch = Stopwatch()..start();
  final Set _errors = {};
  int _index = 0;
  Color _boxColor = Colors.white;
  String? _revealedAnswer;
  Timer? _flashTimer;

  VocabTrainerNotifier({
    required List<Vocab> vocabs,
    required VocabDao vocabDao,
  }) : _vocabList = List.of(vocabs)..shuffle(),
       _vocabDao = vocabDao;

  // Getters
  Vocab get vocab => _vocabList[min(_index, _vocabList.length - 1)];
  List<Vocab> get vocabList => _vocabList;
  Color get widgetColor => _boxColor;
  bool get isFinished => _index >= _vocabList.length;
  Duration get duration => _stopwatch.elapsed;
  String? get revealedAnswer => _revealedAnswer;
  Set get errors => _errors;

  // next vocab
  void nextVocab() {
    _revealedAnswer = null;
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
    if (answer.toLowerCase().trim() == vocab.translation.toLowerCase().trim()) {
      _revealedAnswer = null;
      vocab.correctAnswer();

      print('correct answer');
      // _player.play(AssetSource(vocab.audio));
      _flash(const Color(0xFF00FFCC).withOpacity(0.2)); // Neon green/teal tint
      nextVocab();
    } else {
      _revealedAnswer = vocab.translation;
      vocab.wrongAnswer();
      _flash(const Color(0xFFFF0055).withOpacity(0.2)); // Neon red/pink tint
      print('wrong answer, correct answer is ${vocab.translation}');
      _errors.add(vocab.id!);
      notifyListeners();
    }
  }

  Future<void> saveSession() async {
    for (var char in _vocabList) {
      await _vocabDao.update(char);
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
