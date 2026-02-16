# ⚡ Quick Start Guide

Get your Bullet Journal app running in under 10 minutes!

## Prerequisites Checklist

Before starting, make sure you have:

- [ ] **PostgreSQL** installed and running
- [ ] **Node.js 18+** installed
- [ ] **Redis** installed and running
- [ ] **Flutter SDK** installed
- [ ] **Xcode** installed (for iOS development)
- [ ] **VS Code** (recommended)

*Don't have these? See [SETUP.md](SETUP.md) for installation instructions.*

---

## 5-Step Setup

### 1️⃣ Create Database

```bash
psql postgres
```

```sql
CREATE DATABASE bullet_journal;
CREATE USER bullet_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE bullet_journal TO bullet_user;
\q
```

### 2️⃣ Configure Backend

```bash
cd backend
cp .env.example .env
```

Edit `.env` - update these lines:
```env
DB_PASSWORD=your_password
JWT_SECRET=$(openssl rand -base64 32)  # Generate and paste
```

### 3️⃣ Install & Migrate

```bash
# Install backend dependencies
npm install

# Run database migration
psql -U bullet_user -d bullet_journal -f ../database/migrations/1708000000000_initial-schema.sql

# Start backend
npm run dev
```

You should see: `🚀 Server running on http://localhost:3000`

### 4️⃣ Setup Mobile App

Open a **new terminal**:

```bash
cd mobile
flutter pub get
cd ios && pod install && cd ..
```

### 5️⃣ Launch the App

```bash
flutter run
```

Or in **VS Code**: Press `F5` → Select "Full Stack: Backend + Mobile"

---

## ✅ First Steps

1. **Register** - Create your account
2. **Create a task** - Tap the `+` button
3. **Complete it** - Tap task → "Mark as Done"
4. **Reschedule** - Try rescheduling a task 3 times (see the warning!)

---

## 🎯 Key Commands

### Backend
```bash
cd backend
npm run dev      # Start development server
npm run build    # Build for production
npm start        # Run production build
```

### Mobile
```bash
cd mobile
flutter run           # Run on simulator/device
flutter run -d all    # Run on all devices
flutter clean         # Clean build files
```

### Database
```bash
# Connect to database
psql -U bullet_user -d bullet_journal

# View tables
\dt

# View data
SELECT * FROM users;
SELECT * FROM tasks;
```

---

## 🚨 Troubleshooting

**Backend won't start?**
```bash
# Check if PostgreSQL is running
brew services list

# Check if port 3000 is free
lsof -i :3000
```

**Mobile won't build?**
```bash
# Clean and retry
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

**Database connection error?**
- Check username/password in `.env`
- Verify PostgreSQL is running
- Test connection: `psql -U bullet_user -d bullet_journal`

---

## 📖 Next Steps

- Read [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for feature overview
- Check [SETUP.md](SETUP.md) for detailed documentation
- Review API endpoints in PROJECT_SUMMARY.md
- Start building Phase 2 features!

---

## 🎉 You're All Set!

Your digital bullet journal is running. Happy logging! 📓✨
