# Setup Instructions

Complete guide to get your Bullet Journal app running locally.

## Prerequisites

Install these tools before starting:

### 1. PostgreSQL
```bash
# macOS (using Homebrew)
brew install postgresql@14
brew services start postgresql@14

# Verify installation
psql --version
```

### 2. Node.js & npm
```bash
# macOS (using Homebrew)
brew install node@18

# Verify installation
node --version  # Should be 18.x or higher
npm --version
```

### 3. Redis
```bash
# macOS (using Homebrew)
brew install redis
brew services start redis

# Verify installation
redis-cli ping  # Should return "PONG"
```

### 4. Flutter
```bash
# Install Flutter SDK
# Download from: https://docs.flutter.dev/get-started/install/macos

# Add Flutter to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor

# Install Xcode (for iOS development)
# Download from Mac App Store
xcodebuild -version

# Accept Xcode license
sudo xcodebuild -license accept

# Install CocoaPods
sudo gem install cocoapods
```

---

## Backend Setup

### 1. Create Database

```bash
# Connect to PostgreSQL
psql postgres

# Create database and user
CREATE DATABASE bullet_journal;
CREATE USER bullet_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE bullet_journal TO bullet_user;
\q
```

### 2. Configure Environment

```bash
cd backend
cp .env.example .env
```

Edit `.env` file with your settings:
```env
NODE_ENV=development
PORT=3000

DB_HOST=localhost
DB_PORT=5432
DB_NAME=bullet_journal
DB_USER=bullet_user
DB_PASSWORD=your_secure_password

JWT_SECRET=run_this_command_openssl_rand_base64_32
JWT_EXPIRES_IN=7d

REDIS_HOST=localhost
REDIS_PORT=6379

CORS_ORIGIN=*
```

Generate a secure JWT secret:
```bash
openssl rand -base64 32
# Copy the output and paste it as JWT_SECRET in .env
```

### 3. Install Dependencies

```bash
npm install
```

### 4. Run Database Migrations

```bash
# Run migrations
psql -U bullet_user -d bullet_journal -f ../database/migrations/1708000000000_initial-schema.sql

# Verify tables were created
psql -U bullet_user -d bullet_journal -c "\dt"
```

### 5. Start Backend Server

```bash
npm run dev
```

You should see:
```
🚀 Server running on http://localhost:3000
📊 Health check: http://localhost:3000/health
```

Test the health endpoint:
```bash
curl http://localhost:3000/health
# Should return: {"status":"healthy","database":"connected"}
```

---

## Mobile Setup (iOS)

### 1. Navigate to Mobile Directory

```bash
cd ../mobile
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Configure iOS

```bash
cd ios
pod install
cd ..
```

### 4. Update API Endpoint (if needed)

If your backend is not on `localhost:3000`, edit:
`mobile/lib/services/api_client.dart`

Change:
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

### 5. Run on iOS Simulator

```bash
# List available simulators
flutter devices

# Run the app
flutter run

# Or specify a device
flutter run -d "iPhone 15 Pro"
```

---

## Troubleshooting

### Backend Issues

**Database connection failed:**
```bash
# Check if PostgreSQL is running
brew services list

# Restart PostgreSQL
brew services restart postgresql@14

# Test connection
psql -U bullet_user -d bullet_journal
```

**Port 3000 already in use:**
```bash
# Find process using port 3000
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or change PORT in .env file
```

**Redis connection failed:**
```bash
# Check if Redis is running
redis-cli ping

# Restart Redis
brew services restart redis
```

### Mobile Issues

**Flutter doctor shows issues:**
```bash
# Run flutter doctor and follow instructions
flutter doctor -v
```

**CocoaPods issues:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

**Build fails:**
```bash
# Clean build
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

**iOS Simulator not found:**
```bash
# Open Xcode and install simulators
open -a Simulator

# Or install from Xcode -> Preferences -> Components
```

---

## Testing the App

### 1. Register a New User

1. Launch the app (you'll see the login screen)
2. Tap "Don't have an account? Register"
3. Fill in:
   - Name: Your Name
   - Email: you@example.com
   - Password: password123
4. Tap "Register"

### 2. Create Your First Task

1. After login, you'll see the Daily Log (empty)
2. Tap the **+** button (bottom right)
3. Fill in:
   - Task Title: "Review project proposal"
   - Description: "Check timeline and budget"
   - Date: (defaults to today)
4. Tap "Create Task"

### 3. Manage Tasks

1. Tap on a task to see actions:
   - **Mark as Done**: Complete the task (✓)
   - **Reschedule**: Move to another date (>)
   - **Mark as Blocked**: Task is waiting (⊗)
   - **Delete**: Remove the task

### 4. Test Migration Limit

1. Create a task
2. Reschedule it 3 times
3. On the 3rd reschedule, you'll see a warning
4. The system prevents endless migration!

---

## Next Steps

### Phase 1 MVP is complete! ✅

You now have:
- ✅ User authentication (register/login)
- ✅ Daily log view
- ✅ Task creation with scheduled dates
- ✅ Task states (not done, done, blocked, rescheduled)
- ✅ Migration tracking (3-migration limit)
- ✅ Task management (update, delete)

### Coming in Future Phases:

**Phase 2:** Habits + Analytics
**Phase 3:** Recurring tasks
**Phase 4:** Team collaboration
**Phase 5:** All platforms (Android, macOS, Windows)

---

## Development Workflow

### Backend Development

```bash
cd backend

# Development mode (auto-reload)
npm run dev

# Build for production
npm run build

# Run production build
npm start
```

### Mobile Development

```bash
cd mobile

# Run in debug mode
flutter run

# Run with hot reload (default)
# Press 'r' to hot reload
# Press 'R' to hot restart

# Build for release
flutter build ios --release

# Run tests
flutter test
```

### Database Migrations

```bash
cd backend

# Create new migration
npm run migrate:create my_migration_name

# Run migrations
npm run migrate

# Rollback last migration
npm run migrate:down
```

---

## VS Code Setup

### Recommended Extensions

Install these VS Code extensions:

1. **Flutter** (Dart-Code.flutter)
2. **Dart** (Dart-Code.dart-code)
3. **ESLint** (dbaeumer.vscode-eslint)
4. **Prettier** (esbenp.prettier-vscode)
5. **PostgreSQL** (ckolkman.vscode-postgres)

### Launch Configuration

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter: Run",
      "type": "dart",
      "request": "launch",
      "program": "mobile/lib/main.dart"
    },
    {
      "name": "Backend: Debug",
      "type": "node",
      "request": "launch",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "cwd": "${workspaceFolder}/backend",
      "console": "integratedTerminal"
    }
  ]
}
```

### VS Code Tasks

Create `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Start Backend",
      "type": "shell",
      "command": "npm run dev",
      "options": {
        "cwd": "${workspaceFolder}/backend"
      },
      "isBackground": true,
      "problemMatcher": []
    },
    {
      "label": "Start Mobile",
      "type": "shell",
      "command": "flutter run",
      "options": {
        "cwd": "${workspaceFolder}/mobile"
      },
      "isBackground": true,
      "problemMatcher": []
    }
  ]
}
```

---

## Quick Start Script

I've created a setup script to automate the process:

```bash
# From project root
chmod +x setup.sh
./setup.sh
```

This will:
1. Check prerequisites
2. Set up the database
3. Install dependencies
4. Run migrations
5. Start the backend
6. Launch the mobile app

---

## Support

If you run into issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review logs:
   - Backend: Terminal running `npm run dev`
   - Mobile: Flutter debug console in VS Code
3. Verify all prerequisites are installed correctly

---

Happy coding! 📓✨
