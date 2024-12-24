import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  final Color fillColor;
  final double topRadius;

  TrianglePainter({
    this.fillColor = Colors.black,
    this.topRadius = 20.0, // Default radius for the rounded top corner
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return true;
  }
}
