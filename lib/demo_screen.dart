import 'package:flutter/material.dart';

import 'widgets/fortune_wheel.dart';

class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  FortuneWheelController<int> fortuneWheelController = FortuneWheelController();
  FortuneWheelChild? currentWheelChild;
  int currentBalance = 0;

  @override
  void initState() {
    fortuneWheelController.addListener(() {
      if (fortuneWheelController.value == null) return;
      setState(() {
        currentWheelChild = fortuneWheelController.value;
      });
      print(currentWheelChild?.value);
      if (fortuneWheelController.isAnimating) return;

      if (fortuneWheelController.shouldStartAnimation) return;

      setState(() {
        currentBalance += fortuneWheelController.value!.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24),
                Container(
                  height: 80,
                  width: 80,
                  child: currentWheelChild != null ? currentWheelChild!.foreground : Container(),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 350,
                  height: 350,
                  child: FortuneWheel<int>(
                    fillColor: Colors.green.withOpacity(0.4),
                    selectedBorderColor: Colors.blue,
                    unselectedBorderColor: Colors.yellow,
                    turnsPerSecond: 2,
                    rotationTimeLowerBound: 5000,
                    rotationTimeUpperBound: 10000,
                    // excludedIndices: const [0, 1, 2, 3, 4, 5, 6, 7, 8],
                    controller: fortuneWheelController,
                    onTapIndicator: () {
                      fortuneWheelController.rotateTheWheel();
                    },
                    children: [
                      _createFortuneWheelChild(1),
                      _createFortuneWheelChild(2),
                      _createFortuneWheelChild(3),
                      _createFortuneWheelChild(4),
                      _createFortuneWheelChild(5),
                      _createFortuneWheelChild(6),
                      _createFortuneWheelChild(7),
                      _createFortuneWheelChild(8),
                      _createFortuneWheelChild(9),
                      _createFortuneWheelChild(10),
                      _createFortuneWheelChild(11),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () => fortuneWheelController.rotateTheWheel(),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'ROTATE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  FortuneWheelChild<int> _createFortuneWheelChild(int value) {
    Color color = value.isNegative ? Colors.red : Colors.green;
    String verb = value.isNegative ? 'Lose' : 'Win';
    int valueString = value.abs();

    return FortuneWheelChild(
      foreground: _getWheelContentCircle(color, '$verb\n$valueString €'),
      value: value,
    );
  }

  Container _getWheelContentCircle(Color backgroundColor, String text) {
    return Container(
      width: 72,
      height: 72,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.red.withOpacity(0.8),
          width: 2,
        ),
      ),
    );
  }
}
