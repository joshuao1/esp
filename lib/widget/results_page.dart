import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Esp/model/vocab_model.dart';
import 'package:Esp/model/trainer_session_model.dart';
import 'package:Esp/widget/styled_container.dart';

class ResultsPage extends StatelessWidget {
  final VocabSession sessionData;
  const ResultsPage({super.key, required this.sessionData});

  @override
  Widget build(BuildContext context) {
    List<Vocab> wrongVocabs = sessionData.content
        .where((char) => sessionData.errors.contains(char.id))
        .toList();
    print("Errors ${sessionData.errors}");
    print("Content ${sessionData.content.length}");
    return Scaffold(
      appBar: AppBar(title: Text("Results")),
      body: SafeArea(
        child: StyledContainer(
          child: Column(
            children: [
              Text(
                "Length: ${sessionData.content.length}",
                style: const TextStyle(color: Color(0xFF00FFCC), fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Accuracy: ${sessionData.accuracy().toStringAsPrecision(3)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Color(0xFF00FFCC), blurRadius: 10)],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Duration: ${sessionData.duration.inSeconds} seconds",
                style: const TextStyle(color: Color(0xFF00FFCC), fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                "Try Again",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF00FF),
                  shadows: [Shadow(color: Color(0xFFFF00FF), blurRadius: 8)],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: wrongVocabs.length,
                  itemBuilder: (context, index) {
                    Vocab wrongVocab = wrongVocabs[index];
                    return StyledContainer(
                      child: Column(
                        children: [
                          Text(
                            wrongVocab.phrase,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color(0xFFFF00FF),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wrongVocab.translation,
                            style: const TextStyle(
                              color: Color(0xFF00FFCC),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
