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
