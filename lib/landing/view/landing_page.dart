import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () =>
              Navigator.of(context).push<void>(PinballGamePage.route()),
          child: const Text('Start'),
        ),
      ),
    );
  }
}
