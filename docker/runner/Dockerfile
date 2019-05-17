#Download base image gitlab-runner latest
FROM gitlab/gitlab-runner:latest
 
# Update Software repository
RUN apt-get update

# Install dependencies
RUN apt-get install -q -y python make gcc g++ git libblas-dev liblapack-dev
