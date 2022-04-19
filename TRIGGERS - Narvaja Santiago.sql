-- Tablas necesarias para el funcionamiento de los triggers


-- Tabla que registra las modificaciones de precios en la tabla ARTICULOS y crea un historicos de ellos, almacenando precio anterior y precio nuevo. 
DROP TABLE IF EXISTS `sql_coderhouse_narvaja_santiago`.`bitacora_precio_articulos`;

 CREATE TABLE `sql_coderhouse_narvaja_santiago`.`bitacora_precio_articulos` (
  `id_modificacion` INT NOT NULL  AUTO_INCREMENT,
  `id_articulo` INT NOT NULL,
  `precio_previo` FLOAT,
  `precio_nuevo` FLOAT,
  `fecha_actualizacion` DATE NOT NULL,
  PRIMARY KEY (`id_modificacion`),
  UNIQUE INDEX `id_modificacion_UNIQUE` (`id_modificacion` ASC) VISIBLE);
  
-- Tabla que registrara los movimientos realziados en las tablas ARTICULOS y ARTICULOS_EN_PROMOCION y que tipo de movimiento fueron
DROP TABLE IF EXISTS `sql_coderhouse_narvaja_santiago`.`logs`;

 CREATE TABLE `sql_coderhouse_narvaja_santiago`.`logs` (
  `id` INT NOT NULL  AUTO_INCREMENT,
  `accion` VARCHAR(255) NOT NULL,
  `usuario` VARCHAR(50) NOT NULL,
  `fecha` DATE NOT NULL,
  `id_articulo` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);
  
  
-- Tabla que registra las modificaciones de porcentajes de descuentos y topes maximo de descuento en la tabla ARTICULOS_EN_PROMOCION y crea un historicos de ellos, almacenando valores anteriores y valores nuevos.
DROP TABLE IF EXISTS `sql_coderhouse_narvaja_santiago`.`bitacora_articulos_promo`;

 CREATE TABLE `sql_coderhouse_narvaja_santiago`.`bitacora_articulos_promo` (
  `id_modificacion` INT NOT NULL  AUTO_INCREMENT,
  `id_articulo` INT NOT NULL,
  `monto_desc_previo` FLOAT,
  `monto_desc_nuevo` FLOAT,
  `porce_desc_previo` FLOAT,
  `porce_desc_nuevo` FLOAT,
  `fecha_actualizacion` DATE NOT NULL,
  PRIMARY KEY (`id_modificacion`),
  UNIQUE INDEX `id_modificacion_UNIQUE` (`id_modificacion` ASC) VISIBLE);

-- Incorporamos primero los dos que afectan a la tabla ARTICULOS

-- Antes de realziar el update crea el historico del precio modificado
DROP TRIGGER IF EXISTS `sql_coderhouse_narvaja_santiago`.`articulos_AFTER_UPDATE`;

DELIMITER $$
USE `sql_coderhouse_narvaja_santiago`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sql_coderhouse_narvaja_santiago`.`articulos_AFTER_UPDATE` AFTER UPDATE ON `articulos` FOR EACH ROW
BEGIN
INSERT INTO sql_coderhouse_narvaja_santiago.bitacora_precio_articulos (id_articulo , precio_previo , fecha_actualizacion , precio_nuevo )
VALUES (OLD.id_articulo , OLD.precio , CURDATE() , NEW.precio);
END$$
DELIMITER ;

-- Actua despues de realizar el update y registra quien los hizo, cuando lo hizo, que hizo y sobre que articulo lo hizo
DROP TRIGGER IF EXISTS `sql_coderhouse_narvaja_santiago`.`articulos_BEFORE_UPDATE`;

DELIMITER $$
USE `sql_coderhouse_narvaja_santiago`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sql_coderhouse_narvaja_santiago`.`articulos_BEFORE_UPDATE` BEFORE UPDATE ON `articulos` FOR EACH ROW
BEGIN
INSERT INTO sql_coderhouse_narvaja_santiago.logs (accion , usuario , fecha , id_articulo )
VALUES (CONCAT('Actualizacion articulo: ' , IF(
												NEW.precio <> OLD.precio , 'Precio',
											IF( NEW.id_articulo <> OLD.id_articulo , 'id_articulo',
                                            IF( NEW.grupo <> OLD.grupo , 'Grupo' ,
                                            IF( NEW.familia <> OLD.familia , 'Familia',
                                            IF( NEW.sector <> OLD.sector , 'Sector' ,
                                            IF( NEW.nombre <> OLD.nombre ,'Nombre' , 'Otro'))))))) , USER() , CURDATE() , OLD.id_articulo );  
END$$
DELIMITER ;

-- Incorporamos primero los dos que afectan a la tabla ARTICULOS_EN_PROMOCION

-- -- Antes de realziar el update crea el historico de la informacion modificada. Ya sea porcentaje de descuento, tope de descuento o ambas
DROP TRIGGER IF EXISTS `sql_coderhouse_narvaja_santiago`.`articulos_en_promocion_AFTER_UPDATE`;

DELIMITER $$
USE `sql_coderhouse_narvaja_santiago`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sql_coderhouse_narvaja_santiago`.`articulos_en_promocion_AFTER_UPDATE` AFTER UPDATE ON `articulos_en_promocion` FOR EACH ROW
BEGIN
INSERT INTO sql_coderhouse_narvaja_santiago.bitacora_articulos_promo 
VALUES (NULL , 
		OLD.id_articulo , 
        IF( OLD.tope_descuento = NEW.tope_descuento , NULL , OLD.tope_descuento ) ,
        IF( OLD.tope_descuento = NEW.tope_descuento , NULL , NEW.tope_descuento ), 
        IF( OLD.porcentaje_descuento = NEW.porcentaje_descuento , NULL , OLD.porcentaje_descuento ) ,
        IF( OLD.porcentaje_descuento = NEW.porcentaje_descuento , NULL , NEW.porcentaje_descuento ), 
        CURDATE());
END$$
DELIMITER ;

-- Actua despues de realizar el update y registra quien los hizo, cuando lo hizo, que hizo y sobre que articulo lo hizo
DROP TRIGGER IF EXISTS `sql_coderhouse_narvaja_santiago`.`articulos_en_promocion_BEFORE_UPDATE`;

DELIMITER $$
USE `sql_coderhouse_narvaja_santiago`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sql_coderhouse_narvaja_santiago`.`articulos_en_promocion_BEFORE_UPDATE` BEFORE UPDATE ON `articulos_en_promocion` FOR EACH ROW
BEGIN
INSERT INTO sql_coderhouse_narvaja_santiago.logs (accion , usuario , fecha , id_articulo )
VALUES (CONCAT('Actualizacion promocion articulo: ' , IF(
														(NEW.tope_descuento <> OLD.tope_descuento) AND (NEW.porcentaje_descuento <> OLD.porcentaje_descuento), 'Desccuento y tope',
											IF(	NEW.tope_descuento <> OLD.tope_descuento , 'Tope descuento',
											IF( NEW.porcentaje_descuento <> OLD.porcentaje_descuento , 'Porcentaje descuento' , 
												'Otro')))) , USER() , CURDATE() , OLD.id_articulo );  
END$$
DELIMITER ;
