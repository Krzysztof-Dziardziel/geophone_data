import 'package:flutter/material.dart';

bool isRedActive = true;
bool isGreenActive = false;
bool isBlueActive = false;

class ChannelSelectors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
          color: Colors.red,
          child: Text('CH1'),
          onPressed: () {
            isRedActive = !isRedActive;
          },
        ),
        MaterialButton(
          color: Colors.green,
          child: Text('CH2'),
          onPressed: () {
            isGreenActive = !isGreenActive;
          },
        ),
        MaterialButton(
          color: Colors.blue,
          child: Text('CH3'),
          onPressed: () {
            isBlueActive = !isBlueActive;
          },
        ),
      ],
    );
  }
}
