// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template google_word}
/// Loads all [GoogleLetter]s to compose a [GoogleWord].
/// {@endtemplate}
class GoogleWord extends Component
    with HasGameRef<PinballGame>, Controls<_GoogleWordController> {
  /// {@macro google_word}
  GoogleWord({
    required Vector2 position,
  }) : super(
          children: [
            _GoogleLetter(0)
              ..initialPosition = position + Vector2(-12.92, 1.82),
            _GoogleLetter(1)
              ..initialPosition = position + Vector2(-8.33, -0.65),
            _GoogleLetter(2)
              ..initialPosition = position + Vector2(-2.88, -1.75),
            _GoogleLetter(3)..initialPosition = position + Vector2(2.88, -1.75),
            _GoogleLetter(4)..initialPosition = position + Vector2(8.33, -0.65),
            _GoogleLetter(5)..initialPosition = position + Vector2(12.92, 1.82),
          ],
        ) {
    controller = _GoogleWordController(this);
  }
}

/// Activates a [GoogleLetter] when it contacts with a [Ball].
class _GoogleLetter extends GoogleLetter with ContactCallbacks2 {
  _GoogleLetter(int index) : super(index);

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    final parent = this.parent;
    if (parent is GoogleWord) parent.controller.activate(this);
  }
}

class _GoogleWordController extends ComponentController<GoogleWord>
    with HasGameRef<PinballGame> {
  _GoogleWordController(GoogleWord googleWord) : super(googleWord);

  final _activatedLetters = <GoogleLetter>{};

  void activate(GoogleLetter googleLetter) {
    if (!_activatedLetters.add(googleLetter)) return;

    googleLetter.activate();

    final activatedBonus = _activatedLetters.length == 6;
    if (activatedBonus) {
      gameRef.audio.googleBonus();
      gameRef.read<GameBloc>().add(const BonusActivated(GameBonus.googleWord));
      component.children.whereType<GoogleLetter>().forEach(
            (letter) => letter.deactivate(),
          );
      _activatedLetters.clear();
    }
  }
}
