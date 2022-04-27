// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/components/flutter_forest/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

export 'cubit/flutter_forest_cubit.dart';

/// {@template flutter_forest}
/// Area positioned at the top right of the [Board] where the [Ball]
/// can bounce off [DashNestBumper]s.
/// {@endtemplate}
class FlutterForest extends Component {
  /// {@macro flutter_forest}
  FlutterForest()
      : bloc = FlutterForestCubit(),
        super(
          children: [
            Signpost(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(8.35, -58.3),
            DashNestBumper.main(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(18.55, -59.35),
            DashNestBumper.a(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(8.95, -51.95),
            DashNestBumper.b(
              children: [
                ScoringBehavior(points: 20),
              ],
            )..initialPosition = Vector2(23.3, -46.75),
            DashAnimatronic()..position = Vector2(20, -66),
            FlutterForestBonusBehavior(),
          ],
        );

  /// {@macro flutter_forest}
  @visibleForTesting
  FlutterForest.test({
    required this.bloc,
  });

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
  final FlutterForestCubit bloc;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }
}
