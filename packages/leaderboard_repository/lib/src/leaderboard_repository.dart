import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

/// {@template leaderboard_exception}
/// Base exception for leaderboard repository failures.
/// {@endtemplate}
abstract class LeaderboardException implements Exception {
  /// {@macro leaderboard_exception}
  const LeaderboardException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The Stacktrace associated with the [error].
  final StackTrace stackTrace;
}

/// {@template leaderboard_deserialization_exception}
/// Exception thrown when leaderboard data cannot be deserialized in the
/// expected way.
/// {@endtemplate}
class LeaderboardDeserializationException extends LeaderboardException {
  /// {@macro leaderboard_deserialization_exception}
  const LeaderboardDeserializationException(
    Object error,
    StackTrace stackTrace,
  ) : super(
          error,
          stackTrace,
        );
}

/// {@template fetch_top_10_leaderboard_exception}
/// Exception thrown when failure occurs while fetching top 10 leaderboard.
/// {@endtemplate}
class FetchTop10LeaderboardException extends LeaderboardException {
  /// {@macro fetch_top_10_leaderboard_exception}
  const FetchTop10LeaderboardException(
    Object error,
    StackTrace stackTrace,
  ) : super(
          error,
          stackTrace,
        );
}

/// {@template add_leaderboard_entry_exception}
/// Exception thrown when failure occurs while adding entry to leaderboard.
/// {@endtemplate}
class AddLeaderboardEntryException extends LeaderboardException {
  /// {@macro add_leaderboard_entry_exception}
  const AddLeaderboardEntryException(
    Object error,
    StackTrace stackTrace,
  ) : super(
          error,
          stackTrace,
        );
}

/// {@template fetch_player_ranking_exception}
/// Exception thrown when failure occurs while fetching player ranking.
/// {@endtemplate}
class FetchPlayerRankingException extends LeaderboardException {
  /// {@macro fetch_player_ranking_exception}
  const FetchPlayerRankingException(
    Object error,
    StackTrace stackTrace,
  ) : super(
          error,
          stackTrace,
        );
}

/// {@template leaderboard_repository}
/// Repository to access leaderboard data in Firebase Cloud Firestore.
/// {@endtemplate}
class LeaderboardRepository {
  /// {@macro leaderboard_repository}
  const LeaderboardRepository(
    FirebaseFirestore firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  /// Acquires top 10 [LeaderboardEntryData]s.
  Future<List<LeaderboardEntryData>> fetchTop10Leaderboard() async {
    final leaderboardEntries = <LeaderboardEntryData>[];
    late List<QueryDocumentSnapshot> documents;

    try {
      final querySnapshot = await _firebaseFirestore
          .collection('leaderboard')
          .orderBy('score', descending: true)
          .limit(10)
          .get();
      documents = querySnapshot.docs;
    } on Exception catch (error, stackTrace) {
      throw FetchTop10LeaderboardException(error, stackTrace);
    }

    for (final document in documents) {
      final data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        try {
          leaderboardEntries.add(LeaderboardEntryData.fromJson(data));
        } catch (error, stackTrace) {
          throw LeaderboardDeserializationException(error, stackTrace);
        }
      }
    }

    return leaderboardEntries;
  }

  /// Adds player's score entry to the leaderboard and gets their
  /// [LeaderboardRanking].
  Future<LeaderboardRanking> addLeaderboardEntry(
    LeaderboardEntryData entry,
  ) async {
    late DocumentReference entryReference;
    try {
      entryReference = await _firebaseFirestore
          .collection('leaderboard')
          .add(entry.toJson());
    } on Exception catch (error, stackTrace) {
      throw AddLeaderboardEntryException(error, stackTrace);
    }

    try {
      final querySnapshot = await _firebaseFirestore
          .collection('leaderboard')
          .orderBy('score', descending: true)
          .get();

      // TODO(allisonryan0002): see if we can find a more performant solution.
      final documents = querySnapshot.docs;
      final ranking = documents.indexWhere(
            (document) => document.id == entryReference.id,
          ) +
          1;

      if (ranking > 0) {
        return LeaderboardRanking(ranking: ranking, outOf: documents.length);
      } else {
        throw FetchPlayerRankingException(
          'Player score could not be found and ranking cannot be provided.',
          StackTrace.current,
        );
      }
    } on Exception catch (error, stackTrace) {
      throw FetchPlayerRankingException(error, stackTrace);
    }
  }
}
