FROM owncloud:9

RUN apt-get update && apt-get install -y \
        php5-imap \
        cron \
        && rm -rf /var/lib/apt/lists/* \
        && update-rc.d cron defaults \
        && php5enmod imap \
        && mkdir -p /etc/php5/apache2/conf.d/ \
        && ln -s /etc/php5/mods-available/imap.ini /etc/php5/apache2/conf.d/20-imap.ini 


RUN echo "SHELL=/bin/bash" >> /etc/cron.d/owncloud-cron \
    && echo "PATH=/usr/local/bin:/usr/bin:/bin" >> /etc/cron.d/owncloud-cron \
    && echo "# m h	dom	mon	dow user		command" >> /etc/cron.d/owncloud-cron \
    && echo "*/15	*	*	*	*	www-data	php -f /var/www/html/cron.php > /dev/null 2>&1" >> /etc/cron.d/owncloud-cron

CMD /etc/init.d/cron start; apache2-foreground
