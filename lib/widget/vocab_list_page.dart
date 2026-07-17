import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:Esp/widget/styled_container.dart';
import 'package:provider/provider.dart';
import 'package:Esp/notifier/vocab_notifier.dart';
import 'package:intl/intl.dart';

class VocabListPage extends StatefulWidget {
  const VocabListPage({super.key});

  @override
  State<VocabListPage> createState() => _VocabListPageState();
}

class _VocabListPageState extends State<VocabListPage> {
  final player = AudioPlayer();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vocabNotifier = context.watch<VocabNotifier>();
    // var historyNotifier = context.watch<HistoryNotifier>();

    if (vocabNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vocab List')),
      body: SafeArea(
        child: ListView.builder(
          itemCount: vocabNotifier.vocabs.length,
          itemBuilder: (context, index) {
            final vocab = vocabNotifier.vocabs[index];
            final accuracy = (vocab.numCorrect * 100 / vocab.numAttempts);

            return GestureDetector(
              // onTap: () => player.play(AssetSource(vocab.audio)),
              child: StyledContainer(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            vocab.phrase,
                            style: const TextStyle(
                              fontSize: 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF00FFCC),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vocab.translation,
                            style: const TextStyle(
                              color: Color(0xFFFF00FF),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Accuracy: ${accuracy.toStringAsPrecision(3)}%'),
                          Text('Attempts: ${vocab.numAttempts}'),
                          Text('Level: ${vocab.level}'),
                          Text(
                            'Last Train Date: ${vocab.lastTrainDate != null ? DateFormat('yyyy-MM-dd').format(vocab.lastTrainDate!) : 'No date'}',
                            style: TextStyle(
                              color: vocab.lastTrainDate == null
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),
                          Text(
                            'Next Due: ${vocab.nextTrainDate != null ? DateFormat('yyyy-MM-dd').format(vocab.nextTrainDate!) : 'No date'}',
                            style: TextStyle(
                              color: vocab.nextTrainDate == null
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),

                          // Text(
                          //   // 'Next Due: ${DateTime.fromMillisecondsSinceEpoch(vocab.nextTrainDate as int)}',
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
