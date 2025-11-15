# Environment
NODE_ENV=development
DEBUG=true
LOG_LEVEL=INFO

# Server
HOST=0.0.0.0
PORT=8000
API_VERSION=v1

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-supabase-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# AI/LLM Providers
GROQ_API_KEY=your-groq-key
OPENAI_API_KEY=your-openai-key
GOOGLE_AI_API_KEY=your-google-ai-key
ANTHROPIC_API_KEY=your-anthropic-key

# Voice Services
DEEPGRAM_API_KEY=your-deepgram-key
CARTESIA_API_KEY=your-cartesia-key
ELEVENLABS_API_KEY=your-elevenlabs-key

# Telephony
TELNYX_API_KEY=your-telnyx-key
TELNYX_PUBLIC_KEY=your-telnyx-public-key
TELNYX_PHONE_NUMBER=+1234567890

# CRM Integrations
HUBSPOT_API_KEY=your-hubspot-key
SALESFORCE_CLIENT_ID=your-sf-client-id
SALESFORCE_CLIENT_SECRET=your-sf-client-secret
SALESFORCE_USERNAME=your-sf-username
SALESFORCE_PASSWORD=your-sf-password
SALESFORCE_SECURITY_TOKEN=your-sf-token

# Calendar Integrations
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GOOGLE_REDIRECT_URI=http://localhost:8000/auth/google/callback

# Ticketing
ZENDESK_SUBDOMAIN=your-subdomain
ZENDESK_EMAIL=your-email
ZENDESK_API_TOKEN=your-zendesk-token
INTERCOM_ACCESS_TOKEN=your-intercom-token

# Payment
STRIPE_API_KEY=your-stripe-key
STRIPE_WEBHOOK_SECRET=your-webhook-secret

# Monitoring
SENTRY_DSN=your-sentry-dsn
POSTHOG_API_KEY=your-posthog-key
POSTHOG_HOST=https://app.posthog.com

# Redis (for caching & Celery)
REDIS_URL=redis://localhost:6379/0

# Security
SECRET_KEY=your-secret-key-min-32-chars
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Feature Flags
ENABLE_SENTIMENT_ADAPTATION=true
ENABLE_OUTCOME_PREDICTION=true
ENABLE_AB_TESTING=true
ENABLE_LEARNING_LOOP=true
ENABLE_DYNAMIC_PERSONA=true

# Performance
MAX_CONCURRENT_CALLS=100
CALL_TIMEOUT_SECONDS=300
LATENCY_TARGET_MS=400
