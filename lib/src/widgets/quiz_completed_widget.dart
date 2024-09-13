import 'package:flutter/material.dart';

import '../constants/app_text_constants.dart';
import '../controllers/quiz_controller.dart';
import 'leaderboard_widget.dart';

class QuizCompletedWidget extends StatelessWidget {
  final QuizController controller;

  const QuizCompletedWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppTextConstants.quizCompleted,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.restartQuiz,
            child: const Text(AppTextConstants.restartQuiz),
          ),
          const SizedBox(height: 20),
          Expanded(child: LeaderboardWidget(controller: controller)),
        ],
      ),
    );
  }
}
