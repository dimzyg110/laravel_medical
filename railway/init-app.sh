#!/bin/bash
# Make sure this file has executable permissions, run `chmod +x railway/init-app.sh`
# Exit the script if any command fails
set -e

# Run migrations
php artisan migrate --force

# Seed the database only on first deploy (check if users table is empty)
USER_COUNT=$(php artisan tinker --execute="echo \App\Models\User::count();" 2>/dev/null | tail -1)
if [ "$USER_COUNT" = "0" ] || [ -z "$USER_COUNT" ]; then
    echo "Seeding database..."
    php artisan db:seed --force
else
    echo "Database already seeded (found $USER_COUNT users), skipping."
fi

# Clear cache
php artisan optimize:clear

# Cache the various components of the Laravel application
php artisan config:cache
php artisan event:cache
php artisan route:cache
php artisan view:cache
