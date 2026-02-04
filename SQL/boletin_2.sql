
--1--
SELECT *
FROM (SELECT calendar_month_number, calendar_year 
	FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id)
pivot (count(*) FOR calendar_month_number IN (1, 2, 3))


--2--
SELECT *
FROM (SELECT calendar_month_number, calendar_year 
	FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id)
pivot (count(*) FOR calendar_month_number 
	IN (1 AS "Xaneiro", 2 AS "Febreiro", 3 AS "Marzo"))


--3--
SELECT *
FROM (SELECT calendar_quarter_number, calendar_year, amount_sold
	FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id)
pivot (avg(amount_sold) FOR calendar_quarter_number IN (1, 2, 3, 4))
ORDER BY calendar_year


--4--
SELECT *
FROM (SELECT calendar_quarter_number, calendar_year, amount_sold, quantity_sold
	FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id)
pivot (avg(amount_sold) media, sum(quantity_sold) cantidad 
	FOR calendar_quarter_number IN (1, 2, 3, 4))
ORDER BY calendar_year


--5--
SELECT *
FROM (SELECT c.cust_id, cust_first_name, cust_last_name, calendar_year, amount_sold
	FROM dwcustomers c JOIN dwsales s ON c.cust_id = s.cust_id
		JOIN dwtimes t ON s.time_id = t.time_id)
pivot (sum(amount_sold) FOR calendar_year IN (1998, 1999, 2000))
ORDER BY cust_last_name, cust_first_name


--6--
SELECT *
FROM (SELECT prod_category, quantity_sold, promo_category
	FROM dwproducts p JOIN dwsales s ON p.prod_id = s.prod_id
		JOIN dwpromotions pr ON pr.promo_id = s.promo_id
	WHERE amount_sold >= 1000 AND s.promo_id != 999)
pivot (avg(quantity_sold) FOR prod_category IN ('Women', 'Men', 'Girls', 'Boys'))
ORDER BY promo_category


--7--
SELECT cust_id, cust_first_name, cust_last_name, ano1, ano2, ano3, (ano1+ano2+ano3) total
FROM (SELECT c.cust_id, cust_first_name, cust_last_name, calendar_year, amount_sold
	FROM dwcustomers c JOIN dwsales s ON c.cust_id = s.cust_id
		JOIN dwtimes t ON s.time_id = t.time_id)
pivot (sum(amount_sold) FOR calendar_year IN (1998 ano1, 1999 ano2, 2000 ano3))
ORDER BY cust_last_name, cust_first_name


