# Technical Test: DBT

# Introduction

This technical test makes use the dvdrentals postgresql database, docker & dbt. The goal of this test is to asses the candidate's knowledge of docker-based workflow, dbt & data transformation.

In this exercise, you will set up & teardown your docker environment by following some instructions below, write transformations in dbt to answer the following questions. Useful commands related to docker & dbt have been highlighted below for your convenience.

- For more information about dbt, please visit their (documentation site)[https://docs.getdbt.com/docs/introduction]. I also find the [`setting-up`](https://docs.getdbt.com/tutorial/setting-up) useful tutorial for beginners.
- For more information about docker, please visit their (documentation site)[https://docs.docker.com/]

## Database Schema

The database is hosted locally using docker allowing you to execute queries against it.

![ER Model](dvd-rental-db-diagram.png)

## Exercise Questions

We have set a series of tasks for you to complete as outlined below.

### Data Pipeline

For each question, please write the dbt transformation in the folder dbt_project/models, and we can go through them in the interview.

1. create a table called `monthly_top10_movies` that has the top 10 most popular movies by category for each month.
2. create a table called `monthly_store_value` that has the average customer value & total sales per store by month
3. create a table called `top10_stores_2006` that has the top 10 stores stores ordered by total sales in where the rental date is in 2006. Please refer (`ref`) to the table `monthly_store_value` when defining `yearly_top10_stores`
4. [optional] create a table called `customer_lifecycle`, with a primary key of `customer_id` to provide a holistic view of the customers activitiy and should include:
   - the revenue generated in teh first 30 days of the customer's lifecycle, with day 0 being their first rental date
   - the name of the first film they rented
   - the name of the last film they rented
   - last rental date
   - average time between rentals
   - total revenue
   - any other interesting dimensions / facts you might want to include.

## Pre Requisites

The only pre-requisite is for the testing machine to have

- git
- docker
- any postgresql database client

## Set up

1. clone this repository
2. navigate to the project root
3. run the command `docker-compose build`. _this may take up to 10 minutes_

### `docker-compse build`

this command sets up the services defined in the file `docker-compose.yml`

There are two services:

- dbt: a container with dbt version 0.19 installed & the project skeleton created.
- db: a postgrseql 13 container

The service `db` will have raw data populated & the service `dbt` will have connection set up to interface with our database.

You will be expected to write the transformations as dbt models

## Writing Transformations

In dbt, transformations are expressed as sql select queries. The transformations should be placed in `transformation_name.sql`. The `*.sql` files are processed, and dependencies between various transformation steps (i.e. tables) are specified using the jinja macro `ref` or `source`

- `ref` refers to a table that dbt builds
- `source` will refer to a source table. The source tables are defined in the file `dbt_project/sources/sources.yml`

For instance, given the source table `events` with columns `event_at`, `event_type`, `user_id`, we can create a daily aggregation of events called `daily_events` by placing the following in a model file called `daily_events.sql`

```sql
SELECT DATE(event_at), COUNT(*) event_count, COUNT(DISTINCT user_id) user_count
FROM {{ source('public', 'events') }}
GROUP BY 1
```

For this exercise, there is created a sample transformation at the path `dbt_project/models/total_films.sql`

## Running Transformations

the command to run dbt is `dbt run`. this will run all defined models and create artifacts in the database.

To run the dbt docker container, you should execute the command

```
docker-compose run dbt run
```

## Stopping Docker Containers

from the project root, execute the following to shut of all docker containers:

`docker-compose down`

## Reset the database

In case you want to erase all work and reset the databse,

- stop all running containers
- find & delete the docker db volume

to list volumes execute the following command:

`docker volume ls`

This should output the following:

```
DRIVER    VOLUME NAME
local     dbt-modelling-test_db-data
... (other volumes)
```

## Connecting to the database

You can connect to the database and inspect details from your host machine.

Ensure that the `db` service is running. You can do that by executing

```
docker-compose up -d db
```

The above command will set up the database service if it is not currently running, otherwise it will echo the message `dbt-modelling-test_db_1 is up-to-date`

Using `psql`, you can then connect using the command `psql -h localhost -p 5555 -U dbt -W dvdrental`. Enter `dbt` as password when prompted.

Instead of `psql`, you can use any other database client of your choice and connect with the following properties

```
hostname: localhost (or 127.0.0.1)
port: 5555
username: dbt
database: dvdrental
password: dbt
```
