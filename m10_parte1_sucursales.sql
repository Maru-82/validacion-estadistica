-- ══════════════════════════════════════════
-- Pre-entrega: Validación estadística del proyecto
-- Parte 1: Analizando la consistencia de ventas — caso guiado
-- Autor: Mónaco_Marina
-- Fecha: 16-10-26
-- ══════════════════════════════════════════

-- Paso 1: Crear la base de datos
-- CREATE DATABASE Tienda_Electronica_DB; --(está comentado para poder correr todo nuevamente sin error; igual en PostgreSQL)
USE Tienda_Electronica_DB; -- Equivalente en PostgreSQL: no requiere USE, se selecciona la base al conectar

-- Paso 2: Drop table por si ya existe
DROP TABLE IF EXISTS ventas_semana;

-- Paso 3: Crear la tabla
CREATE TABLE ventas_semana (
    sucursal VARCHAR(20)   NOT NULL,  -- Nombre de la sucursal (Norte / Sur)
    venta    DECIMAL(10,2) NOT NULL   -- Venta diaria en USD
);

-- Paso 4: Carga de datos (5 días laborales por sucursal)
INSERT INTO ventas_semana (sucursal, venta) VALUES
    ('Norte',  500), ('Norte',  510), ('Norte',  490), ('Norte',  505), ('Norte',  495),
    ('Sur',    100), ('Sur',    900), ('Sur',     50), ('Sur',   1200), ('Sur',    250);

-- Verificación de la carga
SELECT * FROM ventas_semana;

-- Consulta 1 — Media y Rango por sucursal
SELECT
    sucursal,
    AVG(venta)              AS media,  -- Promedio de las ventas diarias
    MAX(venta) - MIN(venta) AS rango   -- Diferencia entre la venta más alta y la más baja
FROM ventas_semana
GROUP BY sucursal;

-- Consulta 2 — Desviación estándar muestral por sucursal
SELECT
    sucursal,
    STDEV(venta) AS desvio_muestral    -- Equivalente en PostgreSQL: STDDEV_SAMP(venta)
FROM ventas_semana
GROUP BY sucursal;