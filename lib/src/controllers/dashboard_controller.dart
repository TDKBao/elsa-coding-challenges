import 'dart:math';

import 'package:get/get.dart';

import '../services/logging_service.dart';

class DashboardController extends GetxController {
  final roomCode = ''.obs;
  final userName = ''.obs;

  void addRoomCode(String code) {
    roomCode.value = code;
  }

  void addUserName(String name) {
    userName.value = name;
  }

  bool joinRoom() {
    if (roomCode.value.isNotEmpty) {
      if (userName.value.isEmpty) {
        userName.value = 'User${Random().nextInt(1000)}';
      }
      LoggingService.logInfo(
          'User ${userName.value} joined room ${roomCode.value}');

      return true;
    } else {
        LoggingService.logWarning(
          'Attempt to join room with empty room code');

      Get.snackbar('Error', 'Please enter a room code');
      return false;
    }
  }
}
