# 🚀 Quick Start Guide - IACE Voice AI V1

**Time to run:** 5-10 minutes  
**Prerequisites:** Python 3.11+, PostgreSQL 15+, Redis

---

## Step 1: Environment Setup

```bash
# Clone and enter directory
cd v1

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

## Step 2: Configure Environment

Create `.env` file:

```bash
# Database (Supabase Postgres)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
DATABASE_URL=postgresql+asyncpg://postgres:password@host:5432/postgres

# Redis
REDIS_URL=redis://localhost:6379/0

# API Keys
TELNYX_API_KEY=your-telnyx-key
TELNYX_PUBLIC_KEY=your-telnyx-public-key
TELNYX_PHONE_NUMBER=+1234567890

GROQ_API_KEY=your-groq-key
GOOGLE_AI_API_KEY=your-google-ai-key
DEEPGRAM_API_KEY=your-deepgram-key
CARTESIA_API_KEY=your-cartesia-key

# Auth
SECRET_KEY=your-secret-key-at-least-32-chars
ACCESS_TOKEN_EXPIRE_MINUTES=30

# App
ENVIRONMENT=development
DEBUG=true
LOG_LEVEL=INFO
```

## Step 3: Run Database Migrations

```bash
# Enable pgvector extension (Supabase)
# In Supabase Dashboard: SQL Editor → Run:
CREATE EXTENSION IF NOT EXISTS vector;

# Run migrations
alembic upgrade head

# You should see:
# INFO  [alembic.runtime.migration] Running upgrade -> 001_initial_schema
# INFO  [alembic.runtime.migration] Running upgrade 001 -> 002_add_pgvector  
# INFO  [alembic.runtime.migration] Running upgrade 002 -> 003_auth_tables
```

## Step 4: Start the Server

```bash
# Development mode (with hot reload)
uvicorn app.main:app --reload --port 8000

# You should see:
# 🚀 IACE Backend started successfully
# INFO: Uvicorn running on http://127.0.0.1:8000
```

## Step 5: Verify Installation

### Check Health Endpoint
```bash
curl http://localhost:8000/health

# Expected response:
# {
#   "status": "healthy",
#   "version": "1.0.0",
#   "environment": "development"
# }
```

### Check API Docs
Open browser: http://localhost:8000/docs

You should see interactive API documentation with:
- ✅ Authentication endpoints
- ✅ Call management endpoints
- ✅ Agent endpoints
- ✅ Customer endpoints
- ✅ Analytics endpoints
- ✅ Webhook endpoints

### Run Tests
```bash
pytest --cov=app

# Expected output:
# ====== test session starts ======
# collected 50+ items
# tests/test_utils/test_auth.py ............ [ 20%]
# tests/test_utils/test_resilience.py ............ [ 40%]
# tests/test_repositories/test_call_repository.py ............ [ 60%]
# tests/test_services/test_call_service.py ........ [ 80%]
# tests/test_api/test_calls.py ........ [100%]
# 
# ====== 50 passed in 5.23s ======
# Coverage: 40%
```

---

## 🎯 **Common Operations**

### Create a Call

```bash
curl -X POST http://localhost:8000/api/v1/calls \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": "UUID-HERE",
    "agent_id": "UUID-HERE",
    "direction": "inbound",
    "call_type": "support",
    "from_number": "+15551234567",
    "to_number": "+15559876543"
  }'
```

### Get Call with Context

```bash
curl http://localhost:8000/api/v1/calls/{call_id} \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Refresh Auth Token

```bash
curl -X POST http://localhost:8000/api/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "YOUR_REFRESH_TOKEN"
  }'
```

### View Metrics

```bash
curl http://localhost:8000/metrics

# Returns Prometheus-format metrics:
# iace_calls_total{direction="inbound",call_type="support",outcome="success"} 42
# iace_sentiment_score{call_id="..."} 0.75
# iace_active_calls 5
```

---

## 🧪 **Testing**

### Run All Tests
```bash
pytest
```

### Run with Coverage
```bash
pytest --cov=app --cov-report=html
open htmlcov/index.html  # View coverage report
```

### Run Specific Test Suite
```bash
pytest tests/test_utils/test_auth.py -v
pytest tests/test_repositories/ -v
pytest tests/test_api/ -v
```

### Run with Debugging
```bash
pytest -v -s  # Show print statements
pytest --pdb  # Drop into debugger on failure
```

---

## 🔧 **Troubleshooting**

### Database Connection Issues
```bash
# Test database connection
python -c "from app.db.session import init_db; import asyncio; asyncio.run(init_db())"

# If fails, check:
# 1. DATABASE_URL is correct
# 2. PostgreSQL is running
# 3. Firewall allows connection
```

### Redis Connection Issues
```bash
# Test Redis connection
redis-cli ping  # Should return PONG

# If fails:
# 1. Start Redis: redis-server
# 2. Check REDIS_URL in .env
```

### Migration Issues
```bash
# Check current migration
alembic current

# Rollback one migration
alembic downgrade -1

# Reset to specific revision
alembic downgrade 001_initial_schema

# Re-run migrations
alembic upgrade head
```

### API Key Issues
```bash
# Verify environment variables are loaded
python -c "from app.config import settings; print(settings.GROQ_API_KEY[:10])"

# If empty, check:
# 1. .env file exists
# 2. python-dotenv is installed
# 3. Variables are properly exported
```

---

## 📚 **Documentation**

- **`IMPLEMENTATION_SUMMARY.md`** - What was implemented
- **`V1_COMPLETION_REPORT.md`** - Full completion report
- **`UPDATED_TECHINCAL_REVIEW.md`** - Architecture review (updated)
- **`V1-ACTION-PLAN.md`** - Action plan with progress
- **`README.md`** - Project overview

---

## 🤝 **Support**

For issues or questions:
1. Check logs: `tail -f logs/*.log` (in production)
2. View traces in Jaeger: http://localhost:16686
3. Check metrics: http://localhost:8000/metrics
4. Review test failures: `pytest -v`

---

**You're ready to build one of the greatest Voice AI SaaS platforms! 🚀**

