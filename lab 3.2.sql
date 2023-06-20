#In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.
use sakila;

#Instructions
-- Q1 How many copies of the film Hunchback Impossible exist in the inventory system?

Select COUNT(i.inventory_id)
from sakila.inventory i
where film_id
IN 
(select film_id
from sakila.film f
where f.title="Hunchback Impossible");

-- Q2 List all films whose length is longer than the average of all the films.

SELECT title
from sakila.film
where length >
(select AVG(length)
from sakila.film);

-- Q3 Use subqueries to display all actors who appear in the film Alone Trip.

SELECT a.first_name, a.last_name 
FROM sakila.actor a
where actor_id 
in 
(select fa.actor_id from sakila.film_actor fa
where
film_id
in 
(select film_id from
sakila.film where title="Alone Trip"));

-- Q4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title 
FROM sakila.film
WHERE film_id
in
(SELECT film_id from film_category
WHERE category_id IN
(select category_id
from category 
where name="Family"));

-- Q5 Get name and email from customers from Canada using subqueries. Do the same with joins.
#Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that 
#will help you get the relevant information.

SELECT first_name, last_name from sakila.customer
where address_id in (select address_id from sakila.address
where city_id in(select city_id from sakila.city
where country_id in 
(SELECT country_id from sakila.country
where country='Canada'))); 

SELECT first_name, last_name, email from sakila.customer
join sakila.address 
using (address_id)
join sakila.city
using (city_id)
join sakila.country
using (country_id)
where country= 'Canada'; 

-- Q6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT title 
from sakila.film
where film_id in(select film_id from 
film_actor where actor_id = 
(Select actor_id, COUNT(film_id) from sakila.film_actor
group by actor_id 
order by COUNT(film_id) desc
LIMIT 1)sub1);

-- Q7 Films rented by most profitable customer. You can use the customer table and payment table to find 
#the most profitable customer ie the customer that has made the largest sum of payments

#doesnt work yet

SELECT title
FROM sakila.film
WHERE film_id IN(
SELECT film_id FROM( 
SELECT film_id FROM sakila.inventory i
JOIN sakila.rental r USING(inventory_id)
where customer_id = 
(SELECT customer_id, SUM(amount) as sum_customer 
from sakila.payment 
group by customer_id
Order by sum_customer desc
Limit 1)sub1))sub2);


-- Q8 Customers who spent more than the average payments.-- 
#I'd like to add here that the question isn't clear. I initially assumed that the average payment = AVG(amount) as each amount refers to 1 payment. 
# looking at the solution, I found out that the question is really about which customer's total spending is greater than the average total spending. Then 
# I re-did the question.

SELECT customer_id, sum(amount) from sakila.payment
group by customer_id
HAVING sum(amount) > (SELECT avg(sum_per_customer) from
(SELECT  SUM(amount) as sum_per_customer 
from sakila.payment 
group by customer_id) sub1);