# Mongo Replicas running as Docker containers. 

Inspiration and most of code/configuration comes from [this blog post] (http://www.tothenew.com/blog/mongodb-replica-set-using-docker-networking-and-docker-compose/) (Thanks to [Navjot Singh] (http://www.tothenew.com/blog/author/navjot/) -- Author of the post).

## Information

* PRIMARY - `<DOCKER_MACHINE_IP:27017>`
* SECONDARY - `<DOCKER_MACHINE_IP:27018>`
* SECONDARY - `<DOCKER_MACHINE_IP:27019>`

### Running

* Optional: Build base image: `docker-compose build`
* Run `docker-compose up`
* Wait for about 1-2 minutes, let nodes come up, and replicas configuration takes place
* Connect to Primary (or master) - `mongo <DOCKER_MACHINE_IP:27017>` or `docker run -it abdul/alpine-mongo:latest mongo <DOCKER_MACHINE_IP:27017>`
* [Import] (https://docs.mongodb.com/getting-started/shell/import-data/) or [Insert] (https://docs.mongodb.com/getting-started/shell/insert/) data


### Verifying - Failover Situations (if Secondary becomes Primary)

* Stop Primary (master) service - `docker-compose stop mongodb-master`
* Connect to one of Secondary (slave):
  * `mongo <DOCKER_MACHINE_IP:27018>` or `docker run -it abdul/alpine-mongo:latest mongo <DOCKER_MACHINE_IP:27018>`
  * Or, * `mongo <DOCKER_MACHINE_IP:27019>` or `docker run -it abdul/alpine-mongo:latest mongo <DOCKER_MACHINE_IP:27019>`
* Verify if data (imported/added earlier on Primary) is available
