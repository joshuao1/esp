import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_app/data/character_dao.dart';
import 'package:language_app/notifier/character_trainer_notifier.dart';
import 'package:language_app/notifier/history_notifier.dart';
import 'package:language_app/widget/character_list_page.dart';
import 'package:language_app/widget/character_select_page.dart';
import 'package:language_app/widget/character_train_page.dart';
import 'package:language_app/notifier/character_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedGroups = [
      'za',
      'ya',
      'wa',
      'ta',
      'sha',
      'sa',
      'rya',
      'ra',
      'pya',
      'pa',
      'nya',
      'na',
      'mya',
      'ma',
      'kya',
      'ka',
      'ja',
      'hya',
      'ha',
      'gya',
      'ga',
      'da',
      'cha',
      'bya',
      'ba',
      'a',
    ];
    final characterNotifier = context.watch<CharacterNotifier>();
    final allCharacters = characterNotifier.characters;
    final now = DateTime.now();
    final dueCharacters = allCharacters.where(
      (char) => char.nextTrainDate != null && now.isAfter(char.nextTrainDate!),
    );
    final newCharacters = allCharacters
        .where((char) => char.lastTrainDate == null)
        .take(10);
    final trainingCharacters = {...dueCharacters, ...newCharacters}.toList();
    final errorCharacters = allCharacters
        .where(
          (char) =>
              char.lastErrorDate != null &&
              now.difference(char.lastErrorDate!).inDays >= 1,
        )
        .toList();
    // final historyNotifier = context.watch<HistoryNotifier>();
    // final characterErrors = historyNotifier.histories
    //     .where((element) => !element.correct)
    //     .toList();
    // characterErrors.sort((a, b) => a.date.compareTo(b.date));
    // characterErrors.map((element) => element.characterFk);
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => CharacterListPage()),
                ),
                child: Text("Character List"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => CharacterTrainerNotifier(
                        characters: characterNotifier.characters
                            .where(
                              (char) =>
                                  selectedGroups.contains(char.characterGroup),
                            )
                            .toList(),
                        characterDao: context.read<CharacterDao>(),
                      ),
                      child: CharacterTrainerPage(),
                    ),
                  ),
                ),
                child: Text("Character Trainer"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CharacterSelectPage(),
                  ),
                ),
                child: Text("Select Characters"),
              ),
              ElevatedButton(
                onPressed: () => errorCharacters.isEmpty
                    ? null
                    : Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => CharacterTrainerNotifier(
                              characters: errorCharacters,
                              characterDao: context.read<CharacterDao>(),
                            ),
                            child: CharacterTrainerPage(),
                          ),
                        ),
                      ),
                child: Text(
                  errorCharacters.isEmpty ? "No Errors" : "Practice Errors",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  trainingCharacters.isEmpty
                      ? null
                      : Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => CharacterTrainerNotifier(
                                characters: trainingCharacters,
                                characterDao: context.read<CharacterDao>(),
                              ),
                              child: CharacterTrainerPage(),
                            ),
                          ),
                        );
                },
                child: Text(
                  trainingCharacters.isEmpty
                      ? "Training Complete"
                      : "Spaced Repetition Training",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
