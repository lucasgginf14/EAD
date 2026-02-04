

--1--
SELECT deptno, job, count(*)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job), ())


--2--
SELECT mgr, deptno, job, count(*)
FROM emp
GROUP BY GROUPING SETS ((deptno, job), mgr)


--3.0--
SELECT job, deptno, mgr, sal, count(*)
FROM emp
GROUP BY (mgr, sal), GROUPING SETS (job, deptno)

--3.1.1--
SELECT job, mgr, count(*)
FROM emp
GROUP BY (job, mgr, sal)

--3.1.2--
SELECT deptno, mgr, sal, count(*)
FROM emp
GROUP BY (deptno, mgr, sal)

--3.2--
SELECT job, deptno, mgr, count(*)
FROM emp
GROUP BY GROUPING SETS ((job, mgr, sal), (deptno, mgr, sal))


--4--
SELECT deptno, count(*)
FROM emp 
GROUP BY ROLLUP(deptno)


--5.1.1--
SELECT job, deptno, mgr, count (*)
FROM emp 
GROUP BY ROLLUP (job, deptno, mgr)

--5.2--
SELECT job, deptno, mgr, count (*)
FROM emp 
GROUP BY GROUPING SETS ((job, deptno, mgr), (job, deptno), job, ())


--6.1--
SELECT job, mgr, count(*)
FROM emp 
GROUP BY CUBE (job, mgr)

--6.2--
SELECT job, mgr, count(*)
FROM emp 
GROUP BY GROUPING SETS ((job, mgr), job, mgr, ())


--7--
SELECT prod_id, channel_id, avg(quantity_sold), sum(amount_sold)
FROM dwsales
GROUP BY GROUPING SETS (prod_id, channel_id, ())
ORDER BY prod_id, channel_id


--8--
SELECT min(s.amount_sold), max(s.amount_sold), 
	avg(s.amount_sold), sum(s.amount_sold), t.time_id, 
	t.day_number_in_month, t.calendar_month_number, t.calendar_quarter_number
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE t.calendar_month_number <= 6
GROUP BY GROUPING SETS (t.time_id, t.day_number_in_month, t.calendar_month_number, t.calendar_quarter_number)


--9--
SELECT count(*), sum(s.amount_sold), t.day_name, t.day_number_in_month
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE s.channel_id = 4
GROUP BY CUBE (t.day_name, t.day_number_in_month)
ORDER BY sum(s.amount_sold) DESC


--10--
SELECT sum(s.quantity_sold), sum(s.amount_sold), t.day_name, t.day_number_in_month
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE s.channel_id = 4
GROUP BY CUBE ((t.day_name, t.day_number_in_week) , t.day_number_in_month)
ORDER BY t.day_number_in_week, t.day_number_in_month


--11--
SELECT min(s.quantity_sold), max(s.quantity_sold), avg(s.quantity_sold), p.prod_category, p.prod_subcategory
FROM dwsales s JOIN dwproducts p ON s.prod_id = p.prod_id
GROUP BY ROLLUP (p.prod_category, p.prod_subcategory)
HAVING sum(s.amount_sold) >= 1000000
ORDER BY prod_category, prod_subcategory


--12--
SELECT cust_id, prod_id, channel_id, sum(amount_sold)
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE t.day_number_in_month <= 15
GROUP BY cust_id, GROUPING SETS (channel_id, prod_id)
ORDER BY cust_id, prod_id, channel_id


--13--
SELECT s.promo_id, t.calendar_year, t.calendar_month_number, sum(s.quantity_sold)
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE s.promo_id != 999
GROUP BY s.promo_id, ROLLUP(t.calendar_year, t.calendar_month_number)
ORDER BY s.promo_id, t.calendar_year, t.calendar_month_number


--14--
SELECT s.promo_id, t.calendar_year, t.calendar_month_number, t.calendar_month_name, sum(s.quantity_sold)
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE s.promo_id  != 999 
GROUP BY s.promo_id, ROLLUP(t.calendar_year, (t.calendar_month_number, t.calendar_month_name))
ORDER BY s.promo_id, t.calendar_year, t.calendar_month_number


--15--
SELECT t.calendar_year, t.calendar_month_number, t.day_number_in_month, count(*)
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id
WHERE s.promo_id != 999
GROUP BY ROLLUP (t.calendar_year, t.calendar_month_number, t.day_number_in_month)
ORDER BY t.calendar_year, t.calendar_month_number, t.day_number_in_month


--16--
SELECT p.country_name, t.calendar_year, t.calendar_month_number, t.day_number_in_month, count(*)
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id 
	JOIN dwcustomers c ON s.cust_id = c.cust_id 
	JOIN dwcountries p ON c.country_id = p.country_id
WHERE s.promo_id != 999 AND p.country_region_id = 52803 
GROUP BY ROLLUP (p.country_name, t.calendar_year, t.calendar_month_number, t.day_number_in_month)
ORDER BY p.country_name, t.calendar_year, t.calendar_month_number, t.day_number_in_month


--17--
SELECT p.country_name, t.calendar_year, t.calendar_month_number, t.day_number_in_month, count(*)
FROM dwsales s JOIN dwtimes t ON s.time_id = t.time_id 
	JOIN dwcustomers c ON s.cust_id = c.cust_id 
	JOIN dwcountries p ON c.country_id = p.country_id
WHERE s.promo_id != 999 AND p.country_region_id = 52803
GROUP BY ROLLUP (p.country_name, t.calendar_year, t.calendar_month_number, t.day_number_in_month)
HAVING t.day_number_in_month IN (1, 15, 30) OR t.day_number_in_month IS NULL
ORDER BY p.country_name, t.calendar_year, t.calendar_month_number, t.day_number_in_month







