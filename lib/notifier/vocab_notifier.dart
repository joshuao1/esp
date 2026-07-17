import 'package:flutter/material.dart';
import 'package:Esp/data/vocab_dao.dart';
import 'package:Esp/model/vocab_model.dart';

class VocabNotifier extends ChangeNotifier {
  final VocabDao dao;
  VocabNotifier(this.dao);

  List<Vocab> _vocabs = [];
  bool _isLoading = false;

  List<Vocab> get vocabs => _vocabs;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _vocabs = await dao.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateVocab(Vocab vocab) async {
    await dao.update(vocab);
    await load();
  }
}
