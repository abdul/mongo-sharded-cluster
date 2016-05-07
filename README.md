# Mongo Replicas running as Docker containers. 

Inspiration and most of code/configuration comes from [this blog post] (http://www.tothenew.com/blog/mongodb-replica-set-using-docker-networking-and-docker-compose/) (Thanks to [Navjot Singh] (http://www.tothenew.com/blog/author/navjot/) -- Author of the post).

### Steps to run:

* Build base image: `docker build -t mongo-cluster-base .`
* Run `docker-compose up`
* Wait for about 1-2 minutes, let nodes come up, and replicas configuration takes place
* Connect to PRIMARY (or master) - `mongo <DOCKER_MACHINE_IP:27017>`
* Import or add data


### Verifying if SECONDARY->PRIMARY failover works?

* Stop PRIMARY (master) service - `docker-compose stop mongodb-master`
* Connect to one of SECONDARY (slave) - `mongo <DOCKER_MACHINE_IP:27018>`
* Verify if data (imported/added earlier on PRIMARY) is available
