#!/bin/bash

# Exit on any error
set -e

# Configuration variables
VHOST_NAME="pmdevop"
DOMAIN="pmdevop.com"
SERVER_ROOT="/usr/local/lsws"
OLS_CONF="$SERVER_ROOT/conf/httpd_config.conf"
VHOST_DIR="$SERVER_ROOT/conf/vhosts/$VHOST_NAME"
VHOST_CONF="$VHOST_DIR/vhconf.conf"
VHOST_ROOT="$SERVER_ROOT/$VHOST_NAME"
LOG_DIR="$SERVER_ROOT/logs/$VHOST_NAME"
HTML_DIR="$VHOST_ROOT/html"

echo "Creating necessary directories..."
sudo mkdir -p "$VHOST_DIR"
sudo mkdir -p "$HTML_DIR"
sudo mkdir -p "$LOG_DIR"

echo "Setting correct permissions..."
# Set proper ownership for LiteSpeed directories
sudo chown -R nobody:nobody "$VHOST_ROOT"
sudo chmod -R 755 "$VHOST_ROOT"
sudo chown -R nobody:nobody "$LOG_DIR"
sudo chmod -R 755 "$LOG_DIR"

# Ensure logs directory is writable
sudo touch "$LOG_DIR/error.log" "$LOG_DIR/access.log"
sudo chown nobody:nobody "$LOG_DIR/error.log" "$LOG_DIR/access.log"
sudo chmod 644 "$LOG_DIR/error.log" "$LOG_DIR/access.log"

echo "Copying virtual host configuration..."
sudo cp ./vhost.conf "$VHOST_CONF"

echo "Replacing variables in configuration..."
sudo sed -i "s|\$VH_ROOT|$VHOST_ROOT|g" "$VHOST_CONF"
sudo sed -i "s|\$VH_NAME|$VHOST_NAME|g" "$VHOST_CONF"
sudo sed -i "s|\$SERVER_ROOT|$SERVER_ROOT|g" "$VHOST_CONF"

# Create html directory with a basic index file
echo "Creating basic index.html..."
echo "<html><body><h1>Welcome to $DOMAIN</h1></body></html>" | sudo tee "$HTML_DIR/index.html"
sudo chown nobody:nobody "$HTML_DIR/index.html"
sudo chmod 644 "$HTML_DIR/index.html"

# Add virtual host to main configuration if not exists
if ! grep -q "virtualhost $VHOST_NAME" "$OLS_CONF"; then
    echo "Adding virtual host to main configuration..."
    echo "
virtualhost $VHOST_NAME {
    vhRoot              $VHOST_ROOT
    configFile          $VHOST_CONF
    allowSymbolLink     1
    enableScript        1
    restrained         1
}" | sudo tee -a "$OLS_CONF"
fi

# Create SSL directory if it doesn't exist
SSL_DIR="/etc/letsencrypt/live/$DOMAIN"
if [ ! -d "$SSL_DIR" ]; then
    echo "Creating SSL directory..."
    sudo mkdir -p "$SSL_DIR"
fi

# Verify SSL certificate paths
SSL_CERT="$SSL_DIR/fullchain.pem"
SSL_KEY="$SSL_DIR/privkey.pem"

if [ ! -f "$SSL_CERT" ] || [ ! -f "$SSL_KEY" ]; then
    echo "Warning: SSL certificates not found at $SSL_CERT or $SSL_KEY"
    echo "Please ensure SSL certificates are properly installed"
    echo "You can install them using certbot: sudo certbot certonly --webroot -w $HTML_DIR -d $DOMAIN -d www.$DOMAIN"
fi

echo "Verifying OpenLiteSpeed configuration..."
if sudo "$SERVER_ROOT/bin/lshttpd" -t; then
    echo "Configuration verified successfully"
    echo "Restarting OpenLiteSpeed..."
    sudo systemctl restart lsws
    echo "Configuration completed and server restarted successfully"
else
    echo "Error: Configuration verification failed"
    echo "Please check the configuration files and try again"
    exit 1
fi

# Final check
if sudo systemctl is-active --quiet lsws; then
    echo "OpenLiteSpeed is running"
    echo "Configuration complete!"
    echo "Next steps:"
    echo "1. Install SSL certificates if not already done"
    echo "2. Start your Docker containers"
    echo "3. Test the proxy configuration"
else
    echo "Error: OpenLiteSpeed is not running"
    echo "Please check the logs at $SERVER_ROOT/logs/error.log"
    exit 1
fi
