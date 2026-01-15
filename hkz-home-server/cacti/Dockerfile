FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Added 'git' to the install list to fetch the plugin
RUN apt-get update && apt-get install -y \
    apache2 \
    php php-mysql php-snmp php-gd php-xml php-mbstring php-gmp php-ldap php-cli php-intl \
    snmp snmpd rrdtool mariadb-client cron wget git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- PHP CONFIGURATION ---
RUN sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.2/apache2/php.ini
RUN sed -i "s/max_execution_time = .*/max_execution_time = 60/" /etc/php/8.2/apache2/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = Asia\/Jakarta/" /etc/php/8.2/apache2/php.ini

# --- INSTALL CACTI ---
RUN wget https://www.cacti.net/downloads/cacti-latest.tar.gz \
    && tar -zxvf cacti-latest.tar.gz \
    && mv cacti-1.2.* /var/www/html/cacti \
    && rm cacti-latest.tar.gz

# --- INSTALL MIKROTIK PLUGIN ---
# We clone it directly into the Cacti plugins folder named 'mikrotik'
RUN git clone https://github.com/Cacti/plugin_mikrotik.git /var/www/html/cacti/plugins/mikrotik

# --- PERMISSIONS & STARTUP ---
RUN chown -R www-data:www-data /var/www/html/cacti/
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
CMD ["/start.sh"]
