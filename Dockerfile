FROM owncloud:9

RUN apt-get update && apt-get install -y \
        php5-imap \
        cron \
        && rm -rf /var/lib/apt/lists/* \
        && update-rc.d cron defaults

RUN echo "SHELL=/bin/bash" >> owncloud-cron \
    && echo "PATH=/usr/local/bin:/usr/bin:/bin" >> owncloud-cron \
    && echo "*/15 * * * * php -f /var/www/html/cron.php > /dev/null 2>&1" >> owncloud-cron \
    crontab -u www-data owncloud-cron

CMD ["apache2-foreground", "/etc/init.d/cron start"]
