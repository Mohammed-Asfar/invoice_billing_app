import 'package:flutter/material.dart';

BoxDecoration mirrorWidget(Color color) {
  return BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      border: Border.all(color: Colors.white.withValues(alpha: .13)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: .15),
          color.withValues(alpha: .05),
        ],
      ));
}
