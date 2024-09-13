import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logQuizStart(String quizId) async {
    await _analytics.logEvent(
      name: 'quiz_start',
      parameters: {'quiz_id': quizId},
    );
  }

  Future<void> logQuizComplete(String quizId, int score) async {
    await _analytics.logEvent(
      name: 'quiz_complete',
      parameters: {
        'quiz_id': quizId,
        'score': score,
      },
    );
  }

  Future<void> logAnswerSubmit(
      String quizId, String questionId, bool isCorrect) async {
    await _analytics.logEvent(
      name: 'answer_submit',
      parameters: {
        'quiz_id': quizId,
        'question_id': questionId,
        'is_correct': isCorrect ? 'true' : 'false', // Convert boolean to string
      },
    );
  }

  Future<void> logQuizRestart(String quizId) async {
    await _analytics.logEvent(
      name: 'quiz_restart',
      parameters: {'quiz_id': quizId},
    );
  }

  Future<void> setUserEvent(String userId, String userName) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'user_name', value: userName);
  }
}