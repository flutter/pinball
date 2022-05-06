import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Appends a new [ContactCallbacks] to the parent.
///
/// This is a convenience class for adding a [ContactCallbacks] to the parent.
/// In contrast with just assigning a [ContactCallbacks] to a userData, this
/// class respects the previous userData.
///
/// It does so by grouping the userData in a [_UserData], and resetting the
/// parent's userData accordingly.
// TODO(alestiago): Make use of generics to infer the type of the contact.
// https://github.com/VGVentures/pinball/pull/234#discussion_r859182267
class ContactBehavior<T extends BodyComponent> extends Component
    with ContactCallbacks, ParentIsA<T> {
  final _fixturesUserData = <Object>{};

  /// Specifies which fixtures should be considered for contact.
  ///
  /// Fixtures are identifiable by their userData.
  ///
  /// If no fixtures are specified, the [ContactCallbacks] is applied to the
  /// entire body, hence all fixtures are considered.
  void applyTo(Iterable<Object> userData) => _fixturesUserData.addAll(userData);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (_fixturesUserData.isNotEmpty) {
      for (final fixture in _targetedFixtures) {
        fixture.userData = _UserData.fromFixture(fixture)..add(this);
      }
    } else {
      parent.body.userData = _UserData.fromBody(parent.body)..add(this);
    }
  }

  Iterable<Fixture> get _targetedFixtures =>
      parent.body.fixtures.where((fixture) {
        if (_fixturesUserData.contains(fixture.userData)) return true;

        final userData = fixture.userData;
        if (userData is _UserData) {
          return _fixturesUserData.contains(userData.value);
        }

        return false;
      });
}

class _UserData with ContactCallbacks {
  _UserData._(Object? userData) : _userData = [userData];

  factory _UserData._fromUserData(Object? userData) {
    if (userData is _UserData) return userData;
    return _UserData._(userData);
  }

  factory _UserData.fromFixture(Fixture fixture) =>
      _UserData._fromUserData(fixture.userData);

  factory _UserData.fromBody(Body body) =>
      _UserData._fromUserData(body.userData);

  final List<Object?> _userData;

  Iterable<ContactCallbacks> get _contactCallbacks =>
      _userData.whereType<ContactCallbacks>();

  Object? get value => _userData.first;

  void add(Object? userData) => _userData.add(userData);

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    for (final callback in _contactCallbacks) {
      callback.beginContact(other, contact);
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    super.endContact(other, contact);
    for (final callback in _contactCallbacks) {
      callback.endContact(other, contact);
    }
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    super.preSolve(other, contact, oldManifold);
    for (final callback in _contactCallbacks) {
      callback.preSolve(other, contact, oldManifold);
    }
  }

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    super.postSolve(other, contact, impulse);
    for (final callback in _contactCallbacks) {
      callback.postSolve(other, contact, impulse);
    }
  }
}
