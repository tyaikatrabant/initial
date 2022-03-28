if [ $1 ]
then
    initialdir=$1
else
    initialdir=$(dirname $(readlink -f $0))
    initialdir=${initialdir}"/public"
	if [ ! -d "public" ]; then
        mkdir public
		echo "<?php phpinfo();" > public/index.php
    fi
fi

initialdir=${initialdir//\//\\\/}

sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
                apache2 \
                php8.1 \
                php8.1-dev \
                php8.1-bcmath \
                php8.1-ctype \
                php8.1-curl \
                php8.1-gd \
                php8.1-intl \
                php8.1-mbstring \
                php8.1-mysql \
                php8.1-pgsql \
                php8.1-sqlite3 \
                php8.1-xml \
                php8.1-zip \
                php8.1-tokenizer

sudo sed -i "s/\/var\/www\/html/${initialdir}/g" /etc/apache2/sites-available/000-default.conf
sudo sed -i "s/\/var\/www/${initialdir}/g" /etc/apache2/apache2.conf
sudo sed -i "s/None/All/g" /etc/apache2/apache2.conf
echo "ServerName localhost" | sudo tee -a /etc/apache2/apache2.conf
sudo a2enmod rewrite

wget https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer -O - -q | php -- --quiet
mv composer.phar /usr/local/bin/composer

sudo apt autoremove -y

sudo service apache2 restart