#!/usr/bin/with-contenv bashio

source /usr/lib/bashio/bashio.sh

# Log the start of the script
bashio::log.info "Starting run.sh script..."

# Fetch configuration values from Home Assistant
APP_URL=$(bashio::config 'app_url')
DB_HOST=$(bashio::config 'db_host')
DB_USERNAME=$(bashio::config 'db_username')
DB_PASSWORD=$(bashio::config 'db_password')
DB_DATABASE=$(bashio::config 'db_database')
APP_KEY=$(bashio::config 'app_key')
IN_USER_EMAIL=$(bashio::config 'in_user_email')
IN_PASSWORD=$(bashio::config 'in_password')
MAIL_MAILER=$(bashio::config 'mail_mailer')
MAIL_HOST=$(bashio::config 'mail_host')
MAIL_PORT=$(bashio::config 'mail_port')
MAIL_USERNAME=$(bashio::config 'mail_username')
MAIL_PASSWORD=$(bashio::config 'mail_password')
MAIL_ENCRYPTION=$(bashio::config 'mail_encryption')
MAIL_FROM_ADDRESS=$(bashio::config 'mail_from_address')
MAIL_FROM_NAME=$(bashio::config 'mail_from_name')
MYSQL_ROOT_PASSWORD=$(bashio::config 'mysql_root_password')
MYSQL_USER=$(bashio::config 'mysql_user')
MYSQL_PASSWORD=$(bashio::config 'mysql_password')
MYSQL_DATABASE=$(bashio::config 'mysql_database')

# Export them as environment variables
export APP_URL DB_HOST DB_USERNAME DB_PASSWORD DB_DATABASE APP_KEY IN_USER_EMAIL IN_PASSWORD
export MAIL_MAILER MAIL_HOST MAIL_PORT MAIL_USERNAME MAIL_PASSWORD MAIL_ENCRYPTION
export MAIL_FROM_ADDRESS MAIL_FROM_NAME MYSQL_ROOT_PASSWORD MYSQL_USER MYSQL_PASSWORD MYSQL_DATABASE

# Log some variables for debugging
bashio::log.info "APP_URL=${APP_URL}"
bashio::log.info "DB_HOST=${DB_HOST}"
bashio::log.info "DB_USERNAME=${DB_USERNAME}"
bashio::log.info "DB_DATABASE=${DB_DATABASE}"
bashio::log.info "APP_KEY=${APP_KEY}"
bashio::log.info "MYSQL_USER=${MYSQL_USER}"

# Call the original entry point or command
bashio::log.info "Starting the main service..."