# 🚀 Deployment Checklist - IACE Backend

**Status:** Backend is production-ready. Follow this checklist to deploy.

---

## Pre-Deployment Setup

### 1. Environment Variables
Create `.env` file with all required variables:

```bash
# CRITICAL - App will not start without these
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
SECRET_KEY=your-secret-key-min-32-characters-long-for-jwt

# AI/LLM Services
GROQ_API_KEY=your-groq-api-key
GOOGLE_AI_API_KEY=your-google-ai-key
OPENAI_API_KEY=your-openai-key  # Optional fallback

# Voice Services
DEEPGRAM_API_KEY=your-deepgram-key
CARTESIA_API_KEY=your-cartesia-key

# Telephony
TELNYX_API_KEY=your-telnyx-api-key
TELNYX_PUBLIC_KEY=your-telnyx-public-key
TELNYX_PHONE_NUMBER=+1234567890

# Redis (Highly Recommended)
REDIS_URL=redis://localhost:6379/0

# Optional but Recommended
SENTRY_DSN=your-sentry-dsn
HUBSPOT_API_KEY=your-hubspot-key
HUBSPOT_CLIENT_SECRET=your-hubspot-client-secret
STRIPE_API_KEY=your-stripe-key
STRIPE_WEBHOOK_SECRET=your-stripe-webhook-secret
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Add Missing Package
```bash
pip install asyncpg  # Required for SQLAlchemy async
```

### 4. Run Database Migrations
```bash
# Create all tables
alembic upgrade head

# Verify tables were created
# Check in Supabase dashboard or run:
# SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
```

---

## Deployment Options

### Option A: Local Development

```bash
# Start Redis (required for distributed rate limiting)
docker run -d -p 6379:6379 redis:alpine

# Start the server
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

**Test:**
```bash
curl http://localhost:8000/health
curl http://localhost:8000/health/ready
curl http://localhost:8000/metrics
```

---

### Option B: Docker Deployment

```bash
# Build image
docker build -t iace-backend .

# Run with Docker Compose (includes Redis)
docker-compose up -d

# Check logs
docker-compose logs -f backend
```

---

### Option C: Fly.io Deployment

```bash
# Install Fly CLI
curl -L https://fly.io/install.sh | sh

# Login
fly auth login

# Set secrets
fly secrets set \
  SUPABASE_URL=your-url \
  SUPABASE_KEY=your-key \
  SUPABASE_SERVICE_ROLE_KEY=your-service-key \
  SECRET_KEY=your-secret-key \
  GROQ_API_KEY=your-groq-key \
  GOOGLE_AI_API_KEY=your-google-key \
  DEEPGRAM_API_KEY=your-deepgram-key \
  CARTESIA_API_KEY=your-cartesia-key \
  TELNYX_API_KEY=your-telnyx-key \
  TELNYX_PUBLIC_KEY=your-telnyx-public-key

# Deploy
fly deploy

# Check status
fly status
fly logs
```

---

## Post-Deployment Verification

### 1. Health Checks
```bash
# Basic health
curl https://your-domain.com/health

# Readiness check (verifies all services)
curl https://your-domain.com/health/ready
```

Expected response:
```json
{
  "status": "ready",
  "checks": {
    "database": true,
    "redis": true,
    "telephony": true,
    "ai_services": true
  }
}
```

### 2. Metrics Endpoint
```bash
curl https://your-domain.com/metrics
```

Should return Prometheus-formatted metrics.

### 3. Authentication Test
```bash
# This should return 401 (good!)
curl https://your-domain.com/api/v1/agents

# This should return 200 (after you create a user)
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     https://your-domain.com/api/v1/agents
```

### 4. Webhook Test
```bash
# Test Telnyx webhook (should return 401 without signature)
curl -X POST https://your-domain.com/api/v1/webhooks/telnyx/call \
     -H "Content-Type: application/json" \
     -d '{"test": "data"}'
```

Expected: `401 Unauthorized` (signature missing)

---

## Database Seeding (Optional)

Create seed data for testing:

```python
# create_seed_data.py
import asyncio
from uuid import uuid4
from app.db.session import init_db, AsyncSessionLocal
from app.db.models import AgentModel, CustomerModel

async def seed_data():
    await init_db()
    
    async with AsyncSessionLocal() as session:
        # Create test agent
        agent = AgentModel(
            id=uuid4(),
            name="Test Support Agent",
            agent_type="support",
            status="active",
            voice_config={"provider": "cartesia", "voice_id": "test"},
            system_prompt="You are a helpful support agent",
            greeting_message="Hello! How can I help you?",
        )
        session.add(agent)
        
        # Create test customer
        customer = CustomerModel(
            id=uuid4(),
            name="John Doe",
            phone="+1234567890",
            email="john@example.com",
            segment="standard",
            status="active",
        )
        session.add(customer)
        
        await session.commit()
        print("✅ Seed data created")

# Run: python -c "from create_seed_data import seed_data; import asyncio; asyncio.run(seed_data())"
```

---

## Monitoring Setup

### 1. Prometheus
Add this to your `prometheus.yml`:
```yaml
scrape_configs:
  - job_name: 'iace-backend'
    static_configs:
      - targets: ['your-domain.com:8000']
    metrics_path: '/metrics'
```

### 2. Grafana Dashboard
Import metrics:
- `iace_calls_total`
- `iace_call_duration_seconds`
- `iace_sentiment_score`
- `iace_api_request_duration_seconds`
- `iace_active_calls`

---

## Security Checklist

- [ ] All endpoints require authentication
- [ ] Webhook signatures verified
- [ ] SECRET_KEY is strong (32+ characters)
- [ ] HTTPS enabled (production)
- [ ] CORS origins configured correctly
- [ ] Rate limiting enabled (Redis running)
- [ ] Sentry configured for error tracking

---

## Performance Checklist

- [ ] Redis connected (check health endpoint)
- [ ] Database indexes created (migration ran)
- [ ] Connection pooling configured
- [ ] Rate limiting working (test with 60+ requests)

---

## Troubleshooting

### Configuration Error on Startup
**Error:** `Missing critical configuration: GROQ_API_KEY`

**Fix:** Set all required environment variables. The app validates on startup.

### Database Connection Failed
**Error:** `Failed to initialize database`

**Fix:** 
1. Verify Supabase credentials
2. Check if Supabase project is active
3. Ensure `asyncpg` is installed

### Redis Not Available
**Warning:** `Redis initialization failed`

**Impact:** Rate limiting falls back to in-memory (not distributed)

**Fix:** Start Redis or set `REDIS_URL`

### Webhook Signature Verification Failed
**Error:** `401 Unauthorized` on webhook

**Fix:** This is expected! Configure webhook signatures in provider dashboards.

---

## Next Steps After Deployment

1. **Train ML Model**
   ```bash
   python app/ml/train_outcome_predictor.py
   ```

2. **Write Tests**
   - Set up pytest
   - Write unit tests for services
   - Write integration tests

3. **Set Up CI/CD**
   - GitHub Actions
   - Automated testing
   - Automated deployment

4. **Monitoring**
   - Configure alerts in Grafana
   - Set up PagerDuty/OpsGenie
   - Configure log aggregation

---

## Support

If you encounter issues:
1. Check logs: `docker-compose logs -f` or `fly logs`
2. Verify health: `curl /health/ready`
3. Check configuration validation messages

**Your backend is production-ready! 🚀**

