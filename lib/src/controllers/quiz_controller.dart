import 'dart:convert';

import 'package:get/get.dart';
import '../config/app_config.dart';
import '../config/constants.dart';
import '../models/participant_model.dart';
import '../models/question_model.dart';
import '../models/score_model.dart';
import '../services/analytics_service.dart';
import '../services/logging_service.dart';
import '../services/quiz_service.dart';
import 'auth_controller.dart';

class QuizController extends GetxController {
  final QuizService _quizService = QuizService();
  final AuthController _authController = Get.find<AuthController>();
  final AnalyticsService _analyticsService = AnalyticsService();

  final quizId = ''.obs;
  final userName = ''.obs;
  final scores = <String, Score>{}.obs;
  final participants = <String, Participant>{}.obs;
  final currentQuestion = Rxn<Question>();
  final questions = <Question>[].obs;
  final currentQuestionIndex = 0.obs;
  final leaderboardPage = 0.obs;
  final leaderboardPageSize = 20;
  final isQuizCompleted = false.obs;

  QuizController(String quizId, String userName) {
     reset(quizId, userName);
    this.quizId.value = quizId;
    this.userName.value = userName;
  }

  @override
  void onInit() {
    super.onInit();
    _ensureSignedIn();
  }

  void reset(String newQuizId, String newUserName) {
    quizId.value = newQuizId;
    userName.value = newUserName;
    scores.clear();
    participants.clear();
    currentQuestion.value = null;
    questions.clear();
    currentQuestionIndex.value = 0;
    leaderboardPage.value = 0;
    isQuizCompleted.value = false;
  }

  Future<void> _initializeQuiz() async {
    reset(quizId.value, userName.value);
    await _addQuestionsIfNeeded();
    _listenToQuizChanges();
    _loadQuestions();
    await joinQuiz();
    _analyticsService.logQuizStart(quizId.value);
    _analyticsService.setUserEvent(
        _authController.firebaseUser.value!.uid, userName.value);
  }

  Future<void> _ensureSignedIn() async {
    if (_authController.firebaseUser.value == null) {
      try {
        await _authController.signInAnonymously();
        await _initializeQuiz();
      } catch (e, stackTrace) {
        LoggingService.logError('Error signing in anonymously', e, stackTrace);
      }
    } else {
      await _initializeQuiz();
    }
  }

  Future<void> _addQuestionsIfNeeded() async {
    try {
      bool questionsExist = await _quizService.questionsExist(quizId.value);
      if (!questionsExist) {
        final questionsJsonString =
            AppConfig.getStringValue(AppConstants.LOCAL_QUIZ_QUESTIONS);
        if (questionsJsonString == null) {
          LoggingService.logError(
              'LOCAL_QUIZ_QUESTIONS not found in AppConfig');
          return;
        }

        try {
          final Map<String, dynamic> data = json.decode(questionsJsonString);
          final List<dynamic> questionsData = data['quiz_questions'];
          final sampleQuestions = questionsData
              .map((questionData) =>
                  Question.fromMap(questionData as Map<String, dynamic>))
              .toList();

          final questionMaps = sampleQuestions.map((q) => q.toMap()).toList();
          await _quizService.addQuestions(quizId.value, questionMaps);
          LoggingService.logInfo('Sample questions added successfully');
        } catch (e, stackTrace) {
          LoggingService.logError(
              'Error parsing LOCAL_QUIZ_QUESTIONS', e, stackTrace);
        }
      }
    } catch (e, stackTrace) {
      LoggingService.logError('Error in _addQuestionsIfNeeded', e, stackTrace);
    }
  }

  void _listenToQuizChanges() {
    _quizService.getQuizStream(quizId.value).listen((quizData) {
      scores.assignAll(quizData['scores'] as Map<String, Score>);
      participants
          .assignAll(quizData['participants'] as Map<String, Participant>);
    });
  }

  Future<void> _loadQuestions() async {
    questions.value = await _quizService.getQuestions(quizId.value);
    if (questions.isNotEmpty) {
      currentQuestion.value = questions[0];
    }
  }

  Future<void> submitAnswer(String answer) async {
    final userId = _authController.firebaseUser.value?.uid;
    if (userId == null) return;

    final currentQuestionValue = currentQuestion.value;
    if (currentQuestionValue == null) return;

    await _quizService.submitAnswer(
        quizId.value, userId, currentQuestionValue.id, answer);

    final currentScore = scores[userId]?.score ?? 0;
    final isCorrect = answer == currentQuestionValue.correctAnswer;
    final scoreIncrement = isCorrect ? 10 : 0;
    final newScore = currentScore + scoreIncrement;

    final score = Score(
      userId: userId,
      score: newScore,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _quizService.updateScore(quizId.value, score);
    await _analyticsService.logAnswerSubmit(
        quizId.value, currentQuestionValue.id, isCorrect);

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      currentQuestion.value = questions[currentQuestionIndex.value];
    } else {
      isQuizCompleted.value = true;
      _analyticsService.logQuizComplete(quizId.value, newScore);
      Get.snackbar('Quiz Completed', 'You have answered all questions!');
    }
  }

  Future<void> restartQuiz() async {
    currentQuestionIndex.value = 0;

    if (questions.isNotEmpty) {
      currentQuestion.value = questions[0];
    }
    isQuizCompleted.value = false;

    final userId = _authController.firebaseUser.value?.uid;
    if (userId != null) {
      final newScore = Score(
        userId: userId,
        score: 0,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _quizService.updateScore(quizId.value, newScore);
    }

    _analyticsService.logQuizRestart(quizId.value);

    Get.snackbar('Quiz Restarted', 'Good luck!');
  }

  Future<void> joinQuiz() async {
    final userId = _authController.firebaseUser.value?.uid;
    if (userId != null) {
      final participant = Participant(
        id: userId,
        name: userName.value,
        joinedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _quizService.joinQuiz(quizId.value, participant);
    }
  }

  Future<void> loadLeaderboardPage() async {
    final leaderboard = await _quizService.getLeaderboardPage(
        quizId.value, leaderboardPage.value, leaderboardPageSize);
    scores.addAll(leaderboard);
    leaderboardPage.value++;
  }
}
