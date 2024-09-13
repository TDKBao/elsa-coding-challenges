import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_text_constants.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  final dashboardController = Get.put(DashboardController());
  final authController = Get.find<AuthController>();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTextConstants.quizDashboardTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: AppTextConstants.roomCodeLabel,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => dashboardController.addRoomCode(value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: AppTextConstants.yourNameLabel,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => dashboardController.addUserName(value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (authController.firebaseUser.value == null) {
                  await authController.signInAnonymously();
                }
                final status = dashboardController.joinRoom();
                if (status && context.mounted) {
                  context.push('/quiz/${dashboardController.roomCode.value}',
                      extra: dashboardController.userName.value);
                }
              },
              child: const Text(AppTextConstants.joinQuizButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
