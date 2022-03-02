import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';

class PinballGamePage extends StatelessWidget {
  const PinballGamePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) {
        return BlocProvider(
          create: (_) => GameBloc(),
          child: const PinballGamePage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const PinballGameView();
  }
}
