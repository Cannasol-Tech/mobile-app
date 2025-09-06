# Coding Standards

## Critical Fullstack Rules

- **Type Sharing:** Always define types in shared/ directory and import consistently across Flutter and Functions
- **API Calls:** Never make direct HTTP calls in Flutter - use the service layer with proper error handling
- **Environment Variables:** Access only through config objects, never process.env or const String directly
- **Error Handling:** All API routes must use the standard error handler middleware with consistent error format
- **State Updates:** Never mutate state directly in Flutter - use Riverpod providers with immutable state objects
- **Database Access:** Always use repository pattern - no direct Firestore calls in business logic
- **Authentication:** Verify user permissions at both client and server level - never trust client-side auth alone
- **Real-time Updates:** Use Firestore listeners for real-time data, not polling or manual refresh

## Naming Conventions

| Element | Frontend | Backend | Example |
|---------|----------|---------|---------|
| Components | PascalCase | - | `EnvironmentCard.dart` |
| Providers | camelCase with Provider suffix | - | `environmentProvider` |
| API Routes | - | kebab-case | `/api/environments/:id` |
| Database Collections | - | snake_case | `sensor_readings` |
| Functions | camelCase | camelCase | `processEnvironmentUpdate` |
| Constants | SCREAMING_SNAKE_CASE | SCREAMING_SNAKE_CASE | `MAX_RETRY_ATTEMPTS` |
