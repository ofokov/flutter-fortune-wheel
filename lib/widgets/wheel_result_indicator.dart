import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune_wheel/painters/triangle_painter.dart';

class WheelResultIndicator extends StatelessWidget {
  WheelResultIndicator({
    required this.wheelSize,
    required this.animationController,
    required this.childCount,
    this.onTap,
  });

  final double wheelSize;
  final VoidCallback? onTap;
  final AnimationController animationController;
  final int childCount;

  @override
  Widget build(BuildContext context) {
    double indicatorSize = wheelSize * 0.29;
    Color indicatorColor = const Color(0xFF8942FE);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        children: [
          _getCenterIndicatorTriangle(wheelSize, indicatorSize * .75, Colors.white),
          _getCenterIndicatorCircle(indicatorColor, indicatorSize),
        ],
      ),
    );
  }

  Positioned _getCenterIndicatorTriangle(double wheelSize, double indicatorSize, Color indicatorColor) {
    return Positioned(
      top: wheelSize / 2 - indicatorSize,
      left: wheelSize / 2 - (indicatorSize / 2),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            origin: Offset(0, indicatorSize / 2),
            angle: (animationController.value * pi * 2) - (pi / (childCount)),
            child: CustomPaint(
                painter: TrianglePainter(
                  fillColor: indicatorColor,
                ),
                size: Size(indicatorSize, indicatorSize)),
          );
        },
      ),
    );
  }

  Center _getCenterIndicatorCircle(Color indicatorColor, double indicatorSize) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(indicatorSize * 0.2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: indicatorColor,
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: indicatorSize * 0.06,
          ),
          boxShadow: [
            BoxShadow(
              color: indicatorColor.withOpacity(0.6),
              offset: Offset(0, 6),
              blurRadius: 60,
              spreadRadius: 6,
            ),
          ],
        ),
        width: indicatorSize,
        height: indicatorSize,
        child: SvgPicture.asset(
          "assets/ic_rotate.svg",
        ),
      ),
    );
  }
}
