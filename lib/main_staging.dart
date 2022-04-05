// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/app/app.dart';
import 'package:pinball/bootstrap.dart';
import 'package:pinball_audio/pinball_audio.dart';

void main() {
  bootstrap((firestore) async {
    final leaderboardRepository = LeaderboardRepository(firestore);
    final pinballAudio = PinballAudio();
    return App(
      leaderboardRepository: leaderboardRepository,
      pinballAudio: pinballAudio,
    );
  });
}
