// ignore_for_file: prefer_const_constructors, subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  group('LeaderboardRepository', () {
    late FirebaseFirestore firestore;

    setUp(() {
      firestore = MockFirebaseFirestore();
    });

    test('can be instantiated', () {
      expect(LeaderboardRepository(firestore), isNotNull);
    });

    group('fetchTop10Leaderboard', () {
      late LeaderboardRepository leaderboardRepository;
      late CollectionReference<Map<String, dynamic>> collectionReference;
      late Query<Map<String, dynamic>> query;
      late QuerySnapshot<Map<String, dynamic>> querySnapshot;
      late List<QueryDocumentSnapshot<Map<String, dynamic>>>
          queryDocumentSnapshots;

      final top10Scores = [
        2500,
        2200,
        2200,
        2000,
        1800,
        1400,
        1300,
        1000,
        600,
        300,
        100,
      ];

      final top10Leaderboard = top10Scores
          .map(
            (score) => LeaderboardEntryData(
              playerInitials: 'user$score',
              score: score,
              character: CharacterType.dash,
            ),
          )
          .toList();

      setUp(() {
        leaderboardRepository = LeaderboardRepository(firestore);
        collectionReference = MockCollectionReference();
        query = MockQuery();
        querySnapshot = MockQuerySnapshot();
        queryDocumentSnapshots = top10Scores.map((score) {
          final queryDocumentSnapshot = MockQueryDocumentSnapshot();
          when(queryDocumentSnapshot.data).thenReturn(<String, dynamic>{
            'character': 'dash',
            'playerInitials': 'user$score',
            'score': score
          });
          return queryDocumentSnapshot;
        }).toList();

        when(() => firestore.collection('leaderboard'))
            .thenAnswer((_) => collectionReference);
        when(() => collectionReference.orderBy('score', descending: true))
            .thenAnswer((_) => query);
        when(() => query.limit(10)).thenAnswer((_) => query);
        when(query.get).thenAnswer((_) async => querySnapshot);
        when(() => querySnapshot.docs).thenReturn(queryDocumentSnapshots);
      });

      test(
          'returns top 10 entries when '
          'retrieving information from firestore succeeds', () async {
        final top10LeaderboardResults =
            await leaderboardRepository.fetchTop10Leaderboard();

        expect(top10LeaderboardResults, equals(top10Leaderboard));
      });

      test(
          'throws FetchTop10LeaderboardException when Exception occurs '
          'when trying to retrieve information from firestore', () async {
        when(() => firestore.collection('leaderboard')).thenThrow(Exception());

        expect(
          () => leaderboardRepository.fetchTop10Leaderboard(),
          throwsA(isA<FetchTop10LeaderboardException>()),
        );
      });

      test(
          'throws LeaderboardDeserializationException when Exception occurs '
          'during deserialization', () async {
        final top10LeaderboardDataMalformed = <String, dynamic>{
          'playerInitials': 'ABC',
          'score': 1500,
        };
        final queryDocumentSnapshot = MockQueryDocumentSnapshot();
        when(() => querySnapshot.docs).thenReturn([queryDocumentSnapshot]);
        when(queryDocumentSnapshot.data)
            .thenReturn(top10LeaderboardDataMalformed);

        expect(
          () => leaderboardRepository.fetchTop10Leaderboard(),
          throwsA(isA<LeaderboardDeserializationException>()),
        );
      });
    });

    group('addLeaderboardEntry', () {
      late LeaderboardRepository leaderboardRepository;
      late CollectionReference<Map<String, dynamic>> collectionReference;
      late DocumentReference<Map<String, dynamic>> documentReference;
      late Query<Map<String, dynamic>> query;
      late QuerySnapshot<Map<String, dynamic>> querySnapshot;
      late List<QueryDocumentSnapshot<Map<String, dynamic>>>
          queryDocumentSnapshots;

      const entryScore = 1500;
      final leaderboardScores = [
        2500,
        2200,
        entryScore,
        1000,
      ];
      final leaderboardEntry = LeaderboardEntryData(
        playerInitials: 'ABC',
        score: entryScore,
        character: CharacterType.dash,
      );
      const entryDocumentId = 'id$entryScore';
      final ranking = LeaderboardRanking(ranking: 3, outOf: 4);

      setUp(() {
        leaderboardRepository = LeaderboardRepository(firestore);
        collectionReference = MockCollectionReference();
        documentReference = MockDocumentReference();
        query = MockQuery();
        querySnapshot = MockQuerySnapshot();
        queryDocumentSnapshots = leaderboardScores.map((score) {
          final queryDocumentSnapshot = MockQueryDocumentSnapshot();
          when(queryDocumentSnapshot.data).thenReturn(<String, dynamic>{
            'character': 'dash',
            'username': 'user$score',
            'score': score
          });
          when(() => queryDocumentSnapshot.id).thenReturn('id$score');
          return queryDocumentSnapshot;
        }).toList();

        when(() => firestore.collection('leaderboard'))
            .thenAnswer((_) => collectionReference);
        when(() => collectionReference.add(any()))
            .thenAnswer((_) async => documentReference);
        when(() => collectionReference.orderBy('score', descending: true))
            .thenAnswer((_) => query);
        when(query.get).thenAnswer((_) async => querySnapshot);
        when(() => querySnapshot.docs).thenReturn(queryDocumentSnapshots);
        when(() => documentReference.id).thenReturn(entryDocumentId);
      });

      test(
          'adds leaderboard entry and returns player ranking when '
          'firestore operations succeed', () async {
        final rankingResult =
            await leaderboardRepository.addLeaderboardEntry(leaderboardEntry);

        expect(rankingResult, equals(ranking));
      });

      test(
          'throws AddLeaderboardEntryException when Exception occurs '
          'when trying to add entry to firestore', () async {
        when(() => firestore.collection('leaderboard')).thenThrow(Exception());

        expect(
          () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
          throwsA(isA<AddLeaderboardEntryException>()),
        );
      });

      test(
          'throws FetchPlayerRankingException when Exception occurs '
          'when trying to retrieve information from firestore', () async {
        when(() => collectionReference.orderBy('score', descending: true))
            .thenThrow(Exception());

        expect(
          () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
          throwsA(isA<FetchPlayerRankingException>()),
        );
      });

      test(
          'throws FetchPlayerRankingException when score cannot be found '
          'in firestore leaderboard data', () async {
        when(() => documentReference.id).thenReturn('nonexistentDocumentId');

        expect(
          () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
          throwsA(isA<FetchPlayerRankingException>()),
        );
      });
    });
  });
}
