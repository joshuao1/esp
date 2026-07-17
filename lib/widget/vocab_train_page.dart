import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Esp/model/trainer_session_model.dart';
import 'package:Esp/notifier/vocab_trainer_notifier.dart';
import 'package:Esp/widget/results_page.dart';
import 'package:Esp/widget/styled_container.dart';
import 'package:provider/provider.dart';

class VocabTrainerPage extends StatefulWidget {
  const VocabTrainerPage({super.key});

  // final List<Vocab> vocabList;
  // const VocabTrainerPage({super.key, required this.vocabList});

  @override
  State<VocabTrainerPage> createState() => _VocabTrainerPageState();
}

class _VocabTrainerPageState extends State<VocabTrainerPage> {
  final _controller = TextEditingController();
  Set errors = {};

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
    final trainerNotifier = context.read<VocabTrainerNotifier>();
    trainerNotifier.checkAnswer(answer);
    print("is finsihed ${trainerNotifier.isFinished}");
    if (trainerNotifier.isFinished) {
      await trainerNotifier.saveSession();
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => ResultsPage(
            sessionData: VocabSession(
              date: DateTime.now(),
              content: trainerNotifier.vocabList,
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
    var trainerNotifier = context.watch<VocabTrainerNotifier>();
    return Scaffold(
      appBar: AppBar(title: Text("Vocab Trainer")),
      body: SafeArea(
        child: StyledContainer(
          color: trainerNotifier.widgetColor,
          child: Column(
            spacing: 20,
            children: [
              Text(
                // widget.vocabList[index].vocab,
                trainerNotifier.vocab.phrase,
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
              if (trainerNotifier.revealedAnswer != null)
                Text(
                  trainerNotifier.revealedAnswer!,
                  style: const TextStyle(
                    color: Color(0xFFFF00FF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Color(0xFFFF00FF), blurRadius: 10)],
                  ),
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
