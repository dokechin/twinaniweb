SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `twinani`;
USE `twinani` ;

-- -----------------------------------------------------
-- Table `mydb`.`Tweet`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `twinani`.`Tweet` (
  `Item` TEXT NULL ,
  `Author` TEXT NULL ,
  `verb_id` INT NULL ,
  `issued_at` DATETIME NULL ,
  INDEX `Index1` (`verb_id` ASC, `issued_at` ASC) ,
  INDEX `Index2` (`issued_at` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Verb`
-- -----------------------------------------------------
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `twinani` DEFAULT CHARACTER SET utf8 ;
USE `twinani` ;

-- -----------------------------------------------------
-- Table `twinani`.`tweet`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `twinani`.`tweet` (
  `Item` TEXT NULL DEFAULT NULL ,
  `Author` TEXT NULL DEFAULT NULL ,
  `verb_id` INT(11) NULL DEFAULT NULL ,
  `issued_at` DATETIME NULL DEFAULT NULL ,
  INDEX `Index1` (`verb_id` ASC, `issued_at` ASC) ,
  INDEX `Index2` (`issued_at` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `twinani`.`verb`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `twinani`.`verb` (
  `id` INT NOT NULL ,
  `Name` VARCHAR(500) NULL ,
  `regexp` TEXT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


insert into twinani.verb values(1,'îÉÇ§','(îÉ)|(çwì¸)|(íçï∂)');
insert into twinani.verb values(2,'êHÇ◊ÇÈ','êH');
insert into twinani.verb values(3,'ì«Çﬁ','ì«');



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
