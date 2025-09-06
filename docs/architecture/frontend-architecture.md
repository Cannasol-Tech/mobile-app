# Frontend Architecture

## Component Architecture

### Component Organization

```
lib/
├── main.dart                    # App entry point
├── app/                         # App-level configuration
│   ├── app.dart                # Main app widget
│   ├── router.dart             # App routing configuration
│   └── theme.dart              # Material Design 3 theme
├── core/                        # Core utilities and services
│   ├── constants/              # App constants
│   ├── errors/                 # Error handling
│   ├── utils/                  # Utility functions
│   └── extensions/             # Dart extensions
├── features/                    # Feature-based organization
│   ├── auth/                   # Authentication feature
│   │   ├── data/               # Data layer (repositories, models)
│   │   ├── domain/             # Business logic (entities, use cases)
│   │   └── presentation/       # UI layer (pages, widgets, providers)
│   ├── dashboard/              # Dashboard feature
│   ├── facilities/             # Facility management
│   ├── environments/           # Environment monitoring
│   ├── alerts/                 # Alert management
│   └── settings/               # User settings
├── shared/                      # Shared components and widgets
│   ├── widgets/                # Reusable UI components
│   ├── models/                 # Shared data models
│   └── services/               # Shared services
└── firebase_options.dart       # Firebase configuration
```

### Component Template

```typescript
// Example: Environment monitoring widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/environment_provider.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_widget.dart';

class EnvironmentMonitoringWidget extends ConsumerWidget {
  final String environmentId;

  const EnvironmentMonitoringWidget({
    Key? key,
    required this.environmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environmentAsync = ref.watch(environmentProvider(environmentId));

    return environmentAsync.when(
      data: (environment) => _buildEnvironmentData(context, environment),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorWidget(
        error: error,
        onRetry: () => ref.refresh(environmentProvider(environmentId)),
      ),
    );
  }

  Widget _buildEnvironmentData(BuildContext context, Environment environment) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              environment.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildConditionTiles(environment.currentConditions),
            const SizedBox(height: 16),
            _buildStatusIndicator(environment.status),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionTiles(EnvironmentConditions conditions) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildConditionTile('Temperature', '${conditions.temperature}°C'),
        _buildConditionTile('Humidity', '${conditions.humidity}%'),
        _buildConditionTile('CO2', '${conditions.co2} ppm'),
        _buildConditionTile('Light', '${conditions.lightLevel} lux'),
      ],
    );
  }

  Widget _buildConditionTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(EnvironmentStatus status) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case EnvironmentStatus.optimal:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case EnvironmentStatus.warning:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case EnvironmentStatus.critical:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case EnvironmentStatus.offline:
        statusColor = Colors.grey;
        statusIcon = Icons.offline_bolt;
        break;
    }

    return Row(
      children: [
        Icon(statusIcon, color: statusColor),
        const SizedBox(width: 8),
        Text(
          status.name.toUpperCase(),
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
```

## State Management Architecture

### State Structure

```typescript
// Riverpod providers structure
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Auth State
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

// Facilities State
final facilitiesProvider = StreamProvider<List<Facility>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('facilities')
      .where('users', arrayContains: user.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Facility.fromFirestore(doc))
          .toList());
});

// Environment State
final environmentProvider = StreamProvider.family<Environment, String>((ref, environmentId) {
  return FirebaseFirestore.instance
      .collection('environments')
      .doc(environmentId)
      .snapshots()
      .map((doc) => Environment.fromFirestore(doc));
});

// Alerts State
final alertsProvider = StreamProvider<List<Alert>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('alerts')
      .where('status', isEqualTo: 'active')
      .orderBy('triggeredAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Alert.fromFirestore(doc))
          .toList());
});

// Settings State
final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier() : super(UserPreferences.defaultPreferences());

  void updateTheme(ThemeMode theme) {
    state = state.copyWith(theme: theme);
    _savePreferences();
  }

  void updateUnits(Units units) {
    state = state.copyWith(units: units);
    _savePreferences();
  }

  void updateNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
    _savePreferences();
  }

  void _savePreferences() {
    // Save to SharedPreferences or Firestore
  }
}
```

### State Management Patterns

- **Provider Pattern:** Use Riverpod providers for dependency injection and state management
- **Stream Providers:** Leverage Firebase real-time streams for live data updates
- **Family Providers:** Use provider families for parameterized state (e.g., specific environment data)
- **State Notifiers:** Use StateNotifier for complex state mutations with immutable state objects
- **Auto-dispose:** Automatically dispose providers when no longer needed to prevent memory leaks

## Routing Architecture

### Route Organization

```
/                           # Dashboard (authenticated users)
├── /login                  # Login page
├── /facilities             # Facilities list
│   └── /:facilityId        # Facility detail
│       └── /environments   # Environments list
│           └── /:envId     # Environment detail
├── /alerts                 # Alerts list
│   └── /:alertId          # Alert detail
├── /devices               # Devices management
│   └── /:deviceId         # Device detail
└── /settings              # User settings
    ├── /profile           # User profile
    ├── /notifications     # Notification preferences
    └── /about             # About page
```

### Protected Route Pattern

```typescript
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.location == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/facilities',
            builder: (context, state) => const FacilitiesPage(),
            routes: [
              GoRoute(
                path: '/:facilityId',
                builder: (context, state) => FacilityDetailPage(
                  facilityId: state.params['facilityId']!,
                ),
                routes: [
                  GoRoute(
                    path: '/environments',
                    builder: (context, state) => EnvironmentsPage(
                      facilityId: state.params['facilityId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: '/:envId',
                        builder: (context, state) => EnvironmentDetailPage(
                          facilityId: state.params['facilityId']!,
                          environmentId: state.params['envId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/alerts',
            builder: (context, state) => const AlertsPage(),
            routes: [
              GoRoute(
                path: '/:alertId',
                builder: (context, state) => AlertDetailPage(
                  alertId: state.params['alertId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
              GoRoute(
                path: '/notifications',
                builder: (context, state) => const NotificationSettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
```

## Frontend Services Layer

### API Client Setup

```typescript
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiClient {
  late final Dio _dio;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://us-central1-cannasol-tech.cloudfunctions.net/api',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(AuthInterceptor(_auth));
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

class AuthInterceptor extends Interceptor {
  final FirebaseAuth _auth;

  AuthInterceptor(this._auth);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final user = _auth.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

### Service Example

```typescript
import '../models/facility.dart';
import '../core/api_client.dart';

class FacilityService {
  final ApiClient _apiClient;

  FacilityService(this._apiClient);

  Future<List<Facility>> getFacilities() async {
    try {
      final response = await _apiClient.get('/facilities');
      final List<dynamic> data = response.data;
      return data.map((json) => Facility.fromJson(json)).toList();
    } catch (e) {
      throw FacilityServiceException('Failed to fetch facilities: $e');
    }
  }

  Future<Facility> createFacility(CreateFacilityRequest request) async {
    try {
      final response = await _apiClient.post('/facilities', data: request.toJson());
      return Facility.fromJson(response.data);
    } catch (e) {
      throw FacilityServiceException('Failed to create facility: $e');
    }
  }

  Future<void> updateFacility(String facilityId, UpdateFacilityRequest request) async {
    try {
      await _apiClient.put('/facilities/$facilityId', data: request.toJson());
    } catch (e) {
      throw FacilityServiceException('Failed to update facility: $e');
    }
  }
}

class FacilityServiceException implements Exception {
  final String message;
  FacilityServiceException(this.message);

  @override
  String toString() => 'FacilityServiceException: $message';
}

// Provider for dependency injection
final facilityServiceProvider = Provider<FacilityService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FacilityService(apiClient);
});
```
