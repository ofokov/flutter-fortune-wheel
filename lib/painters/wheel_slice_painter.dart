import 'dart:math';

import 'package:flutter/material.dart';

class WheelSlicePainter extends CustomPainter {
  WheelSlicePainter({
    required this.divider,
    required this.number,
    required this.fillColor,
    this.gapAngle = 0.05, // Default gap angle in radians
    this.borderColor,
  });

  final int divider;
  final int number;
  final Color? fillColor;
  final Color? borderColor;
  final double gapAngle; // Gap angle between slices

  Paint? currentPaint;
  double angleWidth = 0;

  @override
  void paint(Canvas canvas, Size size) {
    angleWidth = (pi * 2 / divider) - gapAngle; // Adjust angle to include gap

    // Paint the filled arc
    _initializeFill();
    _drawClippedSlice(canvas, size);

    // Paint the bottom border only
    _initializeStroke();
    _drawBottomBorder(canvas, size);
  }

  void _initializeStroke() {
    currentPaint = Paint()
      ..color = borderColor ?? Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
  }

  void _initializeFill() {
    currentPaint = Paint()
      ..color = fillColor != null ? fillColor! : Colors.transparent
      ..style = PaintingStyle.fill;
  }

  void _drawClippedSlice(Canvas canvas, Size size) {
    final radius = size.width / 2;

    // Define paths for the outer and inner arcs
    Path path = Path()
      ..moveTo(
        size.width / 2 + radius * cos(gapAngle / 2),
        size.height / 2 + radius * sin(gapAngle / 2),
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        gapAngle / 2,
        angleWidth,
        false,
      )
      ..lineTo(
        size.width / 2 + radius * 0.5 * cos(angleWidth + gapAngle / 2),
        size.height / 2 + radius * 0.5 * sin(angleWidth + gapAngle / 2),
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius * 0.5),
        angleWidth + gapAngle / 2,
        -angleWidth,
        false,
      )
      ..close();

    canvas.drawPath(path, currentPaint!);
  }

  void _drawBottomBorder(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final innerRadius = radius * 0.5;

    // Define the bottom border path
    Path borderPath = Path()
      ..moveTo(
        size.width / 2 + innerRadius * cos(gapAngle / 2),
        size.height / 2 + innerRadius * sin(gapAngle / 2),
      )
      ..lineTo(
        size.width / 2 + radius * cos(gapAngle / 2),
        size.height / 2 + radius * sin(gapAngle / 2),
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        gapAngle / 2,
        angleWidth,
        false,
      )
      ..lineTo(
        size.width / 2 + innerRadius * cos(angleWidth + gapAngle / 2),
        size.height / 2 + innerRadius * sin(angleWidth + gapAngle / 2),
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: innerRadius),
        angleWidth + gapAngle / 2,
        -angleWidth,
        false,
      );

    canvas.drawPath(borderPath, currentPaint!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
