FROM owncloud:9
MAINTAINER Sebastian Schneider <mail@sesc.eu>

# install cron
RUN apt-get update && apt-get install -y \
        cron \
        && rm -rf /var/lib/apt/lists/* \
        && update-rc.d cron defaults 


# configure cron to run every 15min
RUN echo "SHELL=/bin/bash" >> /etc/cron.d/owncloud-cron \
    && echo "PATH=/usr/local/bin:/usr/bin:/bin" >> /etc/cron.d/owncloud-cron \
    && echo "# m h	dom	mon	dow user		command" >> /etc/cron.d/owncloud-cron \
    && echo "*/15	*	*	*	*	www-data	php -f /var/www/html/cron.php > /dev/null 2>&1" >> /etc/cron.d/owncloud-cron

# install php5-imap
RUN docker-php5-ext-install imap \
    && docker-php5-ext-enable imap

CMD /etc/init.d/cron start; apache2-foreground
