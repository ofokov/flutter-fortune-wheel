import 'dart:math';

import 'package:flutter/material.dart';

class WheelSlicePainter extends CustomPainter {
  WheelSlicePainter({
    required this.divider,
    required this.number,
    required this.fillColor,
    required this.isSelected,
    required this.selectedBorderColor,
    required this.unselectedBorderColor,
    this.gapAngle = 0.06, // Default gap angle in radians
  });

  final int divider;
  final int number;
  final Color? fillColor;
  final double gapAngle; // Gap angle between slices
  final bool isSelected;
  final Color selectedBorderColor;
  final Color unselectedBorderColor;

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
    _drawRoundedBottomBorder(canvas, size);
  }

  void _initializeStroke() {
    currentPaint = Paint()
      ..color = isSelected ? selectedBorderColor : unselectedBorderColor
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
    final innerRadius = radius * 0.5;
    const double borderRadius = 10;

    Path borderPath = Path()
      ..moveTo(
        size.width / 2 + innerRadius * cos(gapAngle / 2) + borderRadius,
        size.height / 2 + innerRadius * sin(gapAngle / 2),
      )
      ..lineTo(
        size.width / 2 + radius * cos(gapAngle / 2) - borderRadius * cos(gapAngle / 2),
        size.height / 2 + radius * sin(gapAngle / 2) + (borderRadius * sin(gapAngle)),
      )
      ..arcToPoint(
        Offset(
          size.width / 2 + radius * cos(gapAngle / 2) - (borderRadius * sin(gapAngle)),
          size.height / 2 + radius * sin(gapAngle / 2) + borderRadius * cos(gapAngle / 2),
        ),
        radius: Radius.circular(borderRadius),
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        gapAngle / 2 + (borderRadius / radius), // Account for the rounded corner offset
        angleWidth - (2 * borderRadius / radius),
        false,
      )
      ..arcToPoint(
        Offset(
          size.width / 2 + radius * cos(angleWidth + gapAngle / 2) - borderRadius * cos(angleWidth + gapAngle / 2),
          size.height / 2 + radius * sin(angleWidth + gapAngle / 2) - borderRadius * sin(angleWidth + gapAngle / 2),
        ),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(
        size.width / 2 + innerRadius * cos(angleWidth + gapAngle / 2) + borderRadius * sin(angleWidth + gapAngle / 2),
        size.height / 2 + innerRadius * sin(angleWidth + gapAngle / 2) + borderRadius * sin(angleWidth - gapAngle / 2),
      )
      ..arcToPoint(
        Offset(
          size.width / 2 + innerRadius * cos(angleWidth + gapAngle / 2) + borderRadius * sin(angleWidth - gapAngle / 2),
          size.height / 2 +
              innerRadius * sin(angleWidth + gapAngle / 2) -
              borderRadius * cos(angleWidth + gapAngle / 2),
        ),
        radius: Radius.circular(borderRadius),
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: innerRadius),
        angleWidth + gapAngle / 2 - borderRadius / radius,
        -angleWidth + 2 * borderRadius / radius,
        false,
      )
      ..arcToPoint(
        Offset(
          size.width / 2 + innerRadius * cos(gapAngle / 2) + borderRadius,
          size.height / 2 + innerRadius * sin(gapAngle / 2),
        ),
        radius: Radius.circular(borderRadius),
      )
      ..close();

    canvas.drawPath(borderPath, currentPaint!);
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

  void _drawRoundedBottomBorder(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final innerRadius = radius * 0.5;
    const double borderRadius = 10;

    Path borderPath = Path()
      ..moveTo(
        size.width / 2 + innerRadius * cos(gapAngle / 2) + borderRadius,
        size.height / 2 + innerRadius * sin(gapAngle / 2),
      )
      ..lineTo(
        size.width / 2 + radius * cos(gapAngle / 2) - borderRadius * cos(gapAngle / 2),
        size.height / 2 + radius * sin(gapAngle / 2) + (borderRadius * sin(gapAngle)),
      )
      ..arcToPoint(
        Offset(
          size.width / 2 + radius * cos(gapAngle / 2) - (borderRadius * sin(gapAngle)),
          size.height / 2 + radius * sin(gapAngle / 2) + borderRadius * cos(gapAngle / 2),
        ),
        radius: Radius.circular(borderRadius),
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        gapAngle / 2 + (borderRadius / radius), // Account for the rounded corner offset
        angleWidth - (2 * borderRadius / radius),
        false,
      )
      ..arcToPoint(
        Offset(
          size.width / 2 + radius * cos(angleWidth + gapAngle / 2) - borderRadius * cos(angleWidth + gapAngle / 2),
          size.height / 2 + radius * sin(angleWidth + gapAngle / 2) - borderRadius * sin(angleWidth + gapAngle / 2),
        ),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(
        size.width / 2 + innerRadius * cos(angleWidth + gapAngle / 2) + borderRadius * sin(angleWidth + gapAngle / 2),
        size.height / 2 + innerRadius * sin(angleWidth + gapAngle / 2) + borderRadius * sin(angleWidth - gapAngle / 2),
      )
      ..arcToPoint(
        Offset(
          size.width / 2 + innerRadius * cos(angleWidth + gapAngle / 2) + borderRadius * sin(angleWidth - gapAngle / 2),
          size.height / 2 +
              innerRadius * sin(angleWidth + gapAngle / 2) -
              borderRadius * cos(angleWidth + gapAngle / 2),
        ),
        radius: Radius.circular(borderRadius),
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: innerRadius),
        angleWidth + gapAngle / 2 - borderRadius / radius,
        -angleWidth + 2 * borderRadius / radius,
        false,
      )
      ..arcToPoint(
        Offset(
          size.width / 2 + innerRadius * cos(gapAngle / 2) + borderRadius,
          size.height / 2 + innerRadius * sin(gapAngle / 2),
        ),
        radius: Radius.circular(borderRadius),
      )
      ..close();

    canvas.drawPath(borderPath, currentPaint!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
