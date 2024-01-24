# imdb_horror_query

Hi!

I'm currently studying to become a data engineer. One of my teachers has challenged us with a task: to retrieve a list of all horror movies produced between the years 2000 and 2010 (inclusive) that have an IMDb rating equal to or higher than 6. The only tools provided was the following link to the IMDb datasets: https://datasets.imdbws.com/ and suggest us to use a virtual machine to run a Cloudera Quick Start image.

Since I am studying to become a data engineer and aiming to test my knowledge of Docker, I have decided to make it a bit more challenging by setting up my environment myself, or at least mostly...
With a quick Google request, I've founded a structure that use Hadoop and Hive here: https://github.com/big-data-europe/docker-hive/tree/master.
So, I'll outline the steps you need to follow to achieve the desired result.  

Steps
* Before starting thi tutorial make sure you have Docker installed on your machine. Here's a link to install Docker Desktop: https://www.docker.com/products/docker-desktop/.

1. Download the IMDb datasets: https://datasets.imdbws.com/title.basics.tsv.gz and https://datasets.imdbws.com/title.ratings.tsv.gz.

2. Extract the files from the archive folders and name the data files basics.tsv and ratings.tsv, respectively.

3. Clone this repository to your local machine.

4. Open a terminal window from the local folder where you have cloned this repository's content and run the following command to install all the necessary components to process the IMDb data files:
   `docker-compose up -d`

6. Once the installation is complete, run the following command in your terminal window to see all running containers on your machine:
   `docker ps`

