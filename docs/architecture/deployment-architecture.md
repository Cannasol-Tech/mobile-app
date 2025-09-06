# Deployment Architecture

## Deployment Strategy

**Frontend Deployment:**
- **Platform:** Firebase Hosting (web) + App Stores (mobile)
- **Build Command:** `flutter build web` / `flutter build apk` / `flutter build ios`
- **Output Directory:** `build/web/` (for web deployment)
- **CDN/Edge:** Firebase Hosting global CDN

**Backend Deployment:**
- **Platform:** Firebase Functions + Google Cloud Run
- **Build Command:** `npm run build` (Functions) / `docker build` (Cloud Run)
- **Deployment Method:** Firebase CLI + gcloud CLI

## CI/CD Pipeline

```yaml
# .github/workflows/ci.yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test-flutter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test

  test-functions:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      - run: cd functions && npm ci
      - run: cd functions && npm run lint
      - run: cd functions && npm test

  test-python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: cd cloud_run && pip install -r requirements.txt
      - run: cd cloud_run && python -m pytest

  deploy-staging:
    needs: [test-flutter, test-functions, test-python]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - uses: actions/setup-node@v4
      - run: flutter build web
      - run: cd functions && npm ci && npm run build
      - run: firebase deploy --project staging --token ${{ secrets.FIREBASE_TOKEN }}

  deploy-production:
    needs: [test-flutter, test-functions, test-python]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - uses: actions/setup-node@v4
      - run: flutter build web
      - run: cd functions && npm ci && npm run build
      - run: firebase deploy --project production --token ${{ secrets.FIREBASE_TOKEN }}
```

## Environments

| Environment | Frontend URL | Backend URL | Purpose |
|-------------|--------------|-------------|---------|
| Development | http://localhost:3000 | http://localhost:5001 | Local development |
| Staging | https://staging.cannasol-tech.web.app | https://us-central1-cannasol-tech-staging.cloudfunctions.net | Pre-production testing |
| Production | https://app.cannasol-tech.com | https://us-central1-cannasol-tech.cloudfunctions.net | Live environment |
