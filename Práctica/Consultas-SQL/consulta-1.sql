
-- 1 --

SELECT *
FROM (
    SELECT u.edad, b.fuente_match
    FROM matches m
    JOIN usuario u ON m.cod_u1 = u.cod OR m.cod_u2 = u.cod
    JOIN basura b ON m.id_basura = b.id_basura
)
PIVOT (
    COUNT(fuente_match)
    FOR fuente_match IN (
    	'recomendados' AS recomendados,
        'comunidades' AS comunidades,
        'sugerencias' AS sugerencias,
        'swipe' AS swipe,
        'eventos' AS eventos,
        'explorar' AS explorar)
)
ORDER BY edad;

