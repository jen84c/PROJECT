# Digital Bullet Journal

A cross-platform native app that brings analog bullet journaling into the digital space.

## Project Structure

```
bullet-journal/
├── backend/         # Node.js + Express + PostgreSQL API
├── mobile/          # Flutter app (iOS first, all platforms later)
├── database/        # Database migrations and seeds
└── README.md
```

## Quick Start

### Prerequisites

- **Node.js** 18+ and npm
- **PostgreSQL** 14+
- **Flutter** 3.24+
- **iOS development tools** (Xcode, CocoaPods)
- **Redis** (for background jobs)

### 1. Backend Setup

```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your database credentials
npm run migrate
npm run dev
```

Backend runs on `http://localhost:3000`

### 2. Mobile Setup

```bash
cd mobile
flutter pub get
flutter run
```

## Tech Stack

### Backend
- Node.js + Express + TypeScript
- PostgreSQL (database)
- Redis (caching + job queue)
- Socket.io (real-time sync)
- JWT (authentication)
- BullMQ (background jobs)

### Mobile
- Flutter 3.24+
- Riverpod (state management)
- Drift (local SQLite database)
- HTTP + WebSocket (API communication)

## Architecture

- **Offline-first:** App works fully offline, syncs when connected
- **Real-time sync:** Changes propagate instantly across devices
- **Conflict resolution:** Last-write-wins with timestamp tracking

## Development Phases

- **Phase 1 (Current):** MVP - Personal use, iOS only
- **Phase 2:** Habits + Analytics
- **Phase 3:** Recurring tasks
- **Phase 4:** Team collaboration
- **Phase 5:** All platforms
- **Phase 6:** Advanced features

## License

Private - All Rights Reserved
