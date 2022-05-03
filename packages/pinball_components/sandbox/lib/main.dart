// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/stories/stories.dart';

void main() {
  final dashbook = Dashbook(theme: ThemeData.dark());

  addBallStories(dashbook);
  addLayerStories(dashbook);
  addEffectsStories(dashbook);
  addFlutterForestStories(dashbook);
  addSparkyScorchStories(dashbook);
  addAndroidAcresStories(dashbook);
  addDinoDesertStories(dashbook);
  addBottomGroupStories(dashbook);
  addPlungerStories(dashbook);
  addBoundariesStories(dashbook);
  addGoogleWordStories(dashbook);
  addLaunchRampStories(dashbook);
  addScoreStories(dashbook);
  addBackboardStories(dashbook);
  addMultiballStories(dashbook);
  addMultipliersStories(dashbook);

  runApp(dashbook);
}
