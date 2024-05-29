import 'package:leaderboard_repository/leaderboard_repository.dart';

/// {@template leaderboard_repository}
/// Repository to access leaderboard data in Firebase Cloud Firestore.
/// {@endtemplate}
class LeaderboardRepository {
  /// {@macro leaderboard_repository}
  const LeaderboardRepository(
      //FirebaseFirestore firebaseFirestore,
      ); //: _firebaseFirestore = firebaseFirestore;

  //final FirebaseFirestore _firebaseFirestore;

  // static const _leaderboardLimit = 10;
  // static const _leaderboardCollectionName = 'leaderboard';
  // static const _scoreFieldName = 'score';

  /// Acquires top 10 [LeaderboardEntryData]s.
  Future<List<LeaderboardEntryData>> fetchTop10Leaderboard() async {
    // try {
    //   // final querySnapshot = await _firebaseFirestore
    //   //     .collection(_leaderboardCollectionName)
    //   //     .orderBy(_scoreFieldName, descending: true)
    //   //     .limit(_leaderboardLimit)
    //   //     .get();
    //   // final documents = querySnapshot.docs;
    //   // return documents.toLeaderboard();
    // } on LeaderboardDeserializationException {
    //   rethrow;
    // } on Exception catch (error, stackTrace) {
    //   throw FetchTop10LeaderboardException(error, stackTrace);
    // }
    return Future.value(List<LeaderboardEntryData>.empty());
  }

  /// Adds player's score entry to the leaderboard if it is within the top-10
  Future<void> addLeaderboardEntry(
    LeaderboardEntryData entry,
  ) async {
    final leaderboard = await _fetchLeaderboardSortedByScore();
    if (leaderboard.length < 10) {
      await _saveScore(entry);
    } else {
      final tenthPositionScore = leaderboard[9].score;
      if (entry.score > tenthPositionScore) {
        await _saveScore(entry);
      }
    }
  }

  Future<List<LeaderboardEntryData>> _fetchLeaderboardSortedByScore() async {
    // try {
    //   final querySnapshot = await _firebaseFirestore
    //       .collection(_leaderboardCollectionName)
    //       .orderBy(_scoreFieldName, descending: true)
    //       .get();
    //   final documents = querySnapshot.docs;
    //   return documents.toLeaderboard();
    // } on Exception catch (error, stackTrace) {
    //   throw FetchLeaderboardException(error, stackTrace);
    // }
    return Future.value(List<LeaderboardEntryData>.empty());
  }

  Future<void> _saveScore(LeaderboardEntryData entry) {
    // try {
    //   return _firebaseFirestore
    //       .collection(_leaderboardCollectionName)
    //       .add(entry.toJson());
    // } on Exception catch (error, stackTrace) {
    //   throw AddLeaderboardEntryException(error, stackTrace);
    // }
    return Future.value();
  }
}

// extension on List<QueryDocumentSnapshot> {
//   List<LeaderboardEntryData> toLeaderboard() {
//     final leaderboardEntries = <LeaderboardEntryData>[];
//     for (final document in this) {
//       final data = document.data() as Map<String, dynamic>?;
//       if (data != null) {
//         try {
//           leaderboardEntries.add(LeaderboardEntryData.fromJson(data));
//         } catch (error, stackTrace) {
//           throw LeaderboardDeserializationException(error, stackTrace);
//         }
//       }
//     }
//     return leaderboardEntries;
//   }
//}
