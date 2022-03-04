import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Text('Game Over'),
        ),
      ),
    );
  }
}
