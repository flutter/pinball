// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('PlungerJointingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerJointingBehavior(compressionDistance: 0),
        isA<PlungerJointingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final parent = Plunger.test();
      final behavior = PlungerJointingBehavior(compressionDistance: 0);
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.children, contains(behavior));
    });

    flameTester.test('can be loaded', (game) async {
      final parent = Plunger.test();
      final behavior = PlungerJointingBehavior(compressionDistance: 0);
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.children, contains(behavior));
    });

    flameTester.test('creates a joint', (game) async {
      final behavior = PlungerJointingBehavior(compressionDistance: 0);
      final parent = Plunger.test();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.body.joints, isNotEmpty);
    });
  });

//   group('PlungerAnchorPrismaticJointDef', () {
//     const compressionDistance = 10.0;
//     late Plunger plunger;

//     setUp(() {
//       plunger = Plunger(
//         compressionDistance: compressionDistance,
//       );
//       anchor = PlungerAnchor(plunger: plunger);
//     });

//     group('initializes with', () {
//       flameTester.test(
//         'plunger body as bodyA',
//         (game) async {
//           await game.ensureAdd(plunger);
//           await game.ensureAdd(anchor);

//           final jointDef = PlungerAnchorPrismaticJointDef(
//             plunger: plunger,
//             anchor: anchor,
//           );

//           expect(jointDef.bodyA, equals(plunger.body));
//         },
//       );

//       flameTester.test(
//         'anchor body as bodyB',
//         (game) async {
//           await game.ensureAdd(plunger);
//           await game.ensureAdd(anchor);

//           final jointDef = PlungerAnchorPrismaticJointDef(
//             plunger: plunger,
//             anchor: anchor,
//           );
//           game.world.createJoint(PrismaticJoint(jointDef));

//           expect(jointDef.bodyB, equals(anchor.body));
//         },
//       );

//       flameTester.test(
//         'limits enabled',
//         (game) async {
//           await game.ensureAdd(plunger);
//           await game.ensureAdd(anchor);

//           final jointDef = PlungerAnchorPrismaticJointDef(
//             plunger: plunger,
//             anchor: anchor,
//           );
//           game.world.createJoint(PrismaticJoint(jointDef));

//           expect(jointDef.enableLimit, isTrue);
//         },
//       );

//       flameTester.test(
//         'lower translation limit as negative infinity',
//         (game) async {
//           await game.ensureAdd(plunger);
//           await game.ensureAdd(anchor);

//           final jointDef = PlungerAnchorPrismaticJointDef(
//             plunger: plunger,
//             anchor: anchor,
//           );
//           game.world.createJoint(PrismaticJoint(jointDef));

//           expect(jointDef.lowerTranslation, equals(double.negativeInfinity));
//         },
//       );

//       flameTester.test(
//         'connected body collision enabled',
//         (game) async {
//           await game.ensureAdd(plunger);
//           await game.ensureAdd(anchor);

//           final jointDef = PlungerAnchorPrismaticJointDef(
//             plunger: plunger,
//             anchor: anchor,
//           );
//           game.world.createJoint(PrismaticJoint(jointDef));

//           expect(jointDef.collideConnected, isTrue);
//         },
//       );
//     });

//     flameTester.testGameWidget(
//       'plunger cannot go below anchor',
//       setUp: (game, tester) async {
//         await game.ensureAdd(plunger);
//         await game.ensureAdd(anchor);

//         // Giving anchor a shape for the plunger to collide with.
//         anchor.body.createFixtureFromShape(PolygonShape()..setAsBoxXY(2, 1));

//         final jointDef = PlungerAnchorPrismaticJointDef(
//           plunger: plunger,
//           anchor: anchor,
//         );
//         game.world.createJoint(PrismaticJoint(jointDef));

//         await tester.pump(const Duration(seconds: 1));
//       },
//       verify: (game, tester) async {
//         expect(plunger.body.position.y < anchor.body.position.y, isTrue);
//       },
//     );

//     flameTester.testGameWidget(
//       'plunger cannot excessively exceed starting position',
//       setUp: (game, tester) async {
//         await game.ensureAdd(plunger);
//         await game.ensureAdd(anchor);

//         final jointDef = PlungerAnchorPrismaticJointDef(
//           plunger: plunger,
//           anchor: anchor,
//         );
//         game.world.createJoint(PrismaticJoint(jointDef));

//         plunger.body.setTransform(Vector2(0, -1), 0);

//         await tester.pump(const Duration(seconds: 1));
//       },
//       verify: (game, tester) async {
//         expect(plunger.body.position.y < 1, isTrue);
//       },
//     );
//   });
// }
}
