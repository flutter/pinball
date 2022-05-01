// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/app/app.dart';
import 'package:pinball/bootstrap.dart';
import 'package:pinball_audio/pinball_audio.dart';

void main() {
  bootstrap((firestore, firebaseAuth) async {
    final leaderboardRepository = LeaderboardRepository(firestore);
    final authenticationRepository = AuthenticationRepository(firebaseAuth);
    final pinballAudio = PinballAudio();
    unawaited(
      Firebase.initializeApp().then(
        (_) => authenticationRepository.authenticateAnonymously(),
      ),
    );
    return App(
      authenticationRepository: authenticationRepository,
      leaderboardRepository: leaderboardRepository,
      pinballAudio: pinballAudio,
    );
  });
}
