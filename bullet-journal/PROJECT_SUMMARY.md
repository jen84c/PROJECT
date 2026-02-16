# Digital Bullet Journal - Project Summary

## 🎉 What We Built

A full-stack iOS-first bullet journaling app with cloud sync and self-hosted backend.

### ✅ Phase 1 MVP (Complete)

**Backend API (Node.js + TypeScript + PostgreSQL)**
- User authentication (register/login with JWT)
- RESTful API for tasks and projects
- Database schema with migrations
- Task migration tracking (3-migration limit)
- Task states: not_done, done, blocked, rescheduled
- Self-hosted on your own infrastructure

**iOS App (Flutter)**
- User registration and login
- Daily log view with date picker
- Task creation with rapid logging
- Task management (mark done, reschedule, block, delete)
- Migration tracking with warnings
- Offline-ready architecture (local + cloud sync)
- Beautiful, clean UI inspired by analog bullet journaling

## 📁 Project Structure

```
bullet-journal/
├── backend/                 # Node.js + Express API
│   ├── src/
│   │   ├── config/         # Database configuration
│   │   ├── controllers/    # Business logic
│   │   ├── middleware/     # Authentication, etc.
│   │   ├── routes/         # API routes
│   │   └── index.ts        # Server entry point
│   ├── package.json
│   ├── tsconfig.json
│   └── .env.example
│
├── mobile/                  # Flutter iOS app
│   ├── lib/
│   │   ├── models/         # Data models (User, Task, Project)
│   │   ├── services/       # API clients
│   │   ├── providers/      # Riverpod state management
│   │   ├── screens/        # UI screens
│   │   ├── widgets/        # Reusable components
│   │   └── main.dart       # App entry point
│   └── pubspec.yaml
│
├── database/
│   ├── migrations/         # SQL schema migrations
│   └── seeds/              # Sample data (future)
│
├── .vscode/                # VS Code configurations
├── SETUP.md                # Detailed setup guide
├── setup.sh                # Automated setup script
└── README.md               # Project overview
```

## 🔑 Key Features Implemented

### Authentication
- ✅ User registration with email/password
- ✅ Secure login with JWT tokens
- ✅ Token-based API authentication
- ✅ Auto-login on app restart

### Task Management
- ✅ Create tasks with title, description, and scheduled date
- ✅ Task signifiers (• = not done, X = done, > = rescheduled, ⊗ = blocked)
- ✅ Update task state (done, blocked)
- ✅ Reschedule tasks to different dates
- ✅ Delete tasks
- ✅ View tasks by date (daily log)

### Migration System
- ✅ Manual migration (reschedule) with intentional friction
- ✅ Track migration count per task
- ✅ Warning after 2nd migration
- ✅ Block migration at 3rd attempt (user must confirm)
- ✅ Audit trail: old task stays "rescheduled," new task created

### Projects/Collections
- ✅ Create projects with name, description, color
- ✅ Tag tasks to projects (optional)
- ✅ View project task count
- ✅ Archive projects

### Data Model
- ✅ Users, Teams, Tasks, Projects, Notes, Habits, Habit Logs
- ✅ Foreign keys and relationships
- ✅ Timestamps (created_at, updated_at)
- ✅ Soft delete support (archived flag)

## 🚀 Tech Stack

### Backend
- **Runtime:** Node.js 18+
- **Framework:** Express 4
- **Language:** TypeScript
- **Database:** PostgreSQL 14
- **Cache/Queue:** Redis
- **Authentication:** JWT (jsonwebtoken)
- **Password Hashing:** bcrypt
- **API Documentation:** RESTful conventions

### Mobile
- **Framework:** Flutter 3.24+
- **Language:** Dart
- **State Management:** Riverpod
- **HTTP Client:** http package
- **Local Storage:** shared_preferences (for tokens)
- **UI:** Material 3 with custom BuJo-inspired design
- **Target:** iOS first (expandable to Android, macOS, Windows)

### DevOps
- **Version Control:** Git
- **IDE:** VS Code with Flutter + Dart extensions
- **Database Migrations:** node-pg-migrate
- **Development:** Hot reload (Flutter), nodemon (backend)

## 📊 Database Schema

**Users** → Authentication and profile
**Teams** → For team collaboration (Phase 4)
**Tasks** → Core bullet journal tasks
  - States: not_done, done, blocked, rescheduled
  - Migration tracking
  - Project association
  - Assignment (for teams)
**Projects** → Collections/projects
**Notes** → Events and notes in logs (basic implementation)
**Habits** → Daily habit tracking (Phase 2)
**Habit Logs** → Daily check-ins for habits (Phase 2)

## 🎯 What Works Right Now

1. **Register** a new account
2. **Login** and stay authenticated
3. **Create tasks** for any date
4. **View daily log** (switch dates with calendar picker)
5. **Mark tasks done** (X signifier)
6. **Reschedule tasks** (manual migration, > signifier)
   - See migration count
   - Get warning at 3rd migration
7. **Block tasks** (⊗ signifier)
8. **Delete tasks**
9. **Create projects** (collections)
10. **Tag tasks** to projects

## 📋 What's Next (Future Phases)

### Phase 2: Habits + Analytics (3-4 weeks)
- [ ] Habit tracker (daily check-ins)
- [ ] Visual habit grid (monthly view)
- [ ] Streak tracking
- [ ] Velocity metrics (tasks completed over time)
- [ ] Migration frequency analytics
- [ ] Dashboard with charts

### Phase 3: Recurring Tasks + Polish (3-4 weeks)
- [ ] Create recurring tasks (daily, weekly, monthly, annually)
- [ ] Auto-generate instances 1 month ahead
- [ ] Edit/delete single instance vs. series
- [ ] UI polish and animations
- [ ] Improved offline support

### Phase 4: Team Collaboration (6-8 weeks)
- [ ] Team creation (up to 8 members)
- [ ] Task assignment peer-to-peer
- [ ] Acknowledgement system
- [ ] Real-time sync via WebSocket
- [ ] Activity feed
- [ ] Notifications (push, email)

### Phase 5: Cross-Platform (4-6 weeks per platform)
- [ ] Android app
- [ ] macOS app
- [ ] Windows app
- [ ] Linux app (optional)
- [ ] Platform-specific optimizations

### Phase 6: Advanced Features (ongoing)
- [ ] Calendar grid views
- [ ] External calendar sync (Google, Outlook)
- [ ] Export/import (PDF, CSV, JSON)
- [ ] Themes and customization
- [ ] Voice input for rapid logging
- [ ] Slack/Teams integrations
- [ ] API for third-party tools

## 🛠️ Development Workflow

### Starting Development

**Terminal 1: Backend**
```bash
cd backend
npm run dev
```

**Terminal 2: Mobile**
```bash
cd mobile
flutter run
```

**Or use VS Code:**
- Press F5
- Select "Full Stack: Backend + Mobile"

### Making Changes

**Backend:**
- Edit files in `backend/src/`
- Server auto-reloads on save (nodemon)
- Test API: http://localhost:3000/health

**Mobile:**
- Edit files in `mobile/lib/`
- Press `r` for hot reload (instant updates)
- Press `R` for hot restart (full restart)

### Database Changes

1. Create migration:
   ```bash
   npm run migrate:create add_new_field
   ```

2. Edit migration file in `database/migrations/`

3. Run migration:
   ```bash
   npm run migrate
   ```

## 📖 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user (requires auth)

### Tasks
- `GET /api/tasks` - Get tasks (with filters)
  - Query params: `startDate`, `endDate`, `projectId`, `state`
- `POST /api/tasks` - Create task
- `PATCH /api/tasks/:id` - Update task
- `POST /api/tasks/:id/reschedule` - Reschedule task (migration)
- `DELETE /api/tasks/:id` - Delete task

### Projects
- `GET /api/projects` - Get projects
- `POST /api/projects` - Create project
- `PATCH /api/projects/:id` - Update project
- `DELETE /api/projects/:id` - Delete project

## 🎨 Design Philosophy

### Faithful to Analog Bullet Journaling
- **Signifiers:** Visual symbols for task states (•, X, >, ⊗)
- **Rapid logging:** Quick capture with minimal friction
- **Manual migration:** Intentional reflection, not automation
- **Collections:** Projects as themed lists
- **Chronological logs:** Daily/weekly/monthly views

### Digital Enhancements
- **Instant migration:** Drag-and-drop vs. rewriting
- **Automatic indexing:** Search and filter
- **Click to jump:** Navigate between dates/projects
- **Visual feedback:** Charts, streaks, progress bars
- **Sync:** Access from any device
- **Collaboration:** Share with team (Phase 4)

## 🔐 Security Considerations

- ✅ Passwords hashed with bcrypt (10 rounds)
- ✅ JWT tokens for API authentication
- ✅ HTTPS recommended for production
- ✅ SQL injection protection (parameterized queries)
- ✅ CORS configuration
- ⚠️ Rate limiting (TODO for production)
- ⚠️ Input validation (basic, expand for production)
- ⚠️ Helmet.js security headers (TODO)

## 🚨 Production Readiness

### Before Deploying to Production:

1. **Environment Security:**
   - [ ] Generate strong JWT secret
   - [ ] Use environment variables for all secrets
   - [ ] Never commit .env files

2. **Database:**
   - [ ] Set up automated backups
   - [ ] Use connection pooling
   - [ ] Enable SSL for connections

3. **API Security:**
   - [ ] Add rate limiting (express-rate-limit)
   - [ ] Add Helmet.js for security headers
   - [ ] Implement request validation (joi or zod)
   - [ ] Set up logging (winston or pino)
   - [ ] Error monitoring (Sentry)

4. **Mobile:**
   - [ ] Update API baseUrl to production server
   - [ ] Enable ProGuard (Android)
   - [ ] Configure App Transport Security (iOS)
   - [ ] Set up crash reporting (Firebase Crashlytics)

5. **Infrastructure:**
   - [ ] Deploy backend to VPS/cloud (DigitalOcean, AWS, GCP)
   - [ ] Set up reverse proxy (Nginx)
   - [ ] Configure SSL certificates (Let's Encrypt)
   - [ ] Set up monitoring (Uptime Robot, Prometheus)

## 📚 Resources

### Documentation
- [Flutter Docs](https://docs.flutter.dev/)
- [Express.js Guide](https://expressjs.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Riverpod Guide](https://riverpod.dev/)

### Tutorials Used
- Bullet Journaling: [bulletjournal.com](https://bulletjournal.com/)
- Flutter State Management: Riverpod
- Node.js Best Practices: Express + TypeScript

## 🐛 Known Issues & TODOs

### High Priority
- [ ] Add pagination to task list (performance for large lists)
- [ ] Implement search functionality
- [ ] Add loading states for all async operations
- [ ] Handle network errors gracefully (retry logic)
- [ ] Add pull-to-refresh on all list views

### Medium Priority
- [ ] Add task filtering by project/state
- [ ] Implement weekly/monthly log views
- [ ] Add task notes/comments
- [ ] Improve date picker UX
- [ ] Add dark mode support

### Low Priority
- [ ] Add animations for task state changes
- [ ] Implement swipe actions for tasks
- [ ] Add task sorting options
- [ ] Create splash screen
- [ ] Add app icon

## 🎓 Learning Outcomes

Building this project taught:
- Full-stack development (backend + mobile)
- RESTful API design and implementation
- PostgreSQL schema design and migrations
- Flutter state management with Riverpod
- JWT authentication flow
- Git version control best practices
- Self-hosted app architecture
- Product specification and planning

## 🤝 Contributing

This is a personal project, but contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

Private - All Rights Reserved

## 🙏 Acknowledgments

- Bullet Journal® method by Ryder Carroll
- Flutter team for amazing framework
- Open source community for dependencies

---

**Current Status:** Phase 1 MVP Complete ✅

**Next Milestone:** Phase 2 (Habits + Analytics)

**Estimated Timeline:**
- Phase 2: 3-4 weeks
- Phase 3: 3-4 weeks
- Phase 4: 6-8 weeks
- Phase 5: 4-6 weeks per platform

**Total Effort to Full Product:** ~6-8 months

---

Built with ❤️ and lots of ☕
