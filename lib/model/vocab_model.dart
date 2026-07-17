class Vocab {
  final int? id;
  final String phrase;
  final String translation;
  DateTime? lastErrorDate;
  DateTime? nextTrainDate;
  DateTime? lastTrainDate;
  DateTime? lastLevelUpDate;
  int level;
  int numAttempts;
  int numCorrect;
  int streak;

  Vocab({
    this.id,
    required this.phrase,
    required this.translation,
    this.lastErrorDate,
    this.nextTrainDate,
    this.lastTrainDate,
    this.lastLevelUpDate,
    required this.level,
    required this.numAttempts,
    required this.numCorrect,
    required this.streak,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'phrase': phrase,
      'translation': translation,
      'last_error_date': lastErrorDate?.millisecondsSinceEpoch,
      'next_train_date': nextTrainDate?.millisecondsSinceEpoch,
      'last_train_date': lastTrainDate?.millisecondsSinceEpoch,
      'last_level_up_date': lastLevelUpDate?.millisecondsSinceEpoch,
      'level': level,
      'num_attempts': numAttempts,
      'num_correct': numCorrect,
      'streak': streak,
    };
  }

  void correctAnswer() {
    if (lastLevelUpDate == null) {
      level += 1;
      lastLevelUpDate = DateTime.now();
    }
    if (lastLevelUpDate != null &&
        DateTime.now().difference(lastLevelUpDate!).inDays > 1) {
      level += 1;
      lastLevelUpDate = DateTime.now();
    }
    streak += 1;
    numAttempts += 1;
    numCorrect += 1;
    lastTrainDate = DateTime.now();
    nextTrainDate = DateTime.now().add(Duration(days: level));
  }

  void wrongAnswer() {
    streak = 0;
    numAttempts += 1;
    level = 0;
    lastErrorDate = DateTime.now();
    lastTrainDate = DateTime.now();
    nextTrainDate = DateTime.now().add(Duration(days: level));
  }

  static Vocab fromMap(Map<String, Object?> map) {
    return Vocab(
      id: map['id'] as int?,
      phrase: map['phrase'] as String,
      translation: map['translation'] as String,
      lastErrorDate: map['last_error_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_error_date'] as int)
          : null,
      nextTrainDate: map['next_train_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['next_train_date'] as int)
          : null,
      lastTrainDate: map['last_train_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_train_date'] as int)
          : null,
      lastLevelUpDate: map['last_level_up_date'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(
              map['last_level_up_date'] as int,
            )
          : null,
      level: map['level'] as int,
      numAttempts: map['num_attempts'] as int,
      numCorrect: map['num_correct'] as int,
      streak: map['streak'] as int,
    );
  }
}
