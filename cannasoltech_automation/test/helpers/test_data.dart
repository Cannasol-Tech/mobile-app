// Test Data Constants
//
// This file contains all test data constants used throughout the test suite.
// Centralizing test data ensures consistency and makes tests more maintainable.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow TESTING-STANDARDS.md guidelines

// =============================================================================
// Authentication Test Data
// =============================================================================

class AuthTestData {
  // Valid credentials
  static const String validEmail = 'test@cannasoltech.com';
  static const String validPassword = 'SecurePassword123!';
  static const String validDisplayName = 'Test User';
  static const String validUserId = 'test-user-id-123';
  
  // Invalid credentials
  static const String invalidEmail = 'invalid-email';
  static const String invalidPassword = '123';
  static const String emptyEmail = '';
  static const String emptyPassword = '';
  
  // Firebase Auth error codes
  static const String userNotFoundCode = 'user-not-found';
  static const String wrongPasswordCode = 'wrong-password';
  static const String invalidEmailCode = 'invalid-email';
  static const String userDisabledCode = 'user-disabled';
  static const String tooManyRequestsCode = 'too-many-requests';
  
  // Google Sign-In data
  static const String googleAccessToken = 'mock_google_access_token';
  static const String googleIdToken = 'mock_google_id_token';
  static const String googleEmail = 'testuser@gmail.com';
  static const String googleDisplayName = 'Google Test User';
  
  // FCM Token
  static const String fcmToken = 'mock_fcm_token_123456789';
}

// =============================================================================
// Firebase Configuration Test Data
// =============================================================================

class FirebaseTestData {
  // Project configuration
  static const String projectId = 'cannasoltech';
  static const String projectNumber = '681058687134';
  static const String databaseUrl = 'https://cannasoltech-default-rtdb.firebaseio.com';
  static const String storageBucket = 'cannasoltech.firebasestorage.app';
  
  // Client IDs
  static const String webClientId = '681058687134-7u8b2tooh7rcojkkdb6tkrh0a1smh7n3.apps.googleusercontent.com';
  static const String androidClientId = '681058687134-6f8atkd860tsnukq32m2pk3qm3nija23.apps.googleusercontent.com';
  static const String iosClientId = '681058687134-s5l7lnk515adhmjkt9amndke3rnb2ern.apps.googleusercontent.com';
  
  // API Keys
  static const String webApiKey = 'AIzaSyADeAO7Yc9u5RhMM-GvekY9QCyKVHAXfxc';
  static const String androidApiKey = 'AIzaSyAgoZEfLt5vObq2UQO1RM7x_yENvobWzRo';
  static const String iosApiKey = 'AIzaSyCOpCrx581Twp6VGsseMtQbYCurCJt8Lnk';
}

// =============================================================================
// UI Test Data
// =============================================================================

class UITestData {
  // App strings
  static const String appTitle = 'Cannasol Technologies Automation';
  static const String signInTitle = 'Sign In';
  static const String signUpTitle = 'Sign Up';
  static const String homeTitle = 'Home';
  static const String configurationTitle = 'Configuration';
  
  // Button labels
  static const String signInButton = 'Sign In';
  static const String signUpButton = 'Sign Up';
  static const String googleSignInButton = 'Continue with Google';
  static const String forgotPasswordButton = 'Forgot Password?';
  
  // Form field labels
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String confirmPasswordLabel = 'Confirm Password';
  
  // Error messages
  static const String invalidEmailError = 'Please enter a valid email';
  static const String emptyPasswordError = 'Password cannot be empty';
  static const String userNotFoundError = 'User not found!';
  static const String wrongPasswordError = 'Incorrect password';
  static const String invalidLoginError = 'Invalid login!';
  static const String googleSignInAbortedError = 'Google sign-in aborted';
  static const String googleSignInFailedError = 'Google sign-in failed';
  
  // Success messages
  static const String signInSuccessMessage = 'Sign in successful';
  static const String signUpSuccessMessage = 'Account created successfully';
}

// =============================================================================
// System Data Test Data
// =============================================================================

class SystemTestData {
  // Device information
  static const String deviceId = 'test-device-123';
  static const String deviceName = 'Test Device';
  static const String deviceModel = 'Test Model';
  static const String devicePlatform = 'iOS';
  static const String deviceVersion = '17.0';
  
  // App configuration
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  static const bool debugMode = true;
  
  // Network configuration
  static const String baseUrl = 'https://api.cannasoltech.com';
  static const String apiVersion = 'v1';
  static const int timeoutSeconds = 30;
}

// =============================================================================
// Mock Response Data
// =============================================================================

class MockResponseData {
  // HTTP responses
  static const Map<String, dynamic> successResponse = {
    'status': 'success',
    'message': 'Operation completed successfully',
    'data': {},
  };
  
  static const Map<String, dynamic> errorResponse = {
    'status': 'error',
    'message': 'Operation failed',
    'error': 'MOCK_ERROR',
  };
  
  // User data
  static const Map<String, dynamic> userData = {
    'uid': AuthTestData.validUserId,
    'email': AuthTestData.validEmail,
    'displayName': AuthTestData.validDisplayName,
    'emailVerified': true,
    'createdAt': '2024-01-01T00:00:00Z',
    'lastSignIn': '2024-01-01T12:00:00Z',
  };
  
  // Firebase Database responses
  static const Map<String, dynamic> databaseSnapshot = {
    'users': {
      AuthTestData.validUserId: userData,
    },
    'settings': {
      'theme': 'light',
      'notifications': true,
    },
  };
}

// =============================================================================
// Test Utilities
// =============================================================================

class TestDataUtils {
  /// Creates a list of test emails for bulk testing
  static List<String> generateTestEmails(int count) {
    return List.generate(
      count,
      (index) => 'test$index@cannasoltech.com',
    );
  }
  
  /// Creates test user data with optional overrides
  static Map<String, dynamic> createUserData({
    String? uid,
    String? email,
    String? displayName,
    bool? emailVerified,
  }) {
    return {
      'uid': uid ?? AuthTestData.validUserId,
      'email': email ?? AuthTestData.validEmail,
      'displayName': displayName ?? AuthTestData.validDisplayName,
      'emailVerified': emailVerified ?? true,
      'createdAt': DateTime.now().toIso8601String(),
      'lastSignIn': DateTime.now().toIso8601String(),
    };
  }
  
  /// Creates test error data
  static Map<String, dynamic> createErrorData({
    String? code,
    String? message,
  }) {
    return {
      'code': code ?? 'MOCK_ERROR',
      'message': message ?? 'Mock error for testing',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  /// Validates email format for testing
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// Validates password strength for testing
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}

// =============================================================================
// Test Scenarios
// =============================================================================

class TestScenarios {
  /// Common test scenarios for authentication
  static const List<Map<String, dynamic>> authScenarios = [
    {
      'name': 'Valid credentials',
      'email': AuthTestData.validEmail,
      'password': AuthTestData.validPassword,
      'shouldSucceed': true,
    },
    {
      'name': 'Invalid email format',
      'email': AuthTestData.invalidEmail,
      'password': AuthTestData.validPassword,
      'shouldSucceed': false,
    },
    {
      'name': 'Empty email',
      'email': AuthTestData.emptyEmail,
      'password': AuthTestData.validPassword,
      'shouldSucceed': false,
    },
    {
      'name': 'Empty password',
      'email': AuthTestData.validEmail,
      'password': AuthTestData.emptyPassword,
      'shouldSucceed': false,
    },
    {
      'name': 'Short password',
      'email': AuthTestData.validEmail,
      'password': AuthTestData.invalidPassword,
      'shouldSucceed': false,
    },
  ];
}
