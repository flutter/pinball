// ignore_for_file: prefer_const_constructors, subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class _MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class _MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class _MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class _MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class _MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class _MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  group('LeaderboardRepository', () {
    late FirebaseFirestore firestore;

    setUp(() {
      firestore = _MockFirebaseFirestore();
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
        collectionReference = _MockCollectionReference();
        query = _MockQuery();
        querySnapshot = _MockQuerySnapshot();
        queryDocumentSnapshots = top10Scores.map((score) {
          final queryDocumentSnapshot = _MockQueryDocumentSnapshot();
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
        final queryDocumentSnapshot = _MockQueryDocumentSnapshot();
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

      setUp(() {
        leaderboardRepository = LeaderboardRepository(firestore);
        collectionReference = _MockCollectionReference();
        documentReference = _MockDocumentReference();
        query = _MockQuery();
        querySnapshot = _MockQuerySnapshot();
        queryDocumentSnapshots = leaderboardScores.map((score) {
          final queryDocumentSnapshot = _MockQueryDocumentSnapshot();
          when(queryDocumentSnapshot.data).thenReturn(<String, dynamic>{
            'character': 'dash',
            'playerInitials': 'AAA',
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
          'throws FetchLeaderboardException '
          'when querying the leaderboard fails', () {
        when(() => firestore.collection('leaderboard')).thenThrow(Exception());
        expect(
          () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
          throwsA(isA<FetchLeaderboardException>()),
        );
      });

      test(
          'saves the new score if the existing leaderboard '
          'has less than 10 scores', () async {
        await leaderboardRepository.addLeaderboardEntry(leaderboardEntry);
        verify(
          () => collectionReference.add(leaderboardEntry.toJson()),
        ).called(1);
      });

      test(
          'throws AddLeaderboardEntryException '
          'when adding a new entry fails', () async {
        when(() => collectionReference.add(leaderboardEntry.toJson()))
            .thenThrow(Exception('oops'));
        expect(
          () => leaderboardRepository.addLeaderboardEntry(leaderboardEntry),
          throwsA(isA<AddLeaderboardEntryException>()),
        );
      });

      test(
          'does nothing if there are more than 10 scores in the leaderboard '
          'and the new score is smaller than the top 10', () async {
        final leaderboardScores = [
          10000,
          9500,
          9000,
          8500,
          8000,
          7500,
          7000,
          6500,
          6000,
          5500,
          5000
        ];
        final queryDocumentSnapshots = leaderboardScores.map((score) {
          final queryDocumentSnapshot = _MockQueryDocumentSnapshot();
          when(queryDocumentSnapshot.data).thenReturn(<String, dynamic>{
            'character': 'dash',
            'playerInitials': 'AAA',
            'score': score
          });
          when(() => queryDocumentSnapshot.id).thenReturn('id$score');
          return queryDocumentSnapshot;
        }).toList();
        when(() => querySnapshot.docs).thenReturn(queryDocumentSnapshots);

        await leaderboardRepository.addLeaderboardEntry(leaderboardEntry);
        verifyNever(
          () => collectionReference.add(leaderboardEntry.toJson()),
        );
      });

      test(
          'throws DeleteLeaderboardException '
          'when deleting scores outside the top 10 fails', () async {
        final deleteQuery = _MockQuery();
        final deleteQuerySnapshot = _MockQuerySnapshot();
        final newScore = LeaderboardEntryData(
          playerInitials: 'ABC',
          score: 15000,
          character: CharacterType.android,
        );
        final leaderboardScores = [
          10000,
          9500,
          9000,
          8500,
          8000,
          7500,
          7000,
          6500,
          6000,
          5500,
          5000,
        ];
        final deleteDocumentSnapshots = [5500, 5000].map((score) {
          final queryDocumentSnapshot = _MockQueryDocumentSnapshot();
          when(queryDocumentSnapshot.data).thenReturn(<String, dynamic>{
            'character': 'dash',
            'playerInitials': 'AAA',
            'score': score
          });
          when(() => queryDocumentSnapshot.id).thenReturn('id$score');
          when(() => queryDocumentSnapshot.reference)
              .thenReturn(documentReference);
          return queryDocumentSnapshot;
        }).toList();
        when(deleteQuery.get).thenAnswer((_) async => deleteQuerySnapshot);
        when(() => deleteQuerySnapshot.docs)
            .thenReturn(deleteDocumentSnapshots);
        final queryDocumentSnapshots = leaderboardScores.map((score) {
          final queryDocumentSnapshot = _MockQueryDocumentSnapshot();
          when(queryDocumentSnapshot.data).thenReturn(<String, dynamic>{
            'character': 'dash',
            'playerInitials': 'AAA',
            'score': score
          });
          when(() => queryDocumentSnapshot.id).thenReturn('id$score');
          when(() => queryDocumentSnapshot.reference)
              .thenReturn(documentReference);
          return queryDocumentSnapshot;
        }).toList();
        when(
          () => collectionReference.where('score', isLessThanOrEqualTo: 5500),
        ).thenAnswer((_) => deleteQuery);
        when(() => documentReference.delete()).thenThrow(Exception('oops'));
        when(() => querySnapshot.docs).thenReturn(queryDocumentSnapshots);
        expect(
          () => leaderboardRepository.addLeaderboardEntry(newScore),
          throwsA(isA<DeleteLeaderboardException>()),
        );
      });

      test(
          'saves the new score when there are more than 10 scores in the '
          'leaderboard and the new score is higher than the lowest top 10, and '
          'deletes the scores that are not in the top 10 anymore', () async {
        final deleteQuery = _MockQuery();
        final deleteQuerySnapshot = _MockQuerySnapshot();
        final newScore = LeaderboardEntryData(
          playerInitials: 'ABC',
          score: 15000,
          character: CharacterType.android,
        );
        final leaderboardScores = [
          10000,
          9500,
          9000,
          8500,
          8000,
          7500,
          7000,
          6500,
          6000,
          5500,
          5000,
        ];
        final deleteDocumentSnapshots = [5500, 5000].map((score) {
          final queryDocumentSnapshot = _MockQueryDocumentSnapshot();
          when(queryDocumentSnapshot.data).thenReturn(<String, dynamic>{
            'character': 'dash',
            'playerInitials': 'AAA',
            'score': score
          });
          when(() => queryDocumentSnapshot.id).thenReturn('id$score');
          when(() => queryDocumentSnapshot.reference)
              .thenReturn(documentReference);
          return queryDocumentSnapshot;
        }).toList();
        when(deleteQuery.get).thenAnswer((_) async => deleteQuerySnapshot);
        when(() => deleteQuerySnapshot.docs)
            .thenReturn(deleteDocumentSnapshots);
        final queryDocumentSnapshots = leaderboardScores.map((score) {
          final queryDocumentSnapshot = _MockQueryDocumentSnapshot();
          when(queryDocumentSnapshot.data).thenReturn(<String, dynamic>{
            'character': 'dash',
            'playerInitials': 'AAA',
            'score': score
          });
          when(() => queryDocumentSnapshot.id).thenReturn('id$score');
          when(() => queryDocumentSnapshot.reference)
              .thenReturn(documentReference);
          return queryDocumentSnapshot;
        }).toList();
        when(
          () => collectionReference.where('score', isLessThanOrEqualTo: 5500),
        ).thenAnswer((_) => deleteQuery);
        when(() => documentReference.delete())
            .thenAnswer((_) async => Future.value());
        when(() => querySnapshot.docs).thenReturn(queryDocumentSnapshots);
        await leaderboardRepository.addLeaderboardEntry(newScore);
        verify(() => collectionReference.add(newScore.toJson())).called(1);
        verify(() => documentReference.delete()).called(2);
      });
    });

    group('areInitialsAllowed', () {
      late LeaderboardRepository leaderboardRepository;
      late CollectionReference<Map<String, dynamic>> collectionReference;
      late DocumentReference<Map<String, dynamic>> documentReference;
      late DocumentSnapshot<Map<String, dynamic>> documentSnapshot;

      setUp(() async {
        collectionReference = _MockCollectionReference();
        documentReference = _MockDocumentReference();
        documentSnapshot = _MockDocumentSnapshot();
        leaderboardRepository = LeaderboardRepository(firestore);

        when(() => firestore.collection('prohibitedInitials'))
            .thenReturn(collectionReference);
        when(() => collectionReference.doc('list'))
            .thenReturn(documentReference);
        when(() => documentReference.get())
            .thenAnswer((_) async => documentSnapshot);
        when<dynamic>(() => documentSnapshot.get('prohibitedInitials'))
            .thenReturn(['BAD']);
      });

      test('returns true if initials are three letters and allowed', () async {
        final isUsernameAllowedResponse =
            await leaderboardRepository.areInitialsAllowed(
          initials: 'ABC',
        );
        expect(
          isUsernameAllowedResponse,
          isTrue,
        );
      });

      test(
        'returns false if initials are shorter than 3 characters',
        () async {
          final areInitialsAllowedResponse =
              await leaderboardRepository.areInitialsAllowed(initials: 'AB');
          expect(areInitialsAllowedResponse, isFalse);
        },
      );

      test(
        'returns false if initials are longer than 3 characters',
        () async {
          final areInitialsAllowedResponse =
              await leaderboardRepository.areInitialsAllowed(initials: 'ABCD');
          expect(areInitialsAllowedResponse, isFalse);
        },
      );

      test(
        'returns false if initials contain a lowercase letter',
        () async {
          final areInitialsAllowedResponse =
              await leaderboardRepository.areInitialsAllowed(initials: 'AbC');
          expect(areInitialsAllowedResponse, isFalse);
        },
      );

      test(
        'returns false if initials contain a special character',
        () async {
          final areInitialsAllowedResponse =
              await leaderboardRepository.areInitialsAllowed(initials: 'A@C');
          expect(areInitialsAllowedResponse, isFalse);
        },
      );

      test('returns false if initials are forbidden', () async {
        final areInitialsAllowedResponse =
            await leaderboardRepository.areInitialsAllowed(initials: 'BAD');
        expect(areInitialsAllowedResponse, isFalse);
      });

      test(
        'throws FetchProhibitedInitialsException when Exception occurs '
        'when trying to retrieve information from firestore',
        () async {
          when(() => firestore.collection('prohibitedInitials'))
              .thenThrow(Exception('oops'));
          expect(
            () => leaderboardRepository.areInitialsAllowed(initials: 'ABC'),
            throwsA(isA<FetchProhibitedInitialsException>()),
          );
        },
      );
    });
  });
}
