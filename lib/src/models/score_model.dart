class Score {
  final String userId;
  final int score;
  final int updatedAt;

  Score({required this.userId, required this.score, required this.updatedAt});

  factory Score.fromMap(String userId, Map<String, dynamic> map) {
    return Score(
      userId: userId,
      score: map['score'] ?? 0,
      updatedAt: map['updatedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'updatedAt': updatedAt,
    };
  }
}