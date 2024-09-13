import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:retry/retry.dart';
import '../models/participant_model.dart';
import '../models/question_model.dart';
import '../models/score_model.dart';
import 'logging_service.dart';

class QuizService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Stream<Map<String, dynamic>> getQuizStream(String quizId) {
    return _db.child('quizzes/$quizId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final scores = _parseScores(data['scores']);
        final participants = _parseParticipants(data['participants']);
        return {
          'scores': scores,
          'participants': participants,
        };
      } else {
        return <String, dynamic>{};
      }
    });
  }

  Map<String, Score> _parseScores(dynamic scoresData) {
    if (scoresData is Map) {
      return scoresData.map((key, value) {
        return MapEntry(
            key.toString(),
            Score.fromMap(
                key.toString(), Map<String, dynamic>.from(value as Map)));
      });
    }
    return {};
  }

  Map<String, Participant> _parseParticipants(dynamic participantsData) {
    if (participantsData is Map) {
      return participantsData.map((key, value) {
        return MapEntry(
            key.toString(),
            Participant.fromMap(
                key.toString(), Map<String, dynamic>.from(value as Map)));
      });
    }
    return {};
  }

  Future<void> joinQuiz(String quizId, Participant participant) async {
    await _db
        .child('quizzes/$quizId/participants/${participant.id}')
        .set(participant.toMap());
  }

  Future<void> submitAnswer(
      String quizId, String userId, String questionId, String answer) async {
    const retryOptions = RetryOptions(maxAttempts: 3);
    await retryOptions.retry(
      () => _db.child('quizzes/$quizId/answers').push().set({
        'userId': userId,
        'questionId': questionId,
        'answer': answer,
        'timestamp': ServerValue.timestamp,
      }),
      retryIf: (e) => e is FirebaseException,
    );
  }

  Future<void> updateScore(String quizId, Score score) async {
    final scoreRef = _db.child('quizzes/$quizId/scores/${score.userId}');
    try {
      await scoreRef.runTransaction((Object? mutableData) {
        return Transaction.success(score.toMap());
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Question>> getQuestions(String quizId) async {
    final snapshot = await _db.child('quizzes/$quizId/questions').get();
    if (snapshot.exists) {
      final questionsData = snapshot.value;
      if (questionsData is List) {
        return questionsData
            .where((question) => question != null)
            .map((question) =>
                Question.fromMap(Map<String, dynamic>.from(question as Map)))
            .toList();
      } else if (questionsData is Map) {
        return questionsData.entries
            .map((entry) =>
                Question.fromMap(Map<String, dynamic>.from(entry.value as Map)))
            .toList();
      }
    }
    return [];
  }

  Future<bool> questionsExist(String quizId) async {
    try {
      final snapshot = await _db.child('quizzes/$quizId/questions').get();
      return snapshot.exists;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addQuestions(
      String quizId, List<Map<String, dynamic>> questions) async {
    try {
      final Map<String, dynamic> updates = {};
      for (var i = 0; i < questions.length; i++) {
        updates['quizzes/$quizId/questions/$i'] = questions[i];
      }
      await _db.update(updates);
      LoggingService.logInfo('Questions added successfully');
    } catch (e, stackTrace) {
      LoggingService.logError('Error in addQuestions', e, stackTrace);
      rethrow;
    }
  }

  Future<Map<String, Score>> getLeaderboardPage(
      String quizId, int page, int pageSize) async {
    final snapshot = await _db
        .child('quizzes/$quizId/scores')
        .orderByChild('score')
        .limitToLast(pageSize * (page + 1))
        .get();

    if (snapshot.exists) {
      final scoresData = snapshot.value as Map<dynamic, dynamic>;
      return _parseScores(scoresData);
    }
    return {};
  }
}
