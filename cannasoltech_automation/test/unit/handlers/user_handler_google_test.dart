// Unit tests for UserHandler.signInWithGoogle with dependency injection
// Covers success, cancellation, exception with fallback, and missing token cases.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cannasoltech_automation/handlers/user_handler.dart';
import 'package:cannasoltech_automation/api/firebase_api.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseDatabase mockDb;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleAccount;
  late MockGoogleSignInAuthentication mockGoogleAuth;
  late MockFirebaseApi mockFirebaseApi;
  late MockUser mockUser;

  setUpAll(() {
    registerMockFallbacks();
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockDb = MockFirebaseDatabase();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleAccount = createMockGoogleAccount(
      email: AuthTestData.googleEmail,
      displayName: AuthTestData.googleDisplayName,
    );
    mockGoogleAuth = createMockGoogleAuth(
      accessToken: AuthTestData.googleAccessToken,
      idToken: AuthTestData.googleIdToken,
    );
    mockFirebaseApi = MockFirebaseApi();
    mockUser = createMockUser(email: AuthTestData.validEmail);

    // Database stubs with safe defaults
    final mockRef = MockDatabaseReference();
    final emptySnapshot = MockDataSnapshot();
    final emptyEvent = MockDatabaseEvent();

    // Snapshot should look empty but iterable
    when(() => emptySnapshot.children).thenReturn(<DataSnapshot>[]);
    when(() => emptySnapshot.exists).thenReturn(false);
    when(() => emptyEvent.snapshot).thenReturn(emptySnapshot);

    when(() => mockDb.ref(any())).thenReturn(mockRef);
    when(() => mockRef.child(any())).thenReturn(mockRef);
    when(() => mockRef.update(any())).thenAnswer((_) async {});
    when(() => mockRef.get()).thenAnswer((_) async => emptySnapshot);
    when(() => mockRef.onValue).thenAnswer((_) => Stream.value(emptyEvent));

    // Firebase API stubs
    when(() => mockFirebaseApi.getToken())
        .thenAnswer((_) async => AuthTestData.fcmToken);
    when(() => mockFirebaseApi.setTokenRefreshCallback(any()))
        .thenAnswer((_) async {});
  });

  test('signInWithGoogle returns true on successful non-web sign in', () async {
    // Arrange
    when(() => mockGoogleSignIn.signIn())
        .thenAnswer((_) async => mockGoogleAccount);
    when(() => mockGoogleAccount.authentication)
        .thenAnswer((_) async => mockGoogleAuth);

    when(() => mockAuth.signInWithCredential(any()))
        .thenAnswer((_) async => MockUserCredential());
    // After sign-in, FirebaseAuth.currentUser should be non-null
    when(() => mockAuth.currentUser).thenReturn(mockUser);

    final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDb);

    // Act
    final result = await handler.signInWithGoogle(
      googleSignIn: mockGoogleSignIn,
      firebaseApi: mockFirebaseApi,
    );

    // Assert
    expect(result, isTrue);
    verify(() => mockGoogleSignIn.signIn()).called(1);
    verify(() => mockAuth.signInWithCredential(any())).called(1);
    verify(() => mockFirebaseApi.getToken()).called(1);
  });

  test('signInWithGoogle returns false when user cancels', () async {
    // Arrange
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

    final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDb);

    // Act
    final result = await handler.signInWithGoogle(
      googleSignIn: mockGoogleSignIn,
      firebaseApi: mockFirebaseApi,
    );

    // Assert
    expect(result, isFalse);
    verify(() => mockGoogleSignIn.signIn()).called(1);
    verifyNever(() => mockAuth.signInWithCredential(any()));
  });

  test('signInWithGoogle falls back to success if auth.currentUser exists after exception', () async {
    // Arrange
    when(() => mockGoogleSignIn.signIn()).thenThrow(Exception('GS failure'));

    // Simulate authenticated user present afterward
    when(() => mockAuth.currentUser).thenReturn(mockUser);

    final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDb);

    // Act
    final result = await handler.signInWithGoogle(
      googleSignIn: mockGoogleSignIn,
      firebaseApi: mockFirebaseApi,
    );

    // Assert
    expect(result, isTrue);
    verify(() => mockFirebaseApi.getToken()).called(1);
  });

  test('signInWithGoogle returns false when tokens missing and no auth user', () async {
    // Arrange: signIn returns account, but auth token is missing
    final account = createMockGoogleAccount();
    final authNoToken = createMockGoogleAuth(accessToken: '', idToken: '');

    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => account);
    when(() => account.authentication).thenAnswer((_) async => authNoToken);

    when(() => mockAuth.currentUser).thenReturn(null);
    // If signInWithCredential is called with invalid token, throw to emulate failure
    when(() => mockAuth.signInWithCredential(any())).thenThrow(Exception('invalid token'));

    final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDb);

    // Act
    final result = await handler.signInWithGoogle(
      googleSignIn: mockGoogleSignIn,
      firebaseApi: mockFirebaseApi,
    );

    // Assert
    expect(result, isFalse);
  });
}
