-- Learning SQL. Generate, Manipulate, and Retrieve Data. 3rd Edition

/*
Page:
75 done
94 done
106 done
119 done
148 done
161 done
185 done
198 done
210 done
219 done
234 done
244 done
260 done
277 done
*/

USE sakila;

-- exercise 1

SELECT actor_id, first_name, last_name
FROM actor
ORDER BY last_name, first_name;

-- exercise 2

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name IN ('WILLIAMS', 'DAVIS');

-- exercise 3

SELECT DISTINCT(customer_id)
FROM rental
WHERE DATE(rental_date) = '2005-07-05';

-- exercise 4

CREATE VIEW exercise_4_table
AS
SELECT payment_id, customer_id, amount, DATE(payment_date) AS payment_date
FROM payment
WHERE payment_id BETWEEN 101 AND 120;

SELECT payment_id, customer_id, amount, DATE(payment_date) AS payment_date
FROM exercise_4_table
WHERE customer_id <> 5 AND (amount > 8 OR DATE(payment_date) = '2005-08-23');

-- payment_id 101, 107

-- exercise 5

SELECT payment_id, customer_id, amount, DATE(payment_date) AS payment_date
FROM exercise_4_table
WHERE customer_id = 5 AND NOT (amount > 6 OR DATE(payment_date) = '2005-06-19');

-- payment_id 108, 110, 111, 112, 113,115, 116, 117, 118, 119, 120

-- exercise 6

SELECT *
FROM payment
WHERE amount IN (1.98, 7.98, 9.98);

-- exercise 7

SELECT *
FROM customer
WHERE last_name LIKE '_A%W%';

-- exercise 8

SELECT c.first_name, c.last_name, a.address, ct.city
FROM customer c
	INNER JOIN address a -- <1>
    ON c.address_id = a.address_id
    INNER JOIN city ct
    ON a.city_id = ct.city_id -- <2>
WHERE a.district = 'California';

-- exercise 9

SELECT f.title, a.first_name, a.last_name
FROM film f
	JOIN film_actor fa
    ON f.film_id = fa.film_id
    JOIN actor a
    ON a.actor_id = fa.actor_id
WHERE a.first_name = 'JOHN';

-- exercise 10

SELECT a1.address addr1, a2.address addr2, a1.city_id
FROM address a1
	INNER JOIN address a2
WHERE a1.city_id = a2.city_id
	AND a1.address_id <> a2.address_id;

-- exercise 11

-- A = {L M N O P}, B = { P Q R S T}

-- result of A union B = {LMNOPQRST}
-- result of A union all B = {LMNOPPQRST}
-- result of A intersect  B = {P}
-- result of A except B = {LMNO}

-- exercise 12

SELECT c.first_name, c.last_name
FROM customer c
WHERE c.last_name LIKE 'L%'
UNION
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.last_name LIKE 'L%';

-- exercise 13

SELECT c.first_name, c.last_name
FROM customer c
WHERE c.last_name LIKE 'L%'
UNION
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.last_name LIKE 'L%'
ORDER BY last_name;

-- exercise 14

SELECT SUBSTRING('Prosze wyodrebnic podciag tekstowy z danego ciagu tekstowego', 19,7) AS exercise_14;

-- exercise 15

SELECT ABS(-25.76823), SIGN(-25.76823), ROUND(-25., 2);

-- exercise 16

SELECT EXTRACT(MONTH FROM CURRENT_DATE) AS current_month;

-- exercise 17

SELECT customer_id, COUNT(*), SUM(amount)
FROM payment 
GROUP BY customer_id
ORDER BY 2 DESC;

-- exercise 18

SELECT customer_id, COUNT(*) AS num_of_payments, SUM(amount) AS total_payment
FROM payment 
GROUP BY customer_id
HAVING num_of_payments >= 40
ORDER BY 2 DESC;

-- exercise 19

SELECT f.title
FROM film f
WHERE f.film_id IN (SELECT fc.film_id
				  FROM film_category fc
					INNER JOIN category c
					ON fc.category_id = c.category_id
				  WHERE c.name = 'Action');

-- exercise 20

SELECT f.title
FROM film f
WHERE EXISTS
		(SELECT 1
         FROM film_category fc
			INNER JOIN category c
            ON fc.category_id = c.category_id
		 WHERE c.name = 'Action'
			AND fc.film_id = f.film_id);

-- exercise 21

SELECT a.actor_id, g.level
FROM 
	(SELECT actor_id, count(*) num_roles
     FROM film_actor
     GROUP BY actor_id) a
INNER JOIN
(SELECT 'Hollywood Star' level, 30 min_roles, 9999 max_roles
UNION ALL
SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
UNION ALL
SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) g
ON a.num_roles BETWEEN g.min_roles AND g.max_roles;

-- exercise 22

SELECT c.customer_id, c.first_name, c.last_name, COUNT(p.amount) AS num_of_payments, SUM(p.amount) AS total_payment
FROM customer c
	LEFT JOIN payment p
	ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY SUM(p.amount) DESC;

-- exercise 23

SELECT c.customer_id, c.first_name, c.last_name, COUNT(p.amount) AS num_of_payments, SUM(p.amount) AS total_payment
FROM payment p
	RIGHT JOIN customer c
	ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY SUM(p.amount) DESC;

-- exercise 24

SELECT a.x + b.x + 1
FROM
	(SELECT 0 x UNION ALL
	SELECT 1 x UNION ALL
	SELECT 2 x UNION ALL
	SELECT 3 x UNION ALL
	SELECT 4 x UNION ALL
	SELECT 5 x UNION ALL
	SELECT 6 x UNION ALL
	SELECT 7 x UNION ALL
	SELECT 8 x UNION ALL
	SELECT 9 x) a
CROSS JOIN 
	(SELECT 0 x UNION ALL
	SELECT 10 x UNION ALL
	SELECT 20 x UNION ALL
	SELECT 30 x UNION ALL
	SELECT 40 x UNION ALL
	SELECT 50 x UNION ALL
	SELECT 60 x UNION ALL
	SELECT 70 x UNION ALL
	SELECT 80 x UNION ALL
	SELECT 90 x) b
    ORDER BY 1;


-- exercise 25

SELECT name,
	CASE name
		WHEN name IN ('English', 'Italian', 'French', 'German') 
			THEN 'latin1'
        WHEN name IN ('Japanese', 'Madarin') 
			THEN 'utf8'
        ELSE 'Unknown'
	END character_set
FROM language;

-- exercise 26

SELECT
	SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) G,
    SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) PG,
    SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END)'NC-17',
    SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) 'PG-13',
    SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) R
FROM film;

-- exercise 27

CREATE TABLE account (
	account_id INT AUTO_INCREMENT,
    avail_balance DECIMAL(10,2),
    last_activity_date DATETIME,
    PRIMARY KEY (account_id)
);

CREATE TABLE transaction (
	txn_id INT AUTO_INCREMENT,
    txn_date DATETIME,
	account_id INT,
    txn_type_cd ENUM('C','D'),
	amount DECIMAL(10,2),
    PRIMARY KEY (txn_id),
    FOREIGN KEY (account_id) REFERENCES account(account_id)
);

INSERT INTO account 
	(account_id, avail_balance, last_activity_date)
VALUES				
	(123, 500, '2019-06-22 15:18:35'), 
	(789, 75, '2019-07-10 20:53:27');

INSERT INTO transaction 
	(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES				
	(1001, '2019-06-01', 123, 'C', 500),
	(1002, '2019-05-15', 789, 'C', 75);

SELECT *
FROM transaction;

START TRANSACTION;

INSERT INTO transaction
	(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES
	(1003, now(), 123, 'D', 50);
    
INSERT INTO transaction
	(txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES
	(1004, now(), 789, 'C', 50);
    
UPDATE account
SET	avail_balance = avail_balance - 50,
	last_activity_date = now()
WHERE account_id = 123;

UPDATE account
SET	avail_balance = avail_balance + 50,
	last_activity_date = now()
WHERE account_id = 789;

COMMIT;

DROP TABLE account;

DROP TABLE transaction;
    
-- exercise 28

ALTER TABLE rental
ADD CONSTRAINT fk_rental_customer_id FOREIGN KEY (customer_id)
REFERENCES customer (customer_id) ON DELETE RESTRICT;

-- exercise 29

CREATE INDEX idx_payment01
ON payment (payment_date, amount);

SELECT customer_id, payment_date, amount
FROM payment
WHERE payment_date > CAST('2019-12-31 23:59:59' AS DATETIME);

-- exercise 30

CREATE VIEW film_category_actor
AS
SELECT f.title, c.name AS category_name, a.first_name, a.last_name
FROM category c
	INNER JOIN film_category fc 
	ON c.category_id = fc.category_id
    INNER JOIN film f
    ON fc.film_id = f.film_id
    INNER JOIN film_actor fa
    ON fa.film_id = f.film_id
    INNER JOIN actor a
    ON a.actor_id = fa.actor_id;
    
SELECT title, category_name, first_name, last_name
FROM film_category_actor
WHERE last_name = 'FAWCETT';
    
-- exercise 31

CREATE VIEW country_payments
AS
SELECT c.country,
	(SELECT SUM(p.amount)
     FROM city ct
		INNER JOIN address a
		ON ct.city_id = a.city_id
		INNER JOIN customer cst
        ON a.address_id = cst.address_id
        INNER JOIN payment p
        ON cst.customer_id = p.customer_id
	 WHERE ct.country_id = c.country_id
     ) tot_payments
FROM country c;

SELECT *
FROM country_payments
ORDER BY tot_payments DESC;

-- exercise 32

SELECT DISTINCT table_name, index_name
FROM information_schema.statistics
WHERE table_schema = 'sakila';

-- exercise 33

SELECT CONCAT('ALTER TABLE ', table_name, ' ADD INDEX ', index_name, ' (',
	group_concat(column_name order by seq_in_index separator ', '), ');'
    ) index_creation_statment
FROM information_schema.statistics
WHERE table_schema = 'sakila'
	AND table_name = 'customer'
GROUP BY table_name, index_name;

-- exercise 34

CREATE TABLE sales_fact (
	year_no INT,
    month_no INT,
    tot_sales BIGINT
);

INSERT INTO sales_fact
VALUES 
		(2019, 1, 19228),
		(2019, 2, 18554),
		(2019, 3, 17325),
		(2019, 4, 13221),
		(2019, 5, 9964),
		(2019, 6, 12658),
		(2019, 7, 14233),
		(2019, 8, 17342),
		(2019, 9, 16853),
		(2019, 10, 17121),
		(2019, 11, 19095),
		(2019, 12, 21436),
		(2020, 1, 20347),
		(2020, 2, 17434),
		(2020, 3, 16225),
		(2020, 4, 13853), 
		(2020, 5, 14589),
        (2020, 6, 13248),
		(2020, 7, 8728),
		(2020, 8, 9378),
		(2020, 9, 11467),
		(2020, 10, 13842),
		(2020, 11, 15742),
		(2020, 12, 18636);
        
SELECT * 
FROM sales_fact;
    
SELECT year_no, month_no, tot_sales, 
	RANK() OVER (ORDER BY tot_sales DESC) sales_rank
FROM sales_fact;

SELECT year_no, month_no, tot_sales, 
	RANK() OVER (PARTITION BY year_no ORDER BY tot_sales DESC) sales_rank
FROM sales_fact;

SELECT year_no, month_no, tot_sales,
	lag(tot_sales) OVER (ORDER BY month_no) prev_month_sales
FROM sales_fact
WHERE year_no = 2020;





