import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortune_wheel/widgets/wheel_result_indicator.dart';
import 'package:fortune_wheel/widgets/wheel_slice.dart';

import '../controller/fortune_wheel_controller.dart';
import 'fortune_wheel_child.dart';

export '../controller/fortune_wheel_controller.dart';
export 'fortune_wheel_child.dart';

class FortuneWheel<T> extends StatefulWidget {
  const FortuneWheel({
    required this.controller,
    required this.children,
    this.turnSpeed = 4,
    this.rotationTimeLowerBound = 2000,
    this.rotationTimeUpperBound = 4000,
    this.onTapIndicator,
    this.excludedIndices = const [],
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.fillColor,
    this.hasVibration = true,
    this.canTap = true,
  })  : assert(children.length > 1, 'List with at least two elements must be given'),
        assert(
            children.length > excludedIndices.length,
            'Not valid length of excluded indices. The length of children'
            ' is less than or equal to of the length excluded indices.');

  final FortuneWheelController<T> controller;
  final List<FortuneWheelChild<T>> children;
  final double turnSpeed;
  final int rotationTimeLowerBound;
  final int rotationTimeUpperBound;
  final VoidCallback? onTapIndicator;
  final List<int> excludedIndices;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final bool hasVibration;
  final bool canTap;
  final Color? fillColor;

  @override
  _FortuneWheelState createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double size;
  int? lastIndex;

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initiateAnimation();
    _initiateControllerSubscription();
    super.initState();
  }

  void _initiateAnimation() {
    _animationController = new AnimationController(vsync: this, lowerBound: 0, upperBound: double.infinity);

    _animationController.value = (0.5 / (widget.children.length));

    _animationController.addListener(() async {
      int currentIndex = ((_animationController.value % 1) * widget.children.length).floor();

      if (widget.hasVibration && currentIndex != lastIndex) {
        lastIndex = currentIndex;

        HapticFeedback.lightImpact();
      }

      widget.controller
          .setValue(widget.children[((widget.children.length) * (_animationController.value % 1)).floor()]);

      if (_animationController.isCompleted) {
        widget.controller.animationFinished();
      }
    });
  }

  void _initiateControllerSubscription() {
    widget.controller.addListener(() {
      if (!widget.controller.shouldStartAnimation || widget.controller.isAnimating) return;

      _startAnimation();
    });
  }

  void _startAnimation() {
    widget.controller.animationStarted();
    int milliseconds;
    double rotateDistance;
    do {
      milliseconds = Random().nextInt(widget.rotationTimeLowerBound) +
          (widget.rotationTimeUpperBound - widget.rotationTimeLowerBound);
      rotateDistance = (milliseconds / 1000.0 * widget.turnSpeed);
    } while (widget.excludedIndices.contains(
      ((widget.children.length) * ((_animationController.value + rotateDistance) % 1)).floor(),
    ));

    _animationController.value = _animationController.value % 1;

    _animationController.duration = Duration(milliseconds: milliseconds.toInt());

    _animationController.animateTo(_animationController.value + rotateDistance, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        size = min(constraints.maxHeight, constraints.maxWidth);

        return SizedBox(
          width: size,
          height: size,
          child: _getWheelContent(),
        );
      }),
    );
  }

  Stack _getWheelContent() {
    return Stack(
      children: [
        _getSlices(),
        _getIndicator(),
      ],
    );
  }

  WheelResultIndicator _getIndicator() => WheelResultIndicator(
        wheelSize: size,
        animationController: _animationController,
        childCount: widget.children.length,
        onTap: widget.onTapIndicator,
        canTap: widget.canTap,
      );

  Widget _getSlices() {
    double fourthCircleAngle = pi / 2;
    double pieceAngle = pi * 2 / widget.children.length;
    return Stack(
      children: [
        for (int index = 0; index < widget.children.length; index++)
          Transform.rotate(
            angle: (-fourthCircleAngle) - (pieceAngle / 2),
            child: WheelSlice(
              index: index,
              size: size,
              fortuneWheelChildren: widget.children,
              isSelected: ((_animationController.value % 1) * widget.children.length).floor() == index,
              selectedBorderColor: widget.selectedBorderColor,
              unselectedBorderColor: widget.unselectedBorderColor,
              fillColor: widget.fillColor,
            ),
          ),
      ],
    );
  }
}
