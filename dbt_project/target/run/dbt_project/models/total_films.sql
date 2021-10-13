

  create  table "dvdrental"."public_dbt_output"."total_films__dbt_tmp"
  as (
    -- this model creates a table called `total_films` in a pre-configured schema
-- called `dbt_output` and populates it with an integer corresponding to the
-- total number of rows in the table `public.film`
select count(*) total_films
from "dvdrental"."public"."film"
  );