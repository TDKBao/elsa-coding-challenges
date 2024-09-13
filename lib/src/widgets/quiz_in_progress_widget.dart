import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_text_constants.dart';
import '../controllers/quiz_controller.dart';
import 'leaderboard_widget.dart';

class QuizInProgressWidget extends StatelessWidget {
  final QuizController controller;

  const QuizInProgressWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCurrentQuestion(),
        const SizedBox(height: 20),
        _buildAnswerOptions(),
        const SizedBox(height: 20),
        Expanded(child: LeaderboardWidget(controller: controller)),
      ],
    );
  }

  Widget _buildCurrentQuestion() {
    return Obx(() {
      final question = controller.currentQuestion.value;
      if (question == null) {
        return const Text(AppTextConstants.loadingQuestion);
      }
      return Text(
        question.text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    });
  }

  Widget _buildAnswerOptions() {
    return Obx(() {
      final question = controller.currentQuestion.value;
      if (question == null) {
        return const SizedBox.shrink();
      }
      return Column(
        children: question.options.map((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => controller.submitAnswer(option),
              child: Text(option),
            ),
          );
        }).toList(),
      );
    });
  }
}
