
--1--
SELECT time_id, cust_id, prod_id, 
	count(*) OVER (PARTITION BY time_id) AS "nº ventas" 
FROM dwsales
ORDER BY time_id


--2--
SELECT t.time_id, cust_id, prod_id, 
	count(*) OVER (PARTITION BY t.time_id) AS "nº ventas dia",
	count(*) OVER (PARTITION BY t.calendar_month_number, t.calendar_year) AS "nº ventas mes"
FROM dwsales s JOIN dwtimes t ON s.time_id=t.time_id
ORDER BY time_id


--3--
SELECT t.time_id, cust_id, prod_id, amount_sold,
	avg(amount_sold) OVER (PARTITION BY t.calendar_month_number) AS "ingresos medios mes",
	amount_sold - avg(amount_sold) OVER (PARTITION BY t.calendar_month_number) AS "diferencia"
FROM dwsales s JOIN dwtimes t ON s.time_id=t.time_id
WHERE t.calendar_year = 1998
ORDER BY time_id


--4--
SELECT cust_id, prod_id, time_id, quantity_sold,
	sum(quantity_sold) OVER (PARTITION BY cust_id, prod_id ORDER BY time_id) AS "comprado hasta hoy del producto",
	sum(quantity_sold) OVER (PARTITION BY cust_id, prod_id) AS "comprado en total del producto",
	sum(quantity_sold) OVER (PARTITION BY cust_id) AS "comprado en total"
FROM dwsales
ORDER BY cust_id, prod_id, time_id


--5--
SELECT s.time_id, amount_sold, quantity_sold,
	sum(amount_sold) OVER (ORDER BY t.time_id) AS "acumulado hasta hoy",
	sum(amount_sold) OVER (PARTITION BY t.calendar_month_number, t.calendar_year 
		ORDER BY t.time_id) AS "acumulado hasta hoy este mes",
	max(quantity_sold) OVER (PARTITION BY t.calendar_year) AS "venda más grande del año",
	min(quantity_sold) OVER (PARTITION BY t.calendar_year) AS "venda más pequeña del año"
FROM dwsales s JOIN dwtimes t ON s.time_id=t.time_id
ORDER BY s.time_id


--6--
SELECT s.time_id, t.calendar_quarter_number, amount_sold,
	avg(amount_sold) OVER (PARTITION BY t.calendar_quarter_number) AS "media trimestre",
	avg(amount_sold) OVER (PARTITION BY t.calendar_quarter_number 
		ORDER BY s.time_id) AS "media trimestre hasta hoy",
	amount_sold - avg(amount_sold) OVER (PARTITION BY t.calendar_quarter_number) AS "diferencia con media trimestre"
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE t.calendar_year = 1998
ORDER BY s.time_id


--7--
SELECT DISTINCT(time_id), 
	sum(amount_sold) OVER (PARTITION BY time_id),
	sum(amount_sold) OVER (ORDER BY time_id RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "acumulado"
FROM dwsales
ORDER BY time_id

--7.1--
SELECT time_id, 
	sum(amount_sold),
	sum(sum(amount_sold)) OVER (ORDER BY time_id) AS "acumulado"
FROM dwsales
GROUP BY time_id
ORDER BY time_id


--8--
SELECT DISTINCT t.calendar_month_number, t.calendar_quarter_number, t.calendar_year,
	count (*) OVER (PARTITION BY t.calendar_month_number, t.calendar_year) AS "ventas mes",
	count (*) OVER (ORDER BY t.calendar_year, t.calendar_month_number RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "ventas hasta mes actual",
	count (*) OVER (PARTITION BY t.calendar_quarter_number, t.calendar_year) AS "ventas trimestre",
	count (*) OVER (ORDER BY t.calendar_year, t.calendar_quarter_number RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "ventas hasta trimestre actual",
	count (*) OVER (PARTITION BY t.calendar_year) AS "ventas año",
	count (*) OVER (ORDER BY t.calendar_year RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "ventas hasta año actual"
FROM dwsales s JOIN dwtimes t ON s.time_id=t.time_id
ORDER BY t.calendar_year, t.calendar_quarter_number, t.calendar_month_number

--8.1--
SELECT t.calendar_month_number, t.calendar_quarter_number, t.calendar_year,
	count(*) AS "ventas mes",
	sum(count(*)) OVER (ORDER BY t.calendar_year, t.calendar_month_number) AS "ventas hasta mes actual",
	sum(count(*)) OVER (PARTITION BY t.calendar_quarter_number, t.calendar_year) AS "ventas trimestre",
	sum(count(*)) OVER (ORDER BY t.calendar_year, t.calendar_quarter_number) AS "ventas hasta trimestre actual",
	sum(count(*)) OVER (PARTITION BY t.calendar_year) AS "ventas año",
	sum(count(*)) OVER (ORDER BY t.calendar_year) AS "ventas hasta año actual"
FROM dwsales s JOIN dwtimes t ON s.time_id=t.time_id
GROUP BY calendar_year, calendar_quarter_number, calendar_month_number
ORDER BY t.calendar_year, t.calendar_month_number


--9--
SELECT t.calendar_month_number, t.calendar_year, sum(amount_sold),
	sum(amount_sold) - LAG(sum(amount_sold)) OVER (ORDER BY t.calendar_year, t.calendar_month_number) AS "diferencia mes anterior",
	sum(amount_sold) - LEAD(sum(amount_sold)) OVER (ORDER BY t.calendar_year, t.calendar_month_number) AS "diferencia mes posterior"
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY t.calendar_month_number, t.calendar_year
ORDER BY t.calendar_year, t.calendar_month_number


--10--
SELECT t.calendar_month_number, t.calendar_year, sum(quantity_sold),
	sum(quantity_sold) - LAG(sum(quantity_sold) , 1, 0) OVER (ORDER BY t.calendar_year, t.calendar_month_number) AS "diferencia mes anterior",
	sum(quantity_sold) - LEAD(sum(quantity_sold) , 1, 0) OVER (ORDER BY t.calendar_year, t.calendar_month_number) AS "diferencia mes posterior"
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY t.calendar_month_number, t.calendar_year
ORDER BY t.calendar_year, t.calendar_month_number


--11--
SELECT t.calendar_month_number, t.calendar_year, sum(quantity_sold),
	sum(quantity_sold) - LAG(sum(quantity_sold) , 2, 0) OVER (ORDER BY t.calendar_year, t.calendar_month_number) AS "diferencia mes anterior",
	sum(quantity_sold) - LEAD(sum(quantity_sold) , 2, 0) OVER (ORDER BY t.calendar_year, t.calendar_month_number) AS "diferencia mes posterior"
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY t.calendar_month_number, t.calendar_year
ORDER BY t.calendar_year, t.calendar_month_number


--12--
SELECT  t.calendar_year, t.calendar_month_number, t.day_number_in_month, sum(amount_sold),
	sum(amount_sold) - LAG(sum(amount_sold)) OVER (PARTITION BY t.day_number_in_month, t.calendar_month_number
		ORDER BY t.calendar_year) AS "diferenica año pasado"
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY t.calendar_year, t.calendar_month_number, t.day_number_in_month
ORDER BY t.calendar_year, t.calendar_month_number, t.day_number_in_month


--13--
SELECT t.calendar_month_number, t.calendar_year, COUNT(*) AS ventas_mes,
    avg(count(*)) OVER (PARTITION BY calendar_year) AS media_año,
    RANK() OVER (PARTITION BY calendar_year ORDER BY count(*)) AS ranking
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY t.calendar_month_number, t.calendar_year
ORDER BY calendar_year, calendar_month_number


--14--
SELECT prod_category, prod_subcategory, count(*) AS n_ventas, sum(quantity_sold) AS cantidad,
	RANK() OVER (PARTITION BY prod_category ORDER BY sum(quantity_sold) DESC) AS pos_subcat,
	RANK() OVER (ORDER BY sum(quantity_sold) DESC) AS pos_gen
FROM dwsales s JOIN dwproducts p ON s.prod_id = p.prod_id
GROUP BY prod_subcategory, prod_category
ORDER BY prod_category, pos_subcat


--15--
SELECT p.prod_id AS prod, 
	prod_min_price AS min_precio, 
	calendar_month_number AS mes,
	count(*) AS n_ventas, 
	sum(quantity_sold) AS cantidad, 
	RANK () OVER (PARTITION BY calendar_month_number ORDER BY sum(quantity_sold) DESC)
FROM dwproducts p JOIN dwsales s ON s.prod_id = p.prod_id
	JOIN dwtimes t ON t.time_id = s.time_id
WHERE t.calendar_year = 1998 AND prod_min_price > 200
GROUP BY p.prod_id, prod_min_price, calendar_month_number


--16--
SELECT t.calendar_month_number AS mes, t.calendar_year AS año,
	count(*) AS n_ventas_mes,
	sum(count(*)) OVER (PARTITION BY calendar_year ORDER BY t.calendar_month_number) AS n_hasta_mes,
	avg(count(*)) OVER (PARTITION BY calendar_year ORDER BY t.calendar_month_number 
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS ventas_2_antes,
	avg(count(*)) OVER (PARTITION BY calendar_year ORDER BY t.calendar_month_number 
		ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS ventas_trio
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
	JOIN dwcustomers c ON c.cust_id = s.cust_id
WHERE cust_year_of_birth = 1980
GROUP BY t.calendar_month_number, t.calendar_year


--17--
SELECT calendar_month_number AS mes, calendar_year AS año, 
	sum (amount_sold) AS ingresos,
	sum(sum (amount_sold)) OVER (ORDER BY  calendar_year, calendar_month_number 
		ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS "3_meses_antes"
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY calendar_year, calendar_month_number
ORDER BY calendar_year, calendar_month_number


--18--
SELECT calendar_month_number AS mes, calendar_year AS año, 
	sum (amount_sold) AS ingresos,
	sum(sum (amount_sold)) OVER (ORDER BY  calendar_year, calendar_month_number 
		ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS "3_meses_antes",
	sum (amount_sold) - lag(sum (amount_sold)) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY calendar_year, calendar_month_number
ORDER BY calendar_year, calendar_month_number


--19--
SELECT calendar_month_number AS mes, calendar_year AS año, 
	sum (amount_sold) AS ingresos,
	sum(sum (amount_sold)) OVER (ORDER BY  calendar_year, calendar_month_number 
		ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS "3_meses_antes",
	sum (amount_sold) - lag(sum (amount_sold)) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia,
	sum (amount_sold) - lag(sum (amount_sold), 12) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia_año_pasado
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY calendar_year, calendar_month_number
ORDER BY calendar_year, calendar_month_number


--20--
SELECT calendar_month_number AS mes, calendar_year AS año, 
	sum(amount_sold) AS ingresos,
	sum(sum(amount_sold)) OVER (ORDER BY  calendar_year, calendar_month_number 
		ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS "3_meses_antes",
	sum(amount_sold) - lag(sum(amount_sold)) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia,
	sum(amount_sold) - lag(sum(amount_sold), 12) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia_año_pasado,
	RANK () OVER (ORDER BY sum(amount_sold) DESC) AS clas_año,
	RANK () OVER (PARTITION BY calendar_year ORDER BY sum(amount_sold) DESC),
	RANK () OVER (PARTITION BY calendar_month_number ORDER BY sum(amount_sold) DESC)
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY calendar_year, calendar_month_number
ORDER BY calendar_year, calendar_month_number


--21--
SELECT calendar_month_number AS mes, calendar_year AS año, 
	sum(amount_sold) AS ingresos,
	sum(sum(amount_sold)) OVER (ORDER BY  calendar_year, calendar_month_number 
		ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS "3_meses_antes",
	sum(amount_sold) - lag(sum(amount_sold)) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia,
	sum(amount_sold) - lag(sum(amount_sold), 12) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia_año_pasado,
	RANK () OVER (ORDER BY sum(amount_sold) DESC) AS clas_año,
	RANK () OVER (PARTITION BY calendar_year ORDER BY sum(amount_sold) DESC),
	RANK () OVER (PARTITION BY calendar_month_number ORDER BY sum(amount_sold) DESC),
	max(sum(amount_sold)) OVER () AS max_ingresos,
	max(sum(amount_sold)) OVER (PARTITION BY calendar_year) AS max_hist_mes_por_año,
	max(sum(amount_sold)) OVER (PARTITION BY calendar_year
		ORDER BY calendar_month_number) AS max_hasta_mes_por_año,
	max(sum(amount_sold)) OVER (ORDER BY calendar_year, calendar_month_number
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS max_mes_por_6_meses,
	max(sum(amount_sold)) OVER (ORDER BY calendar_year, calendar_month_number
		ROWS BETWEEN 6 PRECEDING AND 6 FOLLOWING) AS max_mes_por_12_meses,
	max(sum(amount_sold)) OVER (PARTITION BY calendar_month_number) AS max_hist_mes_por_mes,
	max(sum(amount_sold)) OVER (PARTITION BY calendar_month_number
		ORDER BY calendar_year) AS max_hasta_mes_por_mes,
	max(sum(amount_sold)) OVER (ORDER BY calendar_year, calendar_month_number) AS max_mes_hasta_mes
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY calendar_year, calendar_month_number
ORDER BY calendar_year, calendar_month_number


--22--
SELECT calendar_month_name AS mes, calendar_year AS año, 
	sum(amount_sold) AS ingresos,
	sum(sum(amount_sold)) OVER (ORDER BY  calendar_year, calendar_month_number 
		ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS "3_meses_antes",
	sum(amount_sold) - lag(sum(amount_sold)) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia,
	sum(amount_sold) - lag(sum(amount_sold), 12) OVER (
		ORDER BY  calendar_year, calendar_month_number) AS diferencia_año_pasado,
	RANK () OVER (ORDER BY sum(amount_sold) DESC) AS clas_año,
	RANK () OVER (PARTITION BY calendar_year ORDER BY sum(amount_sold) DESC),
	RANK () OVER (PARTITION BY calendar_month_number ORDER BY sum(amount_sold) DESC),
	max(sum(amount_sold)) OVER () AS max_ingresos,
	max(sum(amount_sold)) OVER (PARTITION BY calendar_year) AS max_hist_mes_por_año,
	max(sum(amount_sold)) OVER (PARTITION BY calendar_year
		ORDER BY calendar_month_number) AS max_hasta_mes_por_año,
	max(sum(amount_sold)) OVER (ORDER BY calendar_year, calendar_month_number
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS max_mes_por_6_meses,
	max(sum(amount_sold)) OVER (ORDER BY calendar_year, calendar_month_number
		ROWS BETWEEN 6 PRECEDING AND 6 FOLLOWING) AS max_mes_por_12_meses,
	max(sum(amount_sold)) OVER (PARTITION BY calendar_month_number) AS max_hist_mes_por_mes,
	max(sum(amount_sold)) OVER (PARTITION BY calendar_month_number
		ORDER BY calendar_year) AS max_hasta_mes_por_mes,
	max(sum(amount_sold)) OVER (ORDER BY calendar_year, calendar_month_number) AS max_mes_hasta_mes
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
GROUP BY calendar_year, (calendar_month_number, calendar_month_name)
ORDER BY calendar_year, calendar_month_number


--23--
SELECT *
FROM (
	SELECT s.prod_id AS prod_id, prod_name, calendar_month_number AS mes, sum(quantity_sold) AS cantidad,
		RANK() OVER (PARTITION BY calendar_month_number ORDER BY sum(quantity_sold) DESC) AS ranking
	FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
		JOIN dwproducts p ON p.prod_id = s.prod_id
	WHERE calendar_year = 1998
	GROUP BY s.prod_id, calendar_month_number, prod_name
) 
pivot (sum(ranking) FOR mes IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12))
ORDER BY prod_id


--23.1--
SELECT s.prod_id, prod_name, calendar_month_number, sum(quantity_sold),
	RANK() OVER (PARTITION BY calendar_month_number ORDER BY sum(quantity_sold) DESC)
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
	JOIN dwproducts p ON p.prod_id = s.prod_id
WHERE calendar_year = 1998
GROUP BY s.prod_id, calendar_month_number, prod_name
ORDER BY s.prod_id


--24--
SELECT country_id, cust_city, calendar_month_number AS mes, count(*) AS ventas,
	count(*) - max(count(*)) OVER (PARTITION BY country_id, calendar_month_number) AS ventas_totales
FROM dwtimes t JOIN dwsales s ON t.time_id = s.time_id
	JOIN dwcustomers c ON s.cust_id = c.cust_id
WHERE calendar_year = 1998 AND calendar_quarter_number = 1
GROUP BY country_id, cust_city, ROLLUP(calendar_month_number)
ORDER BY country_id, cust_city, calendar_month_number


--25--
SELECT country_id, cust_city, calendar_year AS año, calendar_month_number AS mes,
	count(*) - max(count(*)) OVER (PARTITION BY country_id, calendar_month_number, calendar_year) AS ventas_totales
FROM dwtimes t JOIN dwsales s ON t.time_id = s.time_id
	JOIN dwcustomers c ON s.cust_id = c.cust_id
WHERE calendar_quarter_number = 1
GROUP BY country_id, cust_city, calendar_year, ROLLUP (calendar_month_number)
ORDER BY country_id, cust_city, calendar_year, mes


--26--
SELECT *
FROM (
	SELECT country_id, cust_city, calendar_year AS año, COALESCE (calendar_month_number, 13) AS mes,
		count(*) - max(count(*)) OVER (PARTITION BY country_id, calendar_month_number, calendar_year) AS ventas_totales
	FROM dwtimes t JOIN dwsales s ON t.time_id = s.time_id
		JOIN dwcustomers c ON s.cust_id = c.cust_id
	WHERE calendar_quarter_number = 1
	GROUP BY country_id, cust_city, calendar_year, ROLLUP (calendar_month_number)
	ORDER BY country_id, cust_city, calendar_year, calendar_month_number
)
PIVOT(avg(ventas_totales) FOR mes IN (1 AS "Xaneiro", 2 AS "Febreiro", 3 AS "Marzo", 13 AS "Trimestre"))
ORDER BY cust_city, año






