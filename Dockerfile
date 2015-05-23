#
# Rocketgraph jenkins for php
#

# Pull base image.
FROM ubuntu:14.04

MAINTAINER Konstantinos Christofilos <kostas.christofilos@rocketgraph.com>

# Install base.
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y curl git htop vim wget openjdk-7-jdk

# Install PHP 5.6
RUN \
  echo "deb http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list.d/dotdeb.list && \
  echo "deb-src http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list.d/dotdeb.list && \
  wget http://www.dotdeb.org/dotdeb.gpg -O- |apt-key add - && \
  apt-get -y update && \
  apt-get -y install php5-cli php5-xsl php5-mysql php5-sqlite php5-curl php5-dev graphviz

RUN echo 'date.timezone = "UTC"' >> /etc/php5/cli/php.ini

# Install xdebug
RUN \
  git clone https://github.com/xdebug/xdebug.git && \
  cd xdebug && \
  phpize && \
  ./configure --enable-xdebug && \
  make && \
  cp modules/xdebug.so /usr/lib/php5/ && \
  echo "zend_extension=/usr/lib/php5/xdebug.so" >> /etc/php5/cli/php.ini

# Install latest phpunit
RUN wget -q https://phar.phpunit.de/phpunit.phar ; chmod +x phpunit.phar ; mv phpunit.phar /usr/bin/phpunit

# Install PHPLOC
RUN wget -q https://phar.phpunit.de/phploc.phar ; chmod +x phploc.phar ; mv phploc.phar /usr/local/bin/phploc

# Install PHP Depend
RUN wget -q http://static.pdepend.org/php/latest/pdepend.phar ; chmod +x pdepend.phar ; mv pdepend.phar /usr/local/bin/pdepend

# Install PHP_CodeSniffer
RUN wget -q https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar ; chmod +x phpcs.phar ; mv phpcs.phar /usr/local/bin/phpcs
RUN wget -q https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar ; chmod +x phpcbf.phar ; mv phpcbf.phar /usr/local/bin/phpcbf

# Instal PHP Copy/Paste Detector (PHPCPD)
RUN wget -q https://phar.phpunit.de/phpcpd.phar ; chmod +x phpcpd.phar ; mv phpcpd.phar /usr/local/bin/phpcpd

# Install phpdoc
RUN wget -q http://www.phpdoc.org/phpDocumentor.phar ; chmod +x phpDocumentor.phar ; mv phpDocumentor.phar /usr/bin/phpdoc

# Install Jenkins
RUN \
  wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - && \
  sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' && \
  sudo apt-get update && \
  sudo apt-get install -y jenkins

RUN mkdir -p /var/jenkins_home

ENV JENKINS_HOME=/var/jenkins_home
# Define mountable directories.
VOLUME ["/var/jenkins_home"]

EXPOSE 8080

CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
