import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class MockCanvas extends Mock implements Canvas {}

class MockFilter extends Mock implements Filter {}

class MockFixture extends Mock implements Fixture {}

class MockBody extends Mock implements Body {}

class MockBall extends Mock implements Ball {}

class MockGame extends Mock implements Forge2DGame {}

class MockSpaceshipEntrance extends Mock implements SpaceshipEntrance {}

class MockSpaceshipHole extends Mock implements SpaceshipHole {}

class MockContact extends Mock implements Contact {}

class MockContactCallback extends Mock
    implements ContactCallback<Object, Object> {}

class MockComponent extends Mock implements Component {}
