import 'dart:async';
import 'package:flutter/material.dart';

/// Scrolls to the very bottom repeatedly over time, useful for AnimatedList or delayed layouts
Future<void> forceScrollToBottom(
    ScrollController controller, {
      int retries = 10,
      Duration delay = const Duration(milliseconds: 100),
      Duration duration = const Duration(milliseconds: 500),
    }) async {
  for (int i = 0; i < retries; i++) {
    await Future.delayed(delay);
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: duration,
        curve: Curves.easeOutCubic,
      );
    }
  }
}

/// Scrolls to the bottom once, immediately after layout phase
void scrollToBottom(
    ScrollController controller, {
      Duration duration = const Duration(milliseconds: 300),
      Curve curve = Curves.easeOut,
    }) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: duration,
        curve: curve,
      );
    }
  });
}
