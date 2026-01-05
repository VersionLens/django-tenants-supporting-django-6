# Docker Compose Fixes for Django 6 Testing

## Issues Fixed

### 1. Database Container Exiting
**Problem**: PostgreSQL container was exiting with code 1 due to incompatible data directory structure in PostgreSQL 18+.

**Solution**: Pinned PostgreSQL to version 16 which uses the traditional data directory structure.

### 2. SELinux Volume Flags on macOS
**Problem**: The `:z` flag in volume mounts is for SELinux (Linux) and causes issues on macOS/Windows.

**Solution**: Removed `:z` flags from all volume mounts and switched to named volumes for PostgreSQL data.

### 3. Race Condition on Database Startup
**Problem**: Test container started before PostgreSQL was ready to accept connections, causing "waiting for db:5432" loops.

**Solution**: Added health checks to the database service and updated `depends_on` to wait for healthy status.

### 4. Interactive Test Script
**Problem**: `run_tests_in_docker.sh` had an interactive prompt that hung in CI/automated environments.

**Solution**: Removed the interactive loop and made the script run tests automatically.

## Changes Made

### docker-compose.yml
- Pinned PostgreSQL to version 16: `image: postgres:16`
- Added health check for database readiness
- Changed to named volume: `postgres_data:/var/lib/postgresql/data`
- Removed SELinux `:z` flags from all volume mounts
- Updated `depends_on` to use `condition: service_healthy`
- Removed deprecated `links` directive
- Cleaned up unnecessary configuration

### run_tests_in_docker.sh
- Removed interactive prompt loop
- Made script run tests automatically on execution
- Added `set -e` for proper error propagation

## Test Results ✅

All 98 tests pass with Django 6.0:
- **Standard executor**: 98 tests in 7.6s - OK
- **Multiprocessing executor**: 98 tests in 8.4s - OK

## Usage

```bash
# Run the full test suite
docker-compose run --rm django-tenants-test

# Or run in detached mode
docker-compose up django-tenants-test
```

## Environment
- Python: 3.13
- Django: 6.0
- PostgreSQL: 16
- psycopg: 3.2.13

