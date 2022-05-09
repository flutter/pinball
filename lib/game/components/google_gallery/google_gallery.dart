import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/google_gallery/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template google_gallery}
/// Middle section of the board containing the [GoogleWord] and the
/// [GoogleRollover]s.
/// {@endtemplate}
class GoogleGallery extends Component with ZIndex {
  /// {@macro google_gallery}
  GoogleGallery()
      : super(
          children: [
            FlameBlocProvider<GoogleWordCubit, GoogleWordState>(
              create: GoogleWordCubit.new,
              children: [
                GoogleRollover(
                  side: BoardSide.right,
                  children: [
                    ScoringContactBehavior(points: Points.fiveThousand),
                  ],
                ),
                GoogleRollover(
                  side: BoardSide.left,
                  children: [
                    ScoringContactBehavior(points: Points.fiveThousand),
                  ],
                ),
                GoogleWord(position: Vector2(-4.45, 1.8)),
                GoogleWordBonusBehavior(),
              ],
            ),
          ],
        ) {
    zIndex = ZIndexes.decal;
  }

  /// Creates a [GoogleGallery] without any children.
  ///
  /// This can be used for testing [GoogleGallery]'s behaviors in isolation.
  @visibleForTesting
  GoogleGallery.test();
}
