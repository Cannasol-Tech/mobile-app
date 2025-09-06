# Development Workflow

## Local Development Setup

### Prerequisites

```bash
# Install Flutter SDK
flutter --version  # Ensure Flutter 3.16+

# Install Python
python --version  # Ensure Python 3.11+
pip --version

# Install Firebase CLI
pip install firebase-functions

# Install Google Cloud SDK
gcloud --version

# Authenticate with Firebase and Google Cloud
firebase login
gcloud auth login
gcloud auth application-default login
```

### Initial Setup

```bash
# Clone repository
git clone https://github.com/Cannasol-Tech/mobile-app.git
cd mobile-app

# Setup Flutter dependencies
cd cannasoltech_automation
flutter pub get

# Setup Python Firebase Functions dependencies
cd functions
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
cd ..

# Setup hardware simulation service dependencies
cd ../hardware_simulation
pip install -r requirements.txt
cd ..

# Copy environment files (create if needed)
# cp .env.example .env
# cp cannasoltech_automation/functions/.env.example cannasoltech_automation/functions/.env

# Initialize Firebase project (if not already configured)
cd cannasoltech_automation
firebase use --add  # Select your Firebase project
```

### Development Commands

```bash
# Start Flutter app
cd cannasoltech_automation
flutter run

# Start Firebase Functions locally (in separate terminal)
cd cannasoltech_automation/functions
source venv/bin/activate  # On Windows: venv\Scripts\activate
functions-framework --target=api --source=main.py --port=8080

# Start hardware simulation service (in separate terminal)
cd hardware_simulation
python app.py

# Run tests
cd cannasoltech_automation
flutter test                    # Flutter tests
cd functions && python -m pytest  # Python functions tests (when tests are added)
cd ../hardware_simulation && python -m pytest  # Hardware simulation tests
```

## Environment Configuration

### Required Environment Variables

```bash
# Flutter (.env)
FIREBASE_PROJECT_ID=cannasol-tech
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id
FIREBASE_MESSAGING_SENDER_ID=your-sender-id

# Firebase Functions (.env)
TWILIO_ACCOUNT_SID=your-twilio-sid
TWILIO_AUTH_TOKEN=your-twilio-token
SENDGRID_API_KEY=your-sendgrid-key
OPENWEATHER_API_KEY=your-weather-key

# Cloud Run Services (.env)
GOOGLE_CLOUD_PROJECT=cannasol-tech
FIRESTORE_EMULATOR_HOST=localhost:8080  # For local development
PUBSUB_EMULATOR_HOST=localhost:8085     # For local development
```
