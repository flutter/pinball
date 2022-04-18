import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mocktail/mocktail.dart';

class MockForge2DGame extends Mock implements Forge2DGame {}

class MockContactCallback extends Mock
    implements ContactCallback<dynamic, dynamic> {}

class MockComponent extends Mock implements Component {}
