# Frightened by Hadoop & Hive?

Hi there!

I'm currently studying to become a data engineer. One of my teachers has challenged us with a task: to retrieve a list of all horror movies produced between the years 2000 and 2010 (inclusive) that have an IMDb rating equal to or higher than 6.

The only tools provided were the following link to the IMDb datasets: [https://datasets.imdbws.com/](https://datasets.imdbws.com/) and the suggestion to use a virtual machine to run a Cloudera Quick Start VM image.

Since I am studying to become a data engineer and aiming to test my knowledge of Docker, I have decided to make it a bit more challenging by setting up my environment myself, or at least mostly... With a quick Google request, I've found a structure that uses Hadoop and Hive [here](https://github.com/big-data-europe/docker-hive/tree/master).

So, I'll outline all the steps you need to follow to achieve the desired result.

## Steps

### 1. Copy .tsv files locally

Before starting this tutorial, make sure you have Docker installed on your machine. [Here's a link to install Docker Desktop](https://www.docker.com/products/docker-desktop/).

Download the IMDb datasets: [title.basics.tsv.gz](https://datasets.imdbws.com/title.basics.tsv.gz) and [title.ratings.tsv.gz](https://datasets.imdbws.com/title.ratings.tsv.gz).

Extract the files from the archive folders and name the data files `basics.tsv` and `ratings.tsv`, respectively.

### 2. Implantation of the containers structure

Clone this repository to your local machine.

Open a terminal window from the local folder where you have cloned this repository's content and run the following command to install all the necessary components to process the IMDb data files:

```bash
        docker-compose up -d
```
Once the installation is complete, run the following command in your terminal window to see all running containers on your machine:

```bash
        docker ps
```
Take note of the first 3 digits of the id of the two containers with names containing these strings 'hive-server' and 'hadoop-namenode', e.g., d8a for d8a3865739de.

### 3. Copy to Namenode Container

Copy the two .tsv files into the namenode container. Run these commands in your terminal window by changing <namenodeID> to the id you took note of on step 2 and changing <pathTo> to the local path to the .tsv files:

```bash
        docker cp <pathTo>basics.tsv <namenodeID>:/tmp
        docker cp <pathTo>ratings.tsv <namenodeID>:/tmp
```

Open a new terminal window and access the namenode container CLI:

```bash
        docker exec -it <namenodeID> bash
```

You are now in the namenode container CLI. Now, you'll have to copy the `.tsv` files into HDFS (Hadoop File System). But first, you must create separate folders to copy your files into:

```bash
        hdfs dfs -mkdir /user/hive/data/basics
        hdfs dfs -mkdir /user/hive/data/ratings
 ```

Afterward, you can copy `.tsv` from the container file system into HDFS:

```bash
        hdfs dfs -copyFromLocal /tmp/basics.tsv /user/hive/data/basics
        hdfs dfs -copyFromLocal /tmp/ratings.tsv /user/hive/data/ratings
```

### 4. Execution of SQL Queries

Now that the files are in HDFS, it's time to run some queries in Hive. First, open a new terminal window and access the hive-server CLI by changing `<hiveID>` to the id you took note of on step 6:

```bash
        docker exec -it <hiveID> bash
```

You are now in the hive-server container CLI. You now want to access the Beeline CLI to run your SQL queries:

```bash
        /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000/default
```

You will now run all the queries from the file `reqHive.sql` in this repository to the Beeline CLI.

### 5. Creating the final file

If you ran all the commands, you should have a file ready to copy to your local machine. Go to the first terminal window or open a new one and run this command by replacing `<hiveID>` with the id you took note of on step 6 and changing `<pathTo>` to the local path where you want to copy the `.csv` file to:

```bash
        docker cp <hiveID>/final_view/000000_0 <pathTo>/horror2000s.csv
```

Sit back, relax, and enjoy the horror movie marathon! Grab your popcorn and get ready for an experience that might send a shiver down your spine!
