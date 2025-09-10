# Testing Strategy

## Testing Pyramid

```
        E2E Tests (10%)
       /              \
    Integration Tests (20%)
   /                      \
Unit Tests (70%)    Widget Tests (70%)
```

## Test Organization

### Frontend Tests

```
test/
├── unit/                       # Unit tests
│   ├── models/                # Model tests
│   ├── services/              # Service tests
│   ├── utils/                 # Utility tests
│   └── providers/             # Provider tests
├── widget/                     # Widget tests
│   ├── components/            # Component tests
│   ├── pages/                 # Page tests
│   └── features/              # Feature widget tests
└── integration/                # Integration tests
    ├── auth_flow_test.dart    # Authentication flow
    ├── monitoring_flow_test.dart # Monitoring workflow
    └── alert_flow_test.dart   # Alert management
```

### Backend Tests

```
functions/test/
├── unit/                       # Unit tests
│   ├── services/              # Service tests
│   ├── utils/                 # Utility tests
│   └── models/                # Model tests
├── integration/                # Integration tests
│   ├── api/                   # API endpoint tests
│   ├── triggers/              # Firestore trigger tests
│   └── auth/                  # Authentication tests
└── fixtures/                   # Test data
    ├── users.json
    ├── facilities.json
    └── environments.json
```

### E2E Tests

```
test/e2e/
├── auth/                       # Authentication flows
├── monitoring/                 # Device monitoring flows
├── alerts/                     # Alert management flows
└── admin/                      # Admin functionality flows
```
