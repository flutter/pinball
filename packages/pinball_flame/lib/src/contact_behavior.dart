import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template contact_behavior}
/// Appends a new [ContactCallbacks] to the parent.
///
/// This is a convenience class for adding a [ContactCallbacks] to the parent.
/// In constract with just assigning a [ContactCallbacks] to a userData, this
/// class respects the previous userData.
///
/// It does so by grouping the userDatas in a [_UserDatas], and resetting the
/// parent's userData accordingly.
// TODO(alestiago): Make use of generics to infer the type of the contact.
// https://github.com/VGVentures/pinball/pull/234#discussion_r859182267
// {@endtemplate}
class ContactBehavior<T extends BodyComponent> extends Component
    with ContactCallbacks, ParentIsA<T> {
  /// {@macro contact_behavior}

  final _fixtureUserDatas = <Object>{};

  /// Specifies which fixtures should be considered for contact.
  ///
  /// Fixtures are identifiable by their userData.
  ///
  /// If no specific fixtures are specified, the [ContactCallbacks] is applied
  /// to the entire body, hence all fixtures are considered.
  void applyTo(Iterable<Object> userDatas) =>
      _fixtureUserDatas.addAll(userDatas);

  @override
  Future<void> onLoad() async {
    if (_fixtureUserDatas.isNotEmpty) {
      for (final fixture in _targetedFixtures) {
        fixture.userData = _UserDatas.fromFixture(fixture)..add(this);
      }
    } else {
      parent.body.userData = _UserDatas.fromBody(parent.body)..add(this);
    }
  }

  Iterable<Fixture> get _targetedFixtures =>
      parent.body.fixtures.where((fixture) {
        if (_fixtureUserDatas.contains(fixture.userData)) return true;

        final userData = fixture.userData;
        if (userData is _UserDatas) {
          return _fixtureUserDatas.contains(userData.value);
        }

        return false;
      });
}

class _UserDatas with ContactCallbacks {
  _UserDatas._(Object? userData) : _userDatas = [userData];

  factory _UserDatas._fromUserData(Object? userData) {
    if (userData is _UserDatas) return userData;
    return _UserDatas._(userData);
  }

  factory _UserDatas.fromFixture(Fixture fixture) =>
      _UserDatas._fromUserData(fixture.userData);

  factory _UserDatas.fromBody(Body body) =>
      _UserDatas._fromUserData(body.userData);

  final List<Object?> _userDatas;

  Iterable<ContactCallbacks> get _contactCallbacks =>
      _userDatas.whereType<ContactCallbacks>();

  Object? get value => _userDatas.first;

  void add(Object? userData) => _userDatas.add(userData);

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
