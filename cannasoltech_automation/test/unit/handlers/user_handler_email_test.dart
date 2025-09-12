// Unit tests for UserHandler.signInWithEmailAndPassword
// Covers success, FirebaseAuthException failure, and generic exception.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cannasoltech_automation/handlers/user_handler.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseDatabase mockDb;

  setUpAll(() {
    registerMockFallbacks();
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockDb = MockFirebaseDatabase();

    final ref = MockDatabaseReference();
    final snap = MockDataSnapshot();
    final event = MockDatabaseEvent();
    when(() => mockDb.ref(any())).thenReturn(ref);
    when(() => ref.child(any())).thenReturn(ref);
    when(() => ref.update(any())).thenAnswer((_) async {});
    when(() => ref.get()).thenAnswer((_) async => snap);
    when(() => ref.onValue).thenAnswer((_) => Stream.value(event));
    when(() => event.snapshot).thenReturn(snap);
  });

  test('returns true when FirebaseAuth signInWithEmailAndPassword succeeds', () async {
    when(() => mockAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => MockUserCredential());

    final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDb);

    final result = await handler.signInWithEmailAndPassword('a@b.com', 'password');

    expect(result, isTrue);
    verify(() => mockAuth.signInWithEmailAndPassword(
      email: 'a@b.com', password: 'password')).called(1);
  });

  test('returns false when FirebaseAuth throws FirebaseAuthException', () async {
    when(() => mockAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

    final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDb);

    final result = await handler.signInWithEmailAndPassword('missing@user.com', 'password');

    expect(result, isFalse);
  });

  test('returns false when FirebaseAuth throws generic Exception', () async {
    when(() => mockAuth.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenThrow(Exception('network'));

    final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDb);

    final result = await handler.signInWithEmailAndPassword('any@user.com', 'password');

    expect(result, isFalse);
  });
}
