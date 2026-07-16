import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:language_app/notifier/history_notifier.dart';
import 'package:language_app/widget/styled_container.dart';
import 'package:provider/provider.dart';
import 'package:language_app/notifier/character_notifier.dart';
import 'package:intl/intl.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final player = AudioPlayer();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var characterNotifier = context.watch<CharacterNotifier>();
    // var historyNotifier = context.watch<HistoryNotifier>();

    if (characterNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Character List')),
      body: SafeArea(
        child: ListView.builder(
          itemCount: characterNotifier.characters.length,
          itemBuilder: (context, index) {
            final character = characterNotifier.characters[index];
            final accuracy =
                (character.numCorrect * 100 / character.numAttempts);

            return GestureDetector(
              onTap: () => player.play(AssetSource(character.audio)),
              child: StyledContainer(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            character.character,
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
                            character.translation,
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
                          Text('Attempts: ${character.numAttempts}'),
                          Text('Level: ${character.level}'),
                          Text(
                            'Last Train Date: ${character.lastTrainDate != null ? DateFormat('yyyy-MM-dd').format(character.lastTrainDate!) : 'No date'}',
                            style: TextStyle(
                              color: character.lastTrainDate == null
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),
                          Text(
                            'Next Due: ${character.nextTrainDate != null ? DateFormat('yyyy-MM-dd').format(character.nextTrainDate!) : 'No date'}',
                            style: TextStyle(
                              color: character.nextTrainDate == null
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),

                          // Text(
                          //   // 'Next Due: ${DateTime.fromMillisecondsSinceEpoch(character.nextTrainDate as int)}',
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
