#!/bin/bash
# Substitute environment variables into the config file
envsubst < /etc/odoo/odoo.conf.template > /etc/odoo/odoo.conf
# Start Odoo with the generated config
exec "$@"