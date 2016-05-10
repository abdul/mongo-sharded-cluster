# Mongo Sharded Database Cluster running as Docker containers. 

Inspiration and most of code/configuration comes from [this blog post] (http://www.tothenew.com/blog/mongodb-replica-set-using-docker-networking-and-docker-compose/) (Thanks to [Navjot Singh] (http://www.tothenew.com/blog/author/navjot/) -- Author of the post).

This is just an experiment, and might work for development and testing.

### Running

* Optional: Build base image: `docker-compose build`
* Run `docker-compose up -d`
* Wait for about 1-2 minutes, let nodes come up, and replicas configuration takes place
* Connect to Mongos - `mongo <DOCKER_MACHINE_IP:27017>` or `docker run -it abdul/alpine-mongo:latest mongo <DOCKER_MACHINE_IP:27017>`
* [Import] (https://docs.mongodb.com/getting-started/shell/import-data/) or [Insert] (https://docs.mongodb.com/getting-started/shell/insert/) data
