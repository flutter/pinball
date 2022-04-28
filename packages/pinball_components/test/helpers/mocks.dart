import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class MockFilter extends Mock implements Filter {}

class MockFixture extends Mock implements Fixture {}

class MockBody extends Mock implements Body {}

class MockBall extends Mock implements Ball {}

class MockGame extends Mock implements Forge2DGame {}

class MockContact extends Mock implements Contact {}

class MockComponent extends Mock implements Component {}

class MockAndroidBumperCubit extends Mock implements AndroidBumperCubit {}

class MockGoogleLetterCubit extends Mock implements GoogleLetterCubit {}

class MockSparkyBumperCubit extends Mock implements SparkyBumperCubit {}

class MockDashNestBumperCubit extends Mock implements DashNestBumperCubit {}

class MockMultiplierCubit extends Mock implements MultiplierCubit {}
