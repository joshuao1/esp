import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Esp/data/vocab_dao.dart';
import 'package:Esp/notifier/vocab_trainer_notifier.dart';
import 'package:Esp/widget/vocab_list_page.dart';
import 'package:Esp/widget/vocab_train_page.dart';
import 'package:Esp/notifier/vocab_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vocabNotifier = context.watch<VocabNotifier>();
    final allVocabs = vocabNotifier.vocabs;
    final now = DateTime.now();
    final dueVocabs = allVocabs.where(
      (char) => char.nextTrainDate != null && now.isAfter(char.nextTrainDate!),
    );
    final newVocabs = allVocabs
        .where((char) => char.lastTrainDate == null)
        .take(10);
    final trainingVocabs = {...dueVocabs, ...newVocabs}.toList();
    final errorVocabs = allVocabs
        .where(
          (char) =>
              char.lastErrorDate != null &&
              now.difference(char.lastErrorDate!).inDays >= 1,
        )
        .toList();
    // final historyNotifier = context.watch<HistoryNotifier>();
    // final vocabErrors = historyNotifier.histories
    //     .where((element) => !element.correct)
    //     .toList();
    // vocabErrors.sort((a, b) => a.date.compareTo(b.date));
    // vocabErrors.map((element) => element.vocabFk);
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
                  CupertinoPageRoute(builder: (context) => VocabListPage()),
                ),
                child: Text("Vocab List"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => VocabTrainerNotifier(
                        vocabs: vocabNotifier.vocabs,
                        vocabDao: context.read<VocabDao>(),
                      ),
                      child: VocabTrainerPage(),
                    ),
                  ),
                ),
                child: Text("Vocab Trainer"),
              ),
              // ElevatedButton(
              //   onPressed: () => Navigator.push(
              //     context,
              //     CupertinoPageRoute(
              //       builder: (context) => VocabSelectPage(),
              //     ),
              //   ),
              //   child: Text("Select Vocabs"),
              // ),
              ElevatedButton(
                onPressed: () => errorVocabs.isEmpty
                    ? null
                    : Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => VocabTrainerNotifier(
                              vocabs: errorVocabs,
                              vocabDao: context.read<VocabDao>(),
                            ),
                            child: VocabTrainerPage(),
                          ),
                        ),
                      ),
                child: Text(
                  errorVocabs.isEmpty ? "No Errors" : "Practice Errors",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  trainingVocabs.isEmpty
                      ? null
                      : Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => VocabTrainerNotifier(
                                vocabs: trainingVocabs,
                                vocabDao: context.read<VocabDao>(),
                              ),
                              child: VocabTrainerPage(),
                            ),
                          ),
                        );
                },
                child: Text(
                  trainingVocabs.isEmpty
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
