-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Directory_Aziendale
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Directory_Aziendale` ;

-- -----------------------------------------------------
-- Schema Directory_Aziendale
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Directory_Aziendale` ;
USE `Directory_Aziendale` ;

-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Edificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Edificio` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Edificio` (
  `ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Mansione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Mansione` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Mansione` (
  `Nome Mansione` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome Mansione`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Piano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Piano` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Piano` (
  `Numero Piano` INT NOT NULL,
  `ID Edificio` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Numero Piano`, `ID Edificio`),
  INDEX `ID_Edificio_Piano_idx` (`ID Edificio` ASC) VISIBLE,
  CONSTRAINT `ID_Edificio_Piano`
    FOREIGN KEY (`ID Edificio`)
    REFERENCES `Directory_Aziendale`.`Edificio` (`ID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Ufficio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Ufficio` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Ufficio` (
  `Nome Ufficio` VARCHAR(45) NOT NULL,
  `Numero Piano` INT NOT NULL,
  `ID Edificio` VARCHAR(45) NOT NULL,
  `Mansione Assegnata` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Nome Ufficio`, `Numero Piano`, `ID Edificio`),
  INDEX `ID_Edificio_Ufficio_idx` (`ID Edificio` ASC) VISIBLE,
  INDEX `Numero_Piano_Ufficio_idx` (`Numero Piano` ASC) VISIBLE,
  INDEX `Mansione_Ufficio_idx` (`Mansione Assegnata` ASC) VISIBLE,
  CONSTRAINT `ID_Edificio_Ufficio`
    FOREIGN KEY (`ID Edificio`)
    REFERENCES `Directory_Aziendale`.`Edificio` (`ID`),
  CONSTRAINT `Mansione_Ufficio`
    FOREIGN KEY (`Mansione Assegnata`)
    REFERENCES `Directory_Aziendale`.`Mansione` (`Nome Mansione`),
  CONSTRAINT `Numero_Piano_Ufficio`
    FOREIGN KEY (`Numero Piano`)
    REFERENCES `Directory_Aziendale`.`Piano` (`Numero Piano`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Postazione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Postazione` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Postazione` (
  `Telefono Esterno` VARCHAR(45) NOT NULL,
  `Telefono Interno` VARCHAR(45) NOT NULL,
  `Nome Ufficio` VARCHAR(45) NOT NULL,
  `Numero Piano` INT NOT NULL,
  `ID Edificio` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Telefono Esterno`),
  INDEX `NomeUfficio_Postazione_idx` (`Nome Ufficio` ASC) VISIBLE,
  INDEX `NumeroPiano_Ufficio_idx` (`Numero Piano` ASC) VISIBLE,
  INDEX `IDEdificio_Postazione_idx` (`ID Edificio` ASC) VISIBLE,
  CONSTRAINT `IDEdificio_Postazione`
    FOREIGN KEY (`ID Edificio`)
    REFERENCES `Directory_Aziendale`.`Edificio` (`ID`),
  CONSTRAINT `NomeUfficio_Postazione`
    FOREIGN KEY (`Nome Ufficio`)
    REFERENCES `Directory_Aziendale`.`Ufficio` (`Nome Ufficio`),
  CONSTRAINT `NumeroPiano_Postazione`
    FOREIGN KEY (`Numero Piano`)
    REFERENCES `Directory_Aziendale`.`Piano` (`Numero Piano`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Dipendente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Dipendente` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Dipendente` (
  `Codice Fiscale` VARCHAR(16) NOT NULL,
  `Telefono Esterno` VARCHAR(45) NULL,
  `Data Avvenuto Trasferimento` DATETIME NOT NULL,
  `Mansione Dipendente` VARCHAR(45) NOT NULL COMMENT 'La Mansione assegnata non è in foreign key con il nome mansione della tabella mansione, perchè questo attributo rappresenta la mansione che l\'ufficio amministrativo assegna al dipendente, e in alcune fasi puo\' essere diversa\nda quella dell\'ufficio a cui è assegnato il dipendente. Per esempio se il dipendente è assegnato alla mansione X, e lavora in un ufficio assegnato a tale mansione, il settore amministrativo puo\' arbitrariamente assegnare a questo\ndipendente la mansione Y. A questo punto, e finchè non verrà trasferito, la mansione assegnata al dipendente sarà Y, quella dell\'ufficio in cui si trova sarà ancora X.',
  PRIMARY KEY (`Codice Fiscale`),
  INDEX `Telefono_Postazione_idx` (`Telefono Esterno` ASC) VISIBLE,
  UNIQUE INDEX `Telefono Esterno_UNIQUE` (`Telefono Esterno` ASC) VISIBLE,
  INDEX `Mansione_fk_idx` (`Mansione Dipendente` ASC) VISIBLE,
  CONSTRAINT `Telefono_Postazione`
    FOREIGN KEY (`Telefono Esterno`)
    REFERENCES `Directory_Aziendale`.`Postazione` (`Telefono Esterno`)
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `Mansione_fk`
    FOREIGN KEY (`Mansione Dipendente`)
    REFERENCES `Directory_Aziendale`.`Mansione` (`Nome Mansione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
PACK_KEYS = DEFAULT;


-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Dati Dipendente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Dati Dipendente` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Dati Dipendente` (
  `CF Dipendente` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Data Di Nascita` DATE NOT NULL,
  `Luogo di Nascita` VARCHAR(45) NOT NULL,
  `Città` VARCHAR(45) NOT NULL,
  `Via` VARCHAR(45) NOT NULL,
  `Numero Civico` INT NOT NULL,
  `Email Personale` VARCHAR(45) NOT NULL,
  `Email Aziendale` VARCHAR(45) NULL,
  PRIMARY KEY (`CF Dipendente`),
  CONSTRAINT `CF_Dipendente_Dati`
    FOREIGN KEY (`CF Dipendente`)
    REFERENCES `Directory_Aziendale`.`Dipendente` (`Codice Fiscale`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Trasferimento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Trasferimento` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Trasferimento` (
  `Data Trasferimento` DATETIME NOT NULL,
  `Vecchia Postazione` VARCHAR(45) NOT NULL,
  `Nuova Postazione` VARCHAR(45) NOT NULL,
  `CF Dipendente` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Data Trasferimento`, `Vecchia Postazione`, `Nuova Postazione`),
  INDEX `Vecchia_Postazione_idx` (`Vecchia Postazione` ASC) VISIBLE,
  INDEX `Nuova_Postazione_idx` (`Nuova Postazione` ASC) VISIBLE,
  INDEX `CFDipendente_Trasferito_idx` (`CF Dipendente` ASC) VISIBLE,
  CONSTRAINT `CFDipendente_Trasferito`
    FOREIGN KEY (`CF Dipendente`)
    REFERENCES `Directory_Aziendale`.`Dipendente` (`Codice Fiscale`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,
  CONSTRAINT `Nuova_Postazione`
    FOREIGN KEY (`Nuova Postazione`)
    REFERENCES `Directory_Aziendale`.`Postazione` (`Telefono Esterno`),
  CONSTRAINT `Vecchia_Postazione`
    FOREIGN KEY (`Vecchia Postazione`)
    REFERENCES `Directory_Aziendale`.`Postazione` (`Telefono Esterno`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Directory_Aziendale`.`Utenti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Directory_Aziendale`.`Utenti` ;

CREATE TABLE IF NOT EXISTS `Directory_Aziendale`.`Utenti` (
  `Username` VARCHAR(45) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_0900_ai_ci' NOT NULL,
  `Password` VARCHAR(45) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_0900_ai_ci' NOT NULL,
  `Ruolo` ENUM('dipendente', 'dipendente settore spazi', 'dipendente settore amministrativo') CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_0900_ai_ci' NOT NULL,
  PRIMARY KEY (`Username`))
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
PACK_KEYS = DEFAULT;

USE `Directory_Aziendale` ;

-- -----------------------------------------------------
-- procedure ReportDipendentiTrasferire
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`ReportDipendentiTrasferire`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `ReportDipendentiTrasferire` () 
BEGIN
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

set transaction read only;
set transaction isolation level read committed;

start transaction;
SELECT I.`Nome`, I.`Cognome`, D.`Mansione Dipendente`
FROM Dipendente D join Postazione P on D.`Telefono Esterno` = P.`Telefono Esterno` join Ufficio U on 
U.`Nome Ufficio` = P.`Nome Ufficio` and U.`Numero Piano` = P.`Numero Piano` and U.`ID Edificio` = P.`ID Edificio` join 
`Dati Dipendente` I on I.`CF Dipendente` = D.`Codice Fiscale`
WHERE DATEDIFF(CURRENT_DATE() , D.`Data Avvenuto Trasferimento`) > 180 /* L'intervallo dopo il quale un dipendente
deve essere trasferito è di 6 mesi, approssimato per semplicità a 180 giorni */
OR U.`Mansione Assegnata` <> D.`Mansione Dipendente`
/* Se la mansione del dipendente è stata cambiata, come da specifica, questo deve risultare come da trasferire */
order by I.`Cognome`;
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure DipendentiTrasferireMansione
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`DipendentiTrasferireMansione`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `DipendentiTrasferireMansione` ()

BEGIN
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

set transaction read only;
set transaction isolation level read committed;

start transaction;
SELECT I.`Nome`, I.`Cognome`, D.`Mansione Dipendente`
FROM Dipendente D join Postazione P on D.`Telefono Esterno` = P.`Telefono Esterno` join Ufficio U 
on U.`Nome Ufficio` = P.`Nome Ufficio` and U.`Numero Piano` = P.`Numero Piano` and U.`ID Edificio` = P.`ID Edificio` join 
`Dati Dipendente` I on I.`CF Dipendente` = D.`Codice Fiscale`
WHERE DATEDIFF(CURRENT_DATE() , D.`Data Avvenuto Trasferimento`) > 180 /* L'intervallo dopo il quale un dipendente
deve essere trasferito è di 6 mesi, approssimato per semplicita a 180 giorni */
OR D.`Mansione Dipendente` <> U.`Mansione Assegnata`
GROUP BY D.`Mansione Dipendente`, I.`Nome`, I.`Cognome`;
commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Trasferimento
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`Trasferimento`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `Trasferimento` (in var_cf VARCHAR(16), var_nuovaPostazione VARCHAR(45))
BEGIN
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
set transaction isolation level repeatable read;

start transaction;
UPDATE `Dipendente` SET `Dipendente`.`Telefono Esterno` = var_nuovaPostazione
WHERE `Codice Fiscale` = var_cf;
commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ModificaMansione
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`ModificaMansione`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `ModificaMansione` (in var_cf VARCHAR(16), in var_nuovaMansione VARCHAR(45))
BEGIN
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
set transaction isolation level repeatable read;

start transaction;
UPDATE `Dipendente` SET `Mansione Dipendente` = var_nuovaMansione 
WHERE (`Codice Fiscale` = var_cf);
commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure StoricoUffici
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`StoricoUffici`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `StoricoUffici` (in var_codiceFiscale VARCHAR(16))
BEGIN
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
set transaction read only;
set transaction isolation level read committed;

start transaction;
SELECT distinct U.`Nome Ufficio` AS 'Uffici Occupati'
FROM `Trasferimento` T join `Postazione` P on T.`Vecchia Postazione` = P.`Telefono Esterno`
join `Ufficio` U on P.`Nome Ufficio` = U.`Nome Ufficio`
WHERE T.`CF Dipendente` = var_codiceFiscale

UNION distinct

SELECT distinct U.`Nome Ufficio`
FROM `Trasferimento` T join `Postazione` P on T.`Nuova Postazione` = P.`Telefono Esterno`
join `Ufficio` U on P.`Nome Ufficio` = U.`Nome Ufficio`
WHERE T.`CF Dipendente` = var_codiceFiscale;
commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RicercaDipendenteNome
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`RicercaDipendenteNome`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `RicercaDipendenteNome` (in var_nome VARCHAR(45))

BEGIN
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
set transaction read only;
set transaction isolation level read committed;

start transaction;
SELECT `Nome`, `Cognome`, `Email Personale`, `Email Aziendale`, D.`Telefono Esterno`, `Nome Ufficio`, `Numero Piano`, `ID Edificio`
FROM `Dati Dipendente` I join `Dipendente` D on D.`Codice Fiscale` = I.`CF Dipendente` 
join Postazione P on P.`Telefono Esterno` = D.`Telefono Esterno`
WHERE I.`Nome` = var_nome;
commit;	

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RicercaPostazione
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`RicercaPostazione`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `RicercaPostazione` (in var_telefonoEsterno VARCHAR(45))

BEGIN
declare var_daTrasferire varchar(2);
declare var_dipendente varchar(16);

declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

set transaction read only;
set transaction isolation level repeatable read;

start transaction;
if (not exists (select `Codice Fiscale` FROM `Dipendente` WHERE `Telefono Esterno` = var_telefonoEsterno)) then 
SELECT  P.`Nome Ufficio`, P.`Numero Piano`, P.`ID Edificio`, P.`Telefono Interno`, 'Si' as 'Postazione Libera'
FROM `Postazione` P
WHERE `Telefono Esterno` = var_telefonoEsterno;

else

select `Codice Fiscale` FROM `Dipendente` WHERE `Telefono Esterno` = var_telefonoEsterno into var_dipendente;

if(select var_dipendente in (SELECT D.`Codice Fiscale`
	FROM Dipendente D join Postazione P on D.`Telefono Esterno` = P.`Telefono Esterno` join Ufficio U on 
	U.`Nome Ufficio` = P.`Nome Ufficio` and U.`Numero Piano` = P.`Numero Piano` and U.`ID Edificio` = P.`ID Edificio` 
	WHERE DATEDIFF(CURRENT_DATE() , D.`Data Avvenuto Trasferimento`) > 180 /* L'intervallo dopo il quale un dipendente
	deve essere trasferito è di 6 mesi, approssimato per semplicità a 180 giorni */
	OR U.`Mansione Assegnata` <> D.`Mansione Dipendente`)) then
    select 'Si' into var_daTrasferire;
    else
    select 'No' into var_daTrasferire;
end if;

SELECT I.`Nome`, I.`Cognome`, var_daTrasferire as 'Da Trasferire', I.`Email Personale`, I.`Email Aziendale`, D.`Telefono Esterno`, P.`Nome Ufficio`, P.`Numero Piano`,
P.`ID Edificio`, P.`Telefono Interno`
FROM `Dati Dipendente` I join `Dipendente` D on D.`Codice Fiscale` = I.`CF Dipendente` 
join Postazione P on P.`Telefono Esterno` = D.`Telefono Esterno`
WHERE P.`Telefono Esterno` = var_telefonoEsterno;
end if;
commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure InserisciDipendente
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`InserisciDipendente`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `InserisciDipendente` (in var_cf VARCHAR(45), in var_telPostaz VARCHAR(45), in var_dataTrasf DATETIME,
in var_mansioneAssegnata VARCHAR(45), in var_nome VARCHAR(45), in var_cognome VARCHAR(45), in var_dataNascita DATE, 
in var_luogoNascita VARCHAR(45), in var_citta VARCHAR(45), in var_via VARCHAR(45), in var_civico INT, in var_emailPersonale varchar(45))

BEGIN
declare var_email_aziendale varchar(45);

declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;



INSERT INTO `Directory_Aziendale`.`Dipendente` (`Codice Fiscale`, `Telefono Esterno`, `Data Avvenuto Trasferimento`, `Mansione Dipendente`)
VALUES (var_cf, var_telPostaz, var_dataTrasf, var_mansioneAssegnata);
INSERT INTO `Directory_Aziendale`.`Dati Dipendente` (`CF Dipendente`, `Nome`, `Cognome`, `Data Di Nascita`, `Luogo di Nascita`, `Città`, `Via`, `Numero Civico`, `Email Personale`) 
VALUES (var_cf, var_nome, var_cognome, var_dataNascita, var_luogoNascita, var_citta, var_via, var_civico, var_emailPersonale);



END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure EliminaDipendente
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`EliminaDipendente`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `EliminaDipendente` (in var_cf VARCHAR(16))
BEGIN

DELETE FROM `Dipendente` WHERE (`Codice Fiscale` = var_cf);
/* La tupla in `Dati Dipendente` viene eliminata "on cascade" */

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ScambioPostazione
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`ScambioPostazione`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `ScambioPostazione` (in var_cf1 varchar(16), in var_cf2 varchar(16))
BEGIN
declare var_postD1 varchar(45);
declare var_postD2 varchar (45);
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
set transaction isolation level repeatable read;

start transaction;
 

SELECT `Telefono Esterno` FROM `Dipendente` WHERE `Codice Fiscale` = var_cf1 into var_postD1; 
UPDATE Dipendente SET `Telefono Esterno`= null WHERE `Codice Fiscale` = var_cf1; -- valore temporaneo
SELECT `Telefono Esterno` FROM `Dipendente` WHERE `Codice Fiscale` = var_cf2 into var_postD2;
UPDATE Dipendente SET `Telefono Esterno`= var_postD1 WHERE `Codice Fiscale` = var_cf2; 
UPDATE Dipendente SET `Telefono Esterno`= var_postD2 WHERE `Codice Fiscale` = var_cf1; 

/* Nel caso dello scambio di postazioni, il trigger non può creare la tupla relativa al trasferimento del dipendente
perché l'update avviene passando per il valore NULL, e quindi i valori OLD e NEW nel trigger update non catturano mai
i valori di due postazioni. Per questo la tupla per il dipendente che passa per il valore temporaneo null viene creata
manualmente qui */

INSERT INTO `Trasferimento` (`Data Trasferimento`, `Vecchia Postazione`, `Nuova Postazione`, `CF Dipendente`) 
	VALUES (curdate(), var_postD1 , var_postD2, var_cf1);

commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`login`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `login` (in var_username varchar(45), in var_pass varchar(45), out var_role INT)
BEGIN
	declare var_user_role ENUM('dipendente', 'dipendente settore spazi', 'dipendente settore amministrativo');
    
    select `Ruolo` from `Utenti`
		where `Username` = var_username
        and `Password` = md5(var_pass)
        into var_user_role;
        
	-- See the corresponding enum in the client
		if var_user_role = 'dipendente' then
			set var_role = 1;
		elseif var_user_role = 'dipendente settore spazi' then
			set var_role = 2;
		elseif var_user_role = 'dipendente settore amministrativo' then
			set var_role = 3;
		else
			set var_role = 4;
		end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RicercaDipendenteCognome
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`RicercaDipendenteCognome`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `RicercaDipendenteCognome` (in var_cognome VARCHAR(45))

BEGIN
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

set transaction read only;
set transaction isolation level read committed;

start transaction;
SELECT `Nome`, `Cognome`, `Email Personale`, `Email Aziendale`, D.`Telefono Esterno`, `Nome Ufficio`, `Numero Piano`, `ID Edificio`
FROM `Dati Dipendente` I join `Dipendente` D on D.`Codice Fiscale` = I.`CF Dipendente` 
join Postazione P on P.`Telefono Esterno` = D.`Telefono Esterno`
WHERE I.`Cognome` = var_cognome;
commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RicercaDipNomeCognome
-- -----------------------------------------------------

USE `Directory_Aziendale`;
DROP procedure IF EXISTS `Directory_Aziendale`.`RicercaDipNomeCognome`;

DELIMITER $$
USE `Directory_Aziendale`$$
CREATE PROCEDURE `RicercaDipNomeCognome` (in var_nome VARCHAR(45), in var_cognome VARCHAR(45))
BEGIN
declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
set transaction read only;
set transaction isolation level read committed;

start transaction;
SELECT `Nome`, `Cognome`, `Email Personale`, `Email Aziendale`, P.`Telefono Esterno`, `Nome Ufficio`, `Numero Piano`, `ID Edificio`
FROM `Dati Dipendente` I join `Dipendente` D on D.`Codice Fiscale` = I.`CF Dipendente` 
join Postazione P on P.`Telefono Esterno` = D.`Telefono Esterno`
WHERE I.`Nome` = var_nome and I.`Cognome` = var_cognome;
commit;
END$$

DELIMITER ;
SET SQL_MODE = '';
DROP USER IF EXISTS DipendenteSettoreSpazi;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'DipendenteSettoreSpazi' IDENTIFIED BY 'spazi';

GRANT EXECUTE ON procedure `Directory_Aziendale`.`DipendentiTrasferireMansione` TO 'DipendenteSettoreSpazi';
GRANT EXECUTE ON procedure `Directory_Aziendale`.`Trasferimento` TO 'DipendenteSettoreSpazi';
GRANT EXECUTE ON procedure `Directory_Aziendale`.`ScambioPostazione` TO 'DipendenteSettoreSpazi';
GRANT EXECUTE ON procedure `Directory_Aziendale`.`InserisciDipendente` TO 'DipendenteSettoreSpazi';
GRANT EXECUTE ON procedure `Directory_Aziendale`.`EliminaDipendente` TO 'DipendenteSettoreSpazi';
GRANT EXECUTE ON procedure `Directory_Aziendale`.`RicercaDipendenteNome` TO 'DipendenteSettoreSpazi';
GRANT EXECUTE ON procedure `Directory_Aziendale`.`RicercaPostazione` TO 'DipendenteSettoreSpazi';
SET SQL_MODE = '';
DROP USER IF EXISTS DipendenteSettoreAmministrativo;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'DipendenteSettoreAmministrativo' IDENTIFIED BY 'amministrativo';

GRANT EXECUTE ON procedure `Directory_Aziendale`.`ModificaMansione` TO 'DipendenteSettoreAmministrativo';
GRANT EXECUTE ON procedure `Directory_Aziendale`.`StoricoUffici` TO 'DipendenteSettoreAmministrativo';
SET SQL_MODE = '';
DROP USER IF EXISTS Dipendente;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Dipendente' IDENTIFIED BY 'dipendente';

GRANT EXECUTE ON procedure `Directory_Aziendale`.`RicercaDipendenteNome` TO 'Dipendente';
GRANT EXECUTE ON procedure `Directory_Aziendale`.`RicercaPostazione` TO 'Dipendente';
SET SQL_MODE = '';
DROP USER IF EXISTS login;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'login' IDENTIFIED BY 'login';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `Directory_Aziendale`.`Edificio`
-- -----------------------------------------------------
START TRANSACTION;
USE `Directory_Aziendale`;
INSERT INTO `Directory_Aziendale`.`Edificio` (`ID`) VALUES ('Edificio A');
INSERT INTO `Directory_Aziendale`.`Edificio` (`ID`) VALUES ('Edificio B');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Directory_Aziendale`.`Mansione`
-- -----------------------------------------------------
START TRANSACTION;
USE `Directory_Aziendale`;
INSERT INTO `Directory_Aziendale`.`Mansione` (`Nome Mansione`) VALUES ('Manager');
INSERT INTO `Directory_Aziendale`.`Mansione` (`Nome Mansione`) VALUES ('Sistemista');
INSERT INTO `Directory_Aziendale`.`Mansione` (`Nome Mansione`) VALUES ('Advertising');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Directory_Aziendale`.`Piano`
-- -----------------------------------------------------
START TRANSACTION;
USE `Directory_Aziendale`;
INSERT INTO `Directory_Aziendale`.`Piano` (`Numero Piano`, `ID Edificio`) VALUES (1, 'Edificio A');
INSERT INTO `Directory_Aziendale`.`Piano` (`Numero Piano`, `ID Edificio`) VALUES (2, 'Edificio B');
INSERT INTO `Directory_Aziendale`.`Piano` (`Numero Piano`, `ID Edificio`) VALUES (1, 'Edificio B');
INSERT INTO `Directory_Aziendale`.`Piano` (`Numero Piano`, `ID Edificio`) VALUES (2, 'Edificio A');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Directory_Aziendale`.`Ufficio`
-- -----------------------------------------------------
START TRANSACTION;
USE `Directory_Aziendale`;
INSERT INTO `Directory_Aziendale`.`Ufficio` (`Nome Ufficio`, `Numero Piano`, `ID Edificio`, `Mansione Assegnata`) VALUES ('Sistemi A', 1, 'Edificio A', 'Sistemista');
INSERT INTO `Directory_Aziendale`.`Ufficio` (`Nome Ufficio`, `Numero Piano`, `ID Edificio`, `Mansione Assegnata`) VALUES ('Adv B', 2, 'Edificio B', 'Advertising');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Directory_Aziendale`.`Postazione`
-- -----------------------------------------------------
START TRANSACTION;
USE `Directory_Aziendale`;
INSERT INTO `Directory_Aziendale`.`Postazione` (`Telefono Esterno`, `Telefono Interno`, `Nome Ufficio`, `Numero Piano`, `ID Edificio`) VALUES ('12345', '345', 'Sistemi A', 1, 'Edificio A');
INSERT INTO `Directory_Aziendale`.`Postazione` (`Telefono Esterno`, `Telefono Interno`, `Nome Ufficio`, `Numero Piano`, `ID Edificio`) VALUES ('23456', '456', 'Adv B', 2, 'Edificio B');
INSERT INTO `Directory_Aziendale`.`Postazione` (`Telefono Esterno`, `Telefono Interno`, `Nome Ufficio`, `Numero Piano`, `ID Edificio`) VALUES ('34567', '567', 'Adv B', 2, 'Edificio B');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Directory_Aziendale`.`Utenti`
-- -----------------------------------------------------
START TRANSACTION;
USE `Directory_Aziendale`;
INSERT INTO `Directory_Aziendale`.`Utenti` (`Username`, `Password`, `Ruolo`) VALUES ('dipendente', 'a17a54e46fb7f594574a9d74b36fe68a', 'dipendente');
INSERT INTO `Directory_Aziendale`.`Utenti` (`Username`, `Password`, `Ruolo`) VALUES ('spazi', '57f6e04fa9e62b2d7741edcd181f3a47', 'dipendente settore spazi');
INSERT INTO `Directory_Aziendale`.`Utenti` (`Username`, `Password`, `Ruolo`) VALUES ('amministrativo', '60c1bde27e22fc7a51b783265cb83772', 'dipendente settore amministrativo');

COMMIT;

USE `Directory_Aziendale`;

DELIMITER $$

USE `Directory_Aziendale`$$
DROP TRIGGER IF EXISTS `Directory_Aziendale`.`CheckMansione` $$
USE `Directory_Aziendale`$$
CREATE TRIGGER `Directory_Aziendale`.`CheckMansione` BEFORE UPDATE 
ON `Dipendente` FOR EACH ROW
BEGIN
	
    
if (NEW.`Mansione Dipendente` <> (SELECT `Mansione Assegnata` FROM Postazione P join Ufficio U on 
U.`Nome Ufficio` = P.`Nome Ufficio` and U.`Numero Piano` = P.`Numero Piano` and U.`ID Edificio` = P.`ID Edificio`
WHERE P.`Telefono Esterno` = NEW.`Telefono Esterno`) AND NEW.`Telefono Esterno` <> OLD.`Telefono Esterno`) then
	signal sqlstate '45001' set message_text = 'Mansione del nuovo ufficio incompatibile con mansione dipendente';
end if;

END$$


USE `Directory_Aziendale`$$
DROP TRIGGER IF EXISTS `Directory_Aziendale`.`CheckStorico` $$
USE `Directory_Aziendale`$$
CREATE TRIGGER `Directory_Aziendale`.`CheckStorico` BEFORE UPDATE 
ON `Dipendente` FOR EACH ROW
BEGIN

declare var_todayDate datetime;

SELECT curdate() into var_todayDate;

if (NEW.`Telefono Esterno` <> OLD.`Telefono Esterno` AND NEW.`Telefono Esterno` in (SELECT `Vecchia Postazione`  FROM Trasferimento T join Dipendente D 
on D.`Codice Fiscale` = T.`CF Dipendente`) ) then
	signal sqlstate '45002' set message_text = 'Dipendente già assegnato a questa postazione negli ultimi 3 anni ';
end if;

END$$


USE `Directory_Aziendale`$$
DROP TRIGGER IF EXISTS `Directory_Aziendale`.`CreaTrasferimento` $$
USE `Directory_Aziendale`$$
CREATE TRIGGER `Directory_Aziendale`.`CreaTrasferimento` AFTER UPDATE 
ON `Dipendente` FOR EACH ROW

BEGIN
if(NEW.`Telefono Esterno` <> OLD.`Telefono Esterno`) then
	INSERT INTO `Trasferimento` (`Data Trasferimento`, `Vecchia Postazione`, `Nuova Postazione`, `CF Dipendente`) 
	VALUES (curdate(), OLD.`Telefono Esterno` , NEW.`Telefono Esterno`, NEW.`Codice Fiscale`);
end if;

END$$


USE `Directory_Aziendale`$$
DROP TRIGGER IF EXISTS `Directory_Aziendale`.`RevisioneTrasferimenti` $$
USE `Directory_Aziendale`$$
CREATE TRIGGER `Directory_Aziendale`.`RevisioneTrasferimenti` AFTER UPDATE 
ON `Dipendente` FOR EACH ROW
BEGIN
/* Setto momentaneamente i safe updates a 0 perchè così posso eseguire delle delete senza dover avere una "where" con
un riferimento a una primary key, poiché non mi interessa a chi appartengono i dati della tupla, se appartiene a un
trasferimento di più di 3 anni fa, va comunque eliminata. */
SET SQL_SAFE_UPDATES = 0;

-- Valutare cursore in next version

DELETE FROM `Trasferimento` 
WHERE DATEDIFF(CURDATE(), `Trasferimento`.`Data Trasferimento`) > 1095; /* Se sono passati più di 3 anni 
(ovvero 1095 giorni) il record del trasferimento non serve più, e viene eiliminato */

SET SQL_SAFE_UPDATES = 1;

END$$


USE `Directory_Aziendale`$$
DROP TRIGGER IF EXISTS `Directory_Aziendale`.`UpdateEmailAziendale` $$
USE `Directory_Aziendale`$$
CREATE TRIGGER `UpdateEmailAziendale` AFTER UPDATE ON `Dipendente` FOR EACH ROW
BEGIN

declare var_dominioEmail varchar(45);
declare var_nome varchar(45);
declare var_cognome varchar(45);

if (NEW.`Telefono Esterno` <> OLD.`Telefono Esterno`) then
SELECT P.`Nome Ufficio`
FROM `Dipendente` D join `Postazione` P on P.`Telefono Esterno` = D.`Telefono Esterno`
WHERE D.`Codice Fiscale` = NEW.`Codice Fiscale` INTO var_dominioEmail;

SELECT I.`Nome`, I.`Cognome`
FROM `Dipendente` D join `Dati Dipendente` I on I.`CF Dipendente` = D.`Codice FIscale`
WHERE D.`Codice Fiscale` = NEW.`Codice Fiscale`
INTO var_nome, var_cognome; 


/* Genera un email del tipo nome.cognome00@nomeufficio.it dove '00' è un numero di due cifre randomico, per gestire
eventuali omonimie */
UPDATE `Directory_Aziendale`.`Dati Dipendente` SET `Email Aziendale` =  lower(concat(var_nome, '.', var_cognome,
FLOOR(RAND()*(99-1)+1), '@', replace(var_dominioEmail, ' ', ''), '.it'))
WHERE (`CF Dipendente` = NEW.`Codice Fiscale`);
end if;


END$$


USE `Directory_Aziendale`$$
DROP TRIGGER IF EXISTS `Directory_Aziendale`.`CreaEmailAziendale` $$
USE `Directory_Aziendale`$$
CREATE TRIGGER `Directory_Aziendale`.`CreaEmailAziendale` BEFORE INSERT ON `Dati Dipendente` FOR EACH ROW
BEGIN

declare var_dominioEmail varchar(45);
declare var_email varchar(45);

SELECT P.`Nome Ufficio`
FROM `Dipendente` D join `Postazione` P on P.`Telefono Esterno` = D.`Telefono Esterno`
WHERE D.`Codice Fiscale` = NEW.`CF Dipendente` INTO var_dominioEmail;

/* Genera un email del tipo nome.cognome00@nomeufficio.it dove '00' è un numero di due cifre randomico, per gestire
eventuali omonimie */
SELECT lower(concat(NEW.`Nome`, '.', NEW.`Cognome`,FLOOR(RAND()*(99-1)+1),
 '@', replace(var_dominioEmail, ' ', ''), '.it')) into var_email;
 


SET NEW.`Email Aziendale` = var_email;



END$$


DELIMITER ;
