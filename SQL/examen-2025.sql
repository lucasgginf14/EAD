
--1--
SELECT *
FROM (
	SELECT promo_id, quantity_sold, calendar_year
	FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
	WHERE calendar_quarter_number = 1
)
pivot (sum(quantity_sold) FOR calendar_year IN (1998 AS A1, 1999 AS A2, 2000 AS A3))
ORDER BY promo_id


--2--
SELECT s.promo_id, cust_gender, cust_city, count(*) AS n_ventas
FROM dwsales s JOIN dwpromotions p ON s.promo_id = p.promo_id
	JOIN dwcustomers c ON s.cust_id = c.cust_id
WHERE amount_sold >= 5000 AND promo_category = 'newspaper'
GROUP BY s.promo_id, CUBE (cust_gender, cust_city)
ORDER BY s.promo_id, cust_gender, cust_city


--3--
SELECT prod_id, cust_id, amount_sold AS importe,
	max(amount_sold) OVER (PARTITION BY calendar_month_number, calendar_year) AS max_mes_actual,
	max(amount_sold) OVER (ORDER BY calendar_year, calendar_month_number) AS max_hasta_mes_actual
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE promo_id IN (30, 40, 50, 60)
ORDER BY s.time_id


--4--
SELECT s.prod_id, sum(amount_sold) AS importe, 
	lag(sum(amount_sold), 15, 0) OVER (PARTITION BY s.prod_id 
		ORDER BY s.time_id) AS importe_15_dias_antes,
	avg(sum(amount_sold)) OVER (PARTITION BY s.prod_id ORDER BY s.time_id 
		ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS media_4_dias,
	dense_rank() OVER (PARTITION BY s.prod_id, calendar_year 
		ORDER BY sum(amount_sold) DESC) AS ranking
FROM dwsales s JOIN dwproducts p ON s.prod_id = p.prod_id
	JOIN dwtimes t ON s.time_id = t.time_id
WHERE prod_category = 'Girls'
GROUP BY s.prod_id, s.time_id, calendar_year
ORDER BY s.prod_id, s.time_id






