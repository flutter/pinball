// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/app/app.dart';
import 'package:pinball/bootstrap.dart';

void main() {
  bootstrap((firestore) async {
    final leaderboardRepository = LeaderboardRepository(firestore);
    return App(leaderboardRepository: leaderboardRepository);
  });
}
