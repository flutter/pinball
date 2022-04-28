import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/components/multiballs/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template multiballs_component}
/// A [SpriteGroupComponent] for the multiball over the board.
/// {@endtemplate}
class Multiballs extends Component {
  /// {@macro multiballs_component}
  Multiballs()
      : super(
          children: [
            Multiball.a(),
            Multiball.b(),
            Multiball.c(),
            Multiball.d(),
            MultiballsBehavior(),
          ],
        );

  /// Creates a [Multiballs] without any children.
  ///
  /// This can be used for testing [Multiballs]'s behaviors in isolation.
  @visibleForTesting
  Multiballs.test();
}
