#Download base image ubuntu latest
FROM ubuntu:latest
 
# Update Software repository and install dependencies
RUN apt update && apt install -q -y curl unzip python make gcc g++ gfortran git

# Add a new user "myuser" with user id 8877
RUN useradd -u 8877 myuser
WORKDIR /home/myuser
RUN chown -R myuser:myuser /home/myuser
RUN chmod 777 /home/myuser
# Change to non-root privilege
USER myuser
