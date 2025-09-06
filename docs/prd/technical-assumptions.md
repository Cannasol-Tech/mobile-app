# Technical Assumptions

## Repository Structure: Monorepo

Single repository containing the Flutter application codebase with platform-specific configurations in dedicated directories. This approach aligns with your Project Brief's preference for shared Flutter codebase while maintaining organized separation of iOS, Android, and web platform configurations.

## Service Architecture

**Firebase-Centered Microservices Architecture:** The system utilizes Firebase Cloud Functions as microservices for alarm processing, data aggregation, and notification delivery. Firebase Realtime Database serves as the primary data layer for live synchronization, with Firebase Authentication handling user management. This serverless approach provides automatic scaling while maintaining the sub-second latency requirements for industrial monitoring.

**Key architectural decisions:**

- Firebase Realtime Database for live device parameter synchronization
- Firebase Cloud Functions for business logic (alarm processing, notification routing)
- Firebase Cloud Messaging for push notifications across all platforms
- Firebase Storage for historical data retention and file management
- RESTful API design for future third-party system integrations

## Testing Requirements

**Comprehensive Testing Pyramid:** Given the industrial reliability requirements (99.5% uptime, <0.1% crash rate), the application requires full testing coverage including unit tests, integration tests, and end-to-end testing. Your Project Brief specifically mentions implementing comprehensive testing using the Mocktail framework to ensure industrial-grade reliability.

**Testing strategy:**

- Unit tests for all business logic and data processing functions
- Integration tests for Firebase service interactions and data synchronization
- End-to-end tests for critical user workflows (alarm response, device monitoring)
- Load testing for multi-device concurrent monitoring scenarios
- Platform-specific testing across iOS, Android, and web environments

## Additional Technical Assumptions and Requests

**Development Framework:**

- Flutter 3.29+ with Provider state management pattern for cross-platform consistency
- Dart language for unified codebase across all platforms
- Platform-specific native integrations where required for push notifications and device access

**Infrastructure and Hosting:**

- Google Cloud Platform with Firebase hosting for global CDN distribution
- Automatic scaling capabilities to support 500+ concurrent device connections
- Multi-region deployment for reliability and performance optimization

**Security and Compliance:**

- End-to-end encryption for all data transmission using TLS 1.3
- Role-based access control for device registration and parameter modification
- Audit logging for all user actions and system events
- Data residency compliance for industrial client requirements

**Performance Constraints:**

- Application launch time under 2 seconds on target mobile devices
- Real-time data refresh rates with sub-second latency requirements
- Offline capability for 15-minute connectivity interruptions
- Support for concurrent monitoring of up to 10 devices per user account

**Integration Requirements:**

- Webhook support for external system notifications
- RESTful API endpoints for future SCADA and MES system integration
- Support for industrial communication protocols as defined by hardware specifications
