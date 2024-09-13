import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_text_constants.dart';
import '../controllers/quiz_controller.dart';

class LeaderboardWidget extends StatelessWidget {
  final QuizController controller;

  const LeaderboardWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sortedScores = controller.scores.entries.toList()
        ..sort((a, b) => b.value.score.compareTo(a.value.score));

      return ListView.builder(
        itemCount: sortedScores.length,
        itemBuilder: (context, index) {
          final entry = sortedScores[index];
          final participant = controller.participants[entry.key];
          return Card(
            color: Colors.white.withOpacity(0.8),
            child: ListTile(
              leading: Text('${index + 1}'),
              title: Text(participant?.name ?? AppTextConstants.unknown),
              trailing: Text('${entry.value.score}'),
            ),
          );
        },
      );
    });
  }
}
