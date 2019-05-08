#Download base image gitlab-runner latest
FROM gitlab/gitlab-runner:latest
 
# Update Software repository
RUN apt-get update

# Install Python
RUN apt-get install -q -y python && apt-get install -q -y gcc-4.9 g++-4.9
