#Download base image fedora latest
FROM fedora:latest

# Install dependencies
RUN dnf install -y which curl xz patch lbzip2 findutils python make gcc-c++ gcc-gfortran git

# Add a new user "myuser" with user id 8877
RUN useradd -u 8877 myuser
WORKDIR /home/myuser
RUN chown -R myuser:myuser /home/myuser
RUN chmod 777 /home/myuser
# Change to non-root privilege
USER myuser