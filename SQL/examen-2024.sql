
--1--
SELECT *
FROM (
SELECT prod_id, cust_gender, amount_sold
FROM dwsales s JOIN dwcustomers c ON s.cust_id = c.cust_id
WHERE cust_year_of_birth < 1950 AND channel_id = 3
)
pivot (sum(amount_sold) FOR cust_gender IN ('F' AS "Muller", 'M' AS "Home"))
ORDER BY prod_id


--2--
SELECT s.promo_id, cust_state_province, cust_city, sum(quantity_sold)
FROM dwsales s JOIN dwpromotions p ON s.promo_id = p.promo_id
	JOIN dwcustomers c ON c.cust_id = s.cust_id
WHERE channel_id = 3 AND promo_category = 'internet'
GROUP BY s.promo_id, ROLLUP (cust_state_province, cust_city)
ORDER BY s.promo_id, cust_state_province, cust_city


--3--
SELECT prod_id, cust_id, amount_sold,
	sum(amount_sold) OVER (PARTITION BY calendar_quarter_number, calendar_year) AS trimestre,
	sum(amount_sold) OVER (ORDER BY calendar_year, calendar_quarter_number) AS hasta_trimestre
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE cust_id >= 100 AND cust_id <= 200
ORDER BY s.time_id


--4--
SELECT s.cust_id, s.time_id AS dia, sum(amount_sold) AS gastado,
	lead(sum(amount_sold), 31, 0) OVER (PARTITION BY s.cust_id ORDER BY s.time_id) AS gastado_31_dias_despues,
	avg(sum(amount_sold)) OVER (PARTITION BY s.cust_id ORDER BY s.time_id
		ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS media_diaria_ultimos_6_dias,
	row_number() OVER (PARTITION BY s.cust_id, calendar_year, calendar_month_number ORDER BY sum(amount_sold) DESC) AS ranking
FROM dwsales s JOIN dwcustomers c ON s.cust_id = c.cust_id
	JOIN dwtimes t ON s.time_id = t.time_id
WHERE cust_year_of_birth >= 1980 AND cust_year_of_birth >= 1989
GROUP BY s.time_id, s.cust_id, calendar_year, calendar_month_number
ORDER BY s.cust_id, s.time_id




SELECT * FROM dwpromotions