#!/bin/bash

set -e

# Set the postgres database host, port, user, and password from environment variables
: ${DB_HOST:='postgres'}
: ${DB_PORT:=5432}
: ${DB_USER:='odoo'}
: ${DB_PASSWORD:='adminpassword'}

# Path to the Odoo configuration file
ODOO_RC="/etc/odoo/odoo.conf"

# Function to check if a parameter exists in the config file and use it if present
DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then       
        value=$(grep -E "^\s*\b${param}\b\s*=" "$ODOO_RC" | cut -d " " -f3 | sed 's/["\n\r]//g')
    fi
    DB_ARGS+=("--${param}")
    DB_ARGS+=("${value}")
}

# Check and set database parameters
check_config "db_host" "$DB_HOST"
check_config "db_port" "$DB_PORT"
check_config "db_user" "$DB_USER"
check_config "db_password" "$DB_PASSWORD"

# Substitute ODOO_ADMIN_PASSWORD in the config file
sed "s/{{ODOO_ADMIN_PASSWORD}}/$ODOO_ADMIN_PASSWORD/g" /etc/odoo/odoo.conf.template > "$ODOO_RC"

# Debug: Log the database parameters
echo "DB_HOST=$DB_HOST DB_PORT=$DB_PORT DB_USER=$DB_USER DB_PASSWORD=$DB_PASSWORD" > /tmp/debug.log

# Wait for PostgreSQL to be ready (requires wait-for-psql.py or similar)
# If you don't have wait-for-psql.py, we'll replace this with a simple sleep or skip it
sleep 10  # Temporary workaround; replace with a proper wait script if available

# Explicitly set database parameters for all Odoo operations
odoo --init base "${DB_ARGS[@]}" --database postgres --stop-after-init
exec odoo "${DB_ARGS[@]}" --database postgres