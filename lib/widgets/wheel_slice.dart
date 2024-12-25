import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fortune_wheel/painters/wheel_slice_painter.dart';
import 'package:fortune_wheel/widgets/fortune_wheel.dart';

class WheelSlice<T> extends StatelessWidget {
  WheelSlice({
    required this.index,
    required this.size,
    required this.fortuneWheelChildren,
    this.isSelected = false,
    this.selectedBorderColor,
    this.fillColor,
    this.unselectedBorderColor,
  });

  final int index;
  final double size;
  final List<FortuneWheelChild> fortuneWheelChildren;
  final bool isSelected;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    int childCount = fortuneWheelChildren.length;
    double pieceAngle = (index / childCount * pi * 2);
    double pieceWidth = childCount == 2 ? size : sin(pi / childCount) * size / 2;
    double pieceHeight = size / 2;

    return Stack(
      children: [
        _getSliceBackground(pieceAngle, childCount),
        _getSliceForeground(pieceAngle, pieceWidth, pieceHeight),
      ],
    );
  }

  Widget _getSliceForeground(double pieceAngle, double pieceWidth, double pieceHeight) {
    double centerOffset = (pi / fortuneWheelChildren.length);
    double leftRotationOffset = (-pi / 2);

    return Transform.rotate(
      angle: leftRotationOffset + pieceAngle + centerOffset,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Positioned(
            top: size / 1.6,
            left: size / 2 - pieceWidth / 2,
            child: Container(
              // padding: EdgeInsets.all(4),
              height: pieceHeight,
              width: pieceWidth,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: -pieceAngle - leftRotationOffset * 2,
                  child: fortuneWheelChildren[index].foreground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Transform _getSliceBackground(double pieceAngle, int childCount) {
    return Transform.rotate(
      angle: pieceAngle,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            child: CustomPaint(
              painter: WheelSlicePainter(
                divider: childCount,
                number: index,
                borderColor: isSelected
                    ? selectedBorderColor ?? Colors.white.withOpacity(0.3)
                    : unselectedBorderColor ?? Colors.white.withOpacity(0.3),
                fillColor: fillColor,
              ),
              size: Size(size, size),
            ),
          ),
        ],
      ),
    );
  }
}
