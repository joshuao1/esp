import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_app/model/character_session.dart';
import 'package:language_app/model/history_model.dart';
import 'package:language_app/notifier/character_trainer_notifier.dart';
import 'package:language_app/notifier/history_notifier.dart';
import 'package:language_app/widget/results_page.dart';
import 'package:language_app/widget/styled_container.dart';
import 'package:provider/provider.dart';

class CharacterTrainerPage extends StatefulWidget {
  const CharacterTrainerPage({super.key});

  // final List<Character> characterList;
  // const CharacterTrainerPage({super.key, required this.characterList});

  @override
  State<CharacterTrainerPage> createState() => _CharacterTrainerPageState();
}

class _CharacterTrainerPageState extends State<CharacterTrainerPage> {
  final _controller = TextEditingController();
  Set errors = {};
  List<History> historyList = [];

  FocusNode inputFocusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }

  // Future<void> saveHistory() async {
  //   // Save results of the session to the database
  //   final historyNotifier = context.read<HistoryNotifier>();
  //   for (var item in historyList) {
  //     historyNotifier.addHistory(item);
  //   }
  // }

  void checkAnswer(String answer) async {
    final trainerNotifier = context.read<CharacterTrainerNotifier>();
    trainerNotifier.checkAnswer(answer);
    print("is finsihed ${trainerNotifier.isFinished}");
    if (trainerNotifier.isFinished) {
      await trainerNotifier.saveSession();
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => ResultsPage(
            sessionData: CharacterSession(
              date: DateTime.now(),
              content: trainerNotifier.characterList,
              errors: trainerNotifier.errors.toList(),
              duration: trainerNotifier.duration,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var trainerNotifier = context.watch<CharacterTrainerNotifier>();
    return Scaffold(
      appBar: AppBar(title: Text("Character Trainer")),
      body: SafeArea(
        child: StyledContainer(
          color: trainerNotifier.widgetColor,
          child: Column(
            spacing: 20,
            children: [
              Text(
                // widget.characterList[index].character,
                trainerNotifier.character.character,
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    // Shadow(color: Color(0xFF00FFCC), blurRadius: 15),
                    // Shadow(color: Color(0xFF00FFCC), blurRadius: 30),
                  ],
                ),
              ),
              TextField(
                controller: _controller,
                autocorrect: false,
                enableSuggestions: false,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF00FFCC),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter Romaji',
                  hintStyle: TextStyle(color: Colors.white30),
                ),
                onSubmitted: (String value) {
                  checkAnswer(_controller.value.text);
                  // checkAnswer();
                  _controller.clear();
                  inputFocusNode.requestFocus();
                },
                autofocus: true,
                focusNode: inputFocusNode,
              ),

              // if (answer.isNotEmpty) Text(answer),
              ElevatedButton.icon(
                // onPressed: () => checkAnswer(),
                onPressed: () {
                  checkAnswer(_controller.value.text);
                  _controller.clear();
                },
                label: Text("Next"),
                icon: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
