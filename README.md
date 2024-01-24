# Frightened by Hadoop & Hive?

Hi!

I'm currently studying to become a data engineer. One of my teachers has challenged us with a task: to retrieve a list of all horror movies produced between the years 2000 and 2010 (inclusive) that have an IMDb rating equal to or higher than 6. 

The only tools provided was the following link to the IMDb datasets: https://datasets.imdbws.com/ and suggest us to use a virtual machine to run a __Cloudera Quick Start VM__ image.

Since I am studying to become a data engineer and aiming to test my knowledge of Docker, I have decided to make it a bit more challenging by setting up my environment myself, or at least mostly...
With a quick Google request, I've founded a structure that use Hadoop and Hive here: https://github.com/big-data-europe/docker-hive/tree/master.

So, I'll outline all the steps you need to follow to achieve the desired result.  

## Steps
_* Before starting this tutorial make sure you have Docker installed on your machine. Here's a link to install Docker Desktop: https://www.docker.com/products/docker-desktop/._

1. Download the IMDb datasets: https://datasets.imdbws.com/title.basics.tsv.gz and https://datasets.imdbws.com/title.ratings.tsv.gz.
   

3. Extract the files from the archive folders and name the data files __basics.tsv__ and __ratings.tsv__, respectively.


4. Clone this repository to your local machine.


5. Open a terminal window from the local folder where you have cloned this repository's content and run the following command to install all the necessary components to process the IMDb data files:

     `docker-compose up -d`


6. Once the installation is complete, run the following command in your terminal window to see all running containers on your machine:
  
     `docker ps`


7. Take note of the 3-first digits of the id of the two containers with the name containing these strings __'hive-server'__ and __'hadoop-namenode'__.
   _ex.: d8a for d8a3865739de_


8. Copy the two .tsv files into the __namenode__ container.
   Run these commands into your terminal window by changing &lt;namenodeID&gt; by the id you took note of on step 7 and changing &lt;pathTo&gt; by the local path to the .tsv files:

     `docker cp <pathTo>basics.tsv <namenodeID>:/tmp`
  
     `docker cp <pathTo>ratings.tsv <pathTo>:/tmp`


9. Open a new terminal window and access the __namenode__ container CLI:

     `docker exec -it <namenodeID> bash`
   

10. You are now in the __namenode__ container CLI. Now, you'll have to copy the .tsv files into __hdfs__ _(Hadoop File System)_. But first you must create separate folders to copy your file into:
   
     `hfds dfs -mkdir /user/hive/data/basics`
   
     `hdfs dfs -mkdir /user/hive/data/ratings`


11. Aftewards, you can copy .tsv from the container file system into __hdfs__:
   
     `hdfs dfs -copyFromLocal /tmp/basics.tsv /user/hive/data/basics`
      
     `hdfs dfs -copyFromLocal /tmp/ratings.tsv /user/hive/data/ratings`


12. Now that the files are into __hdfs__ , it's time to do some querries in __Hive__.
    First, open a new terminal window and access the __hive-server__ CLI by changing &lt;hiveID&gt; by the id you took note of on step 7:

     `docker exec -it <hiveID> bash`

13. You are now in the __hive-server__ container CLI. You now want to access the __beeline__ CLI to run your __SQL queries__ :

    `/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000/default`
  


