#!/bin/bash

# Define the config path
CONFIG_FILE="/var/www/html/cacti/include/config.php"
DIST_FILE="/var/www/html/cacti/include/config.php.dist"

# Create config.php from the distribution template if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    cp "$DIST_FILE" "$CONFIG_FILE"
fi

# Use sed to replace the default values with your Environment Variables
sed -i "s/\$database_hostname = .*/\$database_hostname = '$DB_HOST';/" "$CONFIG_FILE"
sed -i "s/\$database_default = .*/\$database_default = '$DB_NAME';/" "$CONFIG_FILE"
sed -i "s/\$database_username = .*/\$database_username = '$DB_USER';/" "$CONFIG_FILE"
sed -i "s/\$database_password = .*/\$database_password = '$DB_PASS';/" "$CONFIG_FILE"

# Set the URL path so Nginx proxying works correctly
sed -i "s/\$url_path = .*/\$url_path = '\/cacti\/';/" "$CONFIG_FILE"

echo "* * * * * www-data /usr/bin/php /var/www/html/cacti/poller.php > /var/www/html/cacti/log/poller-cron.log 2>&1
" > /etc/cron.d/cacti

# 2. Fix permissions (Cron will ignore files with loose permissions)
chmod 0644 /etc/cron.d/cacti
chown root:root /etc/cron.d/cacti
rm -f /var/run/crond.pid

# Start the Cacti poller (cron)
service cron start

# Run Apache in the foreground
echo "Cacti is starting on port 80..."
source /etc/apache2/envvars
exec apache2 -D FOREGROUND
