#!/bin/bash

set -e

echo "🚀 Bullet Journal Setup Script"
echo "================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo "📋 Checking prerequisites..."

command -v node >/dev/null 2>&1 || { echo -e "${RED}❌ Node.js is not installed${NC}"; exit 1; }
echo -e "${GREEN}✅ Node.js found:${NC} $(node --version)"

command -v npm >/dev/null 2>&1 || { echo -e "${RED}❌ npm is not installed${NC}"; exit 1; }
echo -e "${GREEN}✅ npm found:${NC} $(npm --version)"

command -v psql >/dev/null 2>&1 || { echo -e "${RED}❌ PostgreSQL is not installed${NC}"; exit 1; }
echo -e "${GREEN}✅ PostgreSQL found:${NC} $(psql --version)"

command -v redis-cli >/dev/null 2>&1 || { echo -e "${RED}❌ Redis is not installed${NC}"; exit 1; }
redis-cli ping >/dev/null 2>&1 && echo -e "${GREEN}✅ Redis is running${NC}" || { echo -e "${RED}❌ Redis is not running${NC}"; exit 1; }

command -v flutter >/dev/null 2>&1 || { echo -e "${RED}❌ Flutter is not installed${NC}"; exit 1; }
echo -e "${GREEN}✅ Flutter found:${NC} $(flutter --version | head -n 1)"

echo ""
echo "================================"
echo ""

# Backend setup
echo "🔧 Setting up Backend..."
cd backend

if [ ! -f .env ]; then
  echo "📝 Creating .env file..."
  cp .env.example .env

  # Generate JWT secret
  JWT_SECRET=$(openssl rand -base64 32)

  # Update .env with generated secret (macOS compatible)
  sed -i '' "s/your_jwt_secret_here_change_this_in_production/$JWT_SECRET/" .env

  echo -e "${YELLOW}⚠️  Please update database credentials in backend/.env${NC}"
  echo "   DB_USER, DB_PASSWORD, etc."
  echo ""
  read -p "Press Enter to continue after updating .env..."
fi

echo "📦 Installing backend dependencies..."
npm install

echo ""
echo "🗄️  Database Setup"
echo "================================"
echo "Please run these SQL commands manually:"
echo ""
echo "psql postgres"
echo "CREATE DATABASE bullet_journal;"
echo "CREATE USER bullet_user WITH PASSWORD 'your_secure_password';"
echo "GRANT ALL PRIVILEGES ON DATABASE bullet_journal TO bullet_user;"
echo "\q"
echo ""
echo "Then run migrations:"
echo "psql -U bullet_user -d bullet_journal -f ../database/migrations/1708000000000_initial-schema.sql"
echo ""
read -p "Press Enter once database is set up..."

cd ..

# Mobile setup
echo ""
echo "📱 Setting up Mobile App..."
cd mobile

echo "📦 Installing Flutter dependencies..."
flutter pub get

if [ -d "ios" ]; then
  echo "🍎 Setting up iOS dependencies..."
  cd ios
  pod install
  cd ..
fi

cd ..

echo ""
echo "================================"
echo -e "${GREEN}✅ Setup complete!${NC}"
echo "================================"
echo ""
echo "To start the backend:"
echo "  cd backend && npm run dev"
echo ""
echo "To start the mobile app:"
echo "  cd mobile && flutter run"
echo ""
echo "Or use VS Code launch configurations!"
echo ""
echo "📖 See SETUP.md for detailed instructions"
