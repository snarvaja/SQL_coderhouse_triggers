-- Muestra de las tablas donde impactan los TRIGGERS after y before update a la tabla ARTICULOS
SELECT * FROM sql_coderhouse_narvaja_santiago.bitacora_precio_articulos;
SELECT * FROM sql_coderhouse_narvaja_santiago.logs;

-- Prueba del funcionamiento del TRIGGER en la tabla ARTICULOS. En LOG registra el tipo de cambio y en BITACORA_PRECIO_ARTICULOS el precio anterior y el precio nuevo
UPDATE sql_coderhouse_narvaja_santiago.articulos
SET precio = 217
WHERE id_articulo = 117;

-- Muestra de las tablas donde impactan los TRIGGERS after y before update a la tabla ARTICULOS_EN_PROMOCION
SELECT * FROM sql_coderhouse_narvaja_santiago.bitacora_articulos_promo;
SELECT * FROM sql_coderhouse_narvaja_santiago.logs;

-- Prueba del funcionamineto del TRIGGER solo actualizando el porcentaje de descuento en la tabla ARTICULOS_EN_PROMOCION
UPDATE sql_coderhouse_narvaja_santiago.articulos_en_promocion
SET porcentaje_descuento = 0.3
WHERE id_articulo = 99410;

-- Muestra de que el TRIGGER registra la accion identificando cambio en el porcentaje de descuento y en el tope
UPDATE sql_coderhouse_narvaja_santiago.articulos_en_promocion
SET porcentaje_descuento = 0.3 , tope_descuento = 750
WHERE id_articulo = 469230;
