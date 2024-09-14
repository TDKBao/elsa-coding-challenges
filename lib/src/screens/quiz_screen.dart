import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_text_constants.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/quiz_in_progress_widget.dart';
import '../widgets/quiz_completed_widget.dart';

class QuizScreen extends StatelessWidget {
  final String roomId;
  final String userName;
  const QuizScreen({super.key, required this.roomId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.put(
      QuizController(roomId, userName),
      tag: roomId,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTextConstants.vocabularyQuizTitle),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    AppTextConstants.currentQuestion
                        .replaceAll(
                            '###currentQuestion###',
                            (controller.currentQuestionIndex.value + 1)
                                .toString())
                        .replaceAll('###totalQuestions###',
                            controller.questions.length.toString()),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showRestartDialog(context, controller),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isQuizCompleted.value) {
            return QuizCompletedWidget(controller: controller);
          } else {
            return QuizInProgressWidget(controller: controller);
          }
        }),
      ),
    );
  }

  void _showRestartDialog(BuildContext context, QuizController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppTextConstants.restartQuizTitle),
          content: const Text(AppTextConstants.restartQuizConfirmation),
          actions: <Widget>[
            TextButton(
              child: const Text(AppTextConstants.cancelText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(AppTextConstants.restartText),
              onPressed: () {
                controller.restartQuiz();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
