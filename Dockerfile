# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

RUN apt-get update --assume-yes --quiet

# Install Stuff
RUN		apt-get -y install nodejs

# Move into place the App Code
ADD * /

# Install Bower & Install Bower Dependencies
RUN cd /
RUN npm install -g bower
RUN bower install

# Setup NodeJS Runit script
RUN mkdir /etc/service/nodejs
ADD nodejs_runit.sh /etc/service/nodejs/run
RUN chmod ugoa+x /etc/service/nodejs/run

EXPOSE  80

# Clean up APT when done.
RUN apt-get clean && rm -rf \
	/var/lib/apt/lists/* \
	/tmp/* \
	/var/tmp/* \
	/docker-build
