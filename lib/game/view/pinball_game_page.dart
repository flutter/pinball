import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

class PinballGamePage extends StatelessWidget {
  const PinballGamePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const PinballGamePage());
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: PinballGame());
  }
}
