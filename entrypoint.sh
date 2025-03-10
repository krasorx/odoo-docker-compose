#!/bin/bash
# Substitute ODOO_ADMIN_PASSWORD using sed
sed "s/{{ODOO_ADMIN_PASSWORD}}/$ODOO_ADMIN_PASSWORD/g" /etc/odoo/odoo.conf.template > /etc/odoo/odoo.conf
# Start Odoo
exec "$@"