-- ══════════════════════════════════════════
-- Pre-entrega: Validación estadística del proyecto
-- Parte 2: Validación estadística de RetailPro
-- Consultas 3 y 4 del paso a paso guiado (las consultas 1 y 2 están en m10_parte1_sucursales.sql)
-- Autor: Mónaco_Marina
-- Fecha: 16-10-26
-- ══════════════════════════════════════════

USE Ventas_Tech_DB; -- Equivalente en PostgreSQL: no requiere USE, se selecciona la base al conectar

-- Consulta 3 — Mediana vs. media
SELECT DISTINCT
    AVG(total_venta) OVER ()                                         AS media,    -- Promedio del total de venta
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_venta) OVER () AS mediana   -- Valor central del total de venta
FROM ventas;
-- Equivalente en PostgreSQL:
-- SELECT AVG(total_venta) AS media,
--        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_venta) AS mediana
-- FROM ventas;

-- Consulta 4 — Outliers con el método IQR: cuartiles y límites
WITH q AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_venta) OVER () AS q1,  -- Primer cuartil
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_venta) OVER () AS q3   -- Tercer cuartil
    FROM ventas
)
SELECT
    q1, q3,
    (q3 - q1)            AS iqr,              -- Rango intercuartílico
    q1 - 1.5 * (q3 - q1) AS limite_inferior,  -- Por debajo de este valor, outlier inferior
    q3 + 1.5 * (q3 - q1) AS limite_superior   -- Por encima de este valor, outlier superior
FROM q;
-- Equivalente en PostgreSQL: igual, pero sin DISTINCT ni OVER () en el CTE

-- Consulta 4 — Outliers con el método IQR: listado de registros fuera de los límites
WITH q AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_venta) OVER () AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_venta) OVER () AS q3
    FROM ventas
)
SELECT v.*
FROM ventas v, q
WHERE v.total_venta < q.q1 - 1.5 * (q.q3 - q.q1)
   OR v.total_venta > q.q3 + 1.5 * (q.q3 - q.q1);
-- Equivalente en PostgreSQL: igual, pero sin DISTINCT ni OVER () en el CTE