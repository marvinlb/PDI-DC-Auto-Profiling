
CREATE SCHEMA IF NOT EXISTS `profile_app` DEFAULT CHARACTER SET latin1 ;
USE `profile_app` ;

-- -----------------------------------------------------
-- Table `profile_app`.`profile_source_connection`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source_connection` (
  `profile_source_connection_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_connection_name` VARCHAR(75) NOT NULL ,
  `profile_source_tunnel_script` VARCHAR(500) NULL DEFAULT NULL ,
  `profile_source_connection_type` VARCHAR(10) NOT NULL ,
  `w_create_dt` DATETIME NULL DEFAULT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 23:59:59' ,
  PRIMARY KEY (`profile_source_connection_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_source`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source` (
  `profile_source_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_name` VARCHAR(75) NOT NULL ,
  `profile_source_connection` INT(11) NULL DEFAULT NULL ,
  `profile_source_schema_name` VARCHAR(75) NULL DEFAULT NULL ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  PRIMARY KEY (`profile_source_id`) ,
  INDEX `fk_profile_source_1` (`profile_source_connection` ASC) ,
  CONSTRAINT `fk_profile_source_1`
    FOREIGN KEY (`profile_source_connection` )
    REFERENCES `profile_app`.`profile_source_connection` (`profile_source_connection_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_source_table`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source_table` (
  `profile_source_table_pk` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_name` VARCHAR(150) NOT NULL ,
  `profile_source_fk` INT(11) NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`profile_source_table_pk`) ,
  INDEX `profile_source_table_pk` (`profile_source_table_pk` ASC) ,
  INDEX `profile_source_profile_source_table_fk` (`profile_source_fk` ASC) ,
  CONSTRAINT `profile_source_profile_source_table_fk`
    FOREIGN KEY (`profile_source_fk` )
    REFERENCES `profile_app`.`profile_source` (`profile_source_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_sampling_query`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_sampling_query` (
  `profile_sampling_query_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_sampling_query` LONGTEXT NULL DEFAULT NULL ,
  `profile_source_table_fk` INT(11) NOT NULL ,
  `profile_query_type` VARCHAR(75) NULL DEFAULT 'sampling' ,
  `profile_query_source` VARCHAR(15) NULL DEFAULT 'generated' ,
  `table_query_number` INT(11) NULL DEFAULT NULL ,
  `profile_query_sanity_check_query` INT(11) NULL DEFAULT NULL ,
  `w_create_dt` DATETIME NULL DEFAULT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NULL DEFAULT '2037-12-31 11:59:59' ,
  PRIMARY KEY (`profile_sampling_query_id`) ,
  INDEX `fk_profile_sampling_query_1` (`profile_source_table_fk` ASC) ,
  INDEX `fk_profile_sampling_query_2` (`profile_query_sanity_check_query` ASC) ,
  CONSTRAINT `fk_profile_sampling_query_1`
    FOREIGN KEY (`profile_source_table_fk` )
    REFERENCES `profile_app`.`profile_source_table` (`profile_source_table_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_profile_sampling_query_2`
    FOREIGN KEY (`profile_query_sanity_check_query` )
    REFERENCES `profile_app`.`profile_sampling_query` (`profile_sampling_query_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_query_sanity_check_results`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_query_sanity_check_results` (
  `profile_sanity_check_results_pk` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_sampling_query_fk` INT(11) NOT NULL ,
  `profile_sanity_check_result` VARCHAR(4000) NULL DEFAULT NULL ,
  `w_create_dt` DATETIME NULL DEFAULT NULL ,
  `w_update_dt` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NULL DEFAULT '2037-12-31 23:59:59' ,
  PRIMARY KEY (`profile_sanity_check_results_pk`) ,
  INDEX `fk_profile_query_sanity_check_results_1` (`profile_sampling_query_fk` ASC) ,
  CONSTRAINT `fk_profile_query_sanity_check_results_1`
    FOREIGN KEY (`profile_sampling_query_fk` )
    REFERENCES `profile_app`.`profile_sampling_query` (`profile_sampling_query_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_source_table_column`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source_table_column` (
  `profile_source_table_column_pk` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_pk` INT(11) NOT NULL ,
  `profile_source_table_column_name` VARCHAR(150) NOT NULL ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  PRIMARY KEY (`profile_source_table_column_pk`) ,
  INDEX `pst_column_idx1` (`profile_source_table_pk` ASC, `profile_source_table_column_name` ASC) ,
  CONSTRAINT `profile_source_table_profile_source_table_column_fk`
    FOREIGN KEY (`profile_source_table_pk` )
    REFERENCES `profile_app`.`profile_source_table` (`profile_source_table_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_source_table_number_analysis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source_table_number_analysis` (
  `profile_source_table_number_analysis_pk` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_column_pk` INT(11) NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `geometric_mean` DOUBLE(20,10)  ,
  `variance` DOUBLE(20,10)  ,
  `row_count` INT(11) ,
  `null_count` INT(11)  ,
  `lowest_value` DOUBLE(20,10) ,
  `mean_value` DOUBLE(20,10) ,
  `sum_value` DOUBLE(20,10)  ,
  `highest_value` DOUBLE(20,10)  ,
  `standard_deviation` DOUBLE(20,10) ,
  PRIMARY KEY (`profile_source_table_number_analysis_pk`) ,
  INDEX `profile_source_table_number_analysis_pk` (`profile_source_table_number_analysis_pk` ASC) ,
  INDEX `pst_column_pst_number_analysis_fk` (`profile_source_table_column_pk` ASC) ,
  CONSTRAINT `pst_column_pst_number_analysis_fk`
    FOREIGN KEY (`profile_source_table_column_pk` )
    REFERENCES `profile_app`.`profile_source_table_column` (`profile_source_table_column_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_source_table_pattern_finder_analysis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source_table_pattern_finder_analysis` (
  `profile_source_table_pattern_finder_analysis_pk` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_column_pk` INT(11) NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `match_count` INT(11) NULL DEFAULT NULL ,
  `data_sample` VARCHAR(150) NULL DEFAULT NULL ,
  `pattern` VARCHAR(150) NULL DEFAULT NULL ,
  PRIMARY KEY (`profile_source_table_pattern_finder_analysis_pk`) ,
  INDEX `profile_source_table_pattern_finder_analysis_pk` (`profile_source_table_pattern_finder_analysis_pk` ASC) ,
  INDEX `pst_column_pst_pattern_finder_analysis_fk` (`profile_source_table_column_pk` ASC) ,
  CONSTRAINT `pst_column_pst_pattern_finder_analysis_fk`
    FOREIGN KEY (`profile_source_table_column_pk` )
    REFERENCES `profile_app`.`profile_source_table_column` (`profile_source_table_column_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_source_table_string_analysis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source_table_string_analysis` (
  `profile_source_table_string_analysis_pk` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_column_pk` INT(11) NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `max_character_count` INT(11),
  `word_count` INT(11) ,
  `entirely_uppercase_count` INT(11),
  `min_character_count` INT(11) ,
  `max_word_count` INT(11),
  `diacritic_character_count` INT(11),
  `row_count` INT(11),
  `min_word_count` INT(11),
  `digit_character_count` INT(11),
  `entirely_lowercase_count` INT(11),
  `non_letter_character_count` INT(11),
  `total_character_count` INT(11),
  `uppercase_character_count` INT(11),
  `null_count` INT(11),
  `lowercase_character_count` INT(11),
  `avg_character_count` INT(11) ,
  PRIMARY KEY (`profile_source_table_string_analysis_pk`) ,
  INDEX `profile_source_table_string_analysis_pk` (`profile_source_table_string_analysis_pk` ASC) ,
  INDEX `pst_column_pst_string_analysis_fk` (`profile_source_table_column_pk` ASC) ,
  CONSTRAINT `pst_column_pst_string_analysis_fk`
    FOREIGN KEY (`profile_source_table_column_pk` )
    REFERENCES `profile_app`.`profile_source_table_column` (`profile_source_table_column_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_source_table_value_distribution_analysis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source_table_value_distribution_analysis` (
  `profile_source_table_value_distribution_analysis_pk` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_column_pk` INT(11) NOT NULL ,
  `w_create_dt` DATETIME NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `value_name` VARCHAR(150) ,
  `value_count` INT(11) ,
  PRIMARY KEY (`profile_source_table_value_distribution_analysis_pk`) ,
  INDEX `profile_source_table_value_distribution_analysis_pk` (`profile_source_table_value_distribution_analysis_pk` ASC) ,
  INDEX `pst_column_pst_value_distribution_analysis_fk` (`profile_source_table_column_pk` ASC) ,
  CONSTRAINT `pst_column_pst_value_distribution_analysis_fk`
    FOREIGN KEY (`profile_source_table_column_pk` )
    REFERENCES `profile_app`.`profile_source_table_column` (`profile_source_table_column_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`profile_source_table_value_distribution_summary_analysis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`profile_source_table_value_distribution_summary_analysis` (
  `profile_source_table_value_distribution_summary_analysis_pk` INT(11) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_column_pk` INT(11) NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `null_count` INT(11)  ,
  `unique_count` INT(11) ,
  `distinct_count` INT(11) ,
  PRIMARY KEY (`profile_source_table_value_distribution_summary_analysis_pk`) ,
  INDEX `profile_source_table_value_distribution_summary_analysis_pk` (`profile_source_table_value_distribution_summary_analysis_pk` ASC) ,
  INDEX `pst_column_pst_value_distribution_summary_analysis_fk` (`profile_source_table_column_pk` ASC) ,
  CONSTRAINT `pst_column_pst_value_distribution_summary_analysis_fk`
    FOREIGN KEY (`profile_source_table_column_pk` )
    REFERENCES `profile_app`.`profile_source_table_column` (`profile_source_table_column_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`pst_character_distribution_analysis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`pst_character_distribution_analysis` (
  `pst_character_distribution_analysis_pk` BIGINT(20) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_column_pk` INT(11) NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `arabic` INT(11) ,
  `armenian` INT(11) ,
  `bengali` INT(11) ,
  `cyrillic` INT(11),
  `devanagari` INT(11) ,
  `georgian` INT(11) ,
  `greek` INT(11) ,
  `gujarati` INT(11) ,
  `gurmukhi` INT(11) ,
  `han` INT(11) ,
  `hangul` INT(11) ,
  `hebrew` INT(11) ,
  `hiragana` INT(11) ,
  `kannada` INT(11) ,
  `katakana` INT(11) ,
  `latin_ascii` INT(11) ,
  `latin_non_ascii` INT(11) ,
  `malayalam` INT(11) ,
  `oriya` INT(11) ,
  `syriac` INT(11) ,
  `tamil` INT(11) ,
  `telugu` INT(11) ,
  `thaana` INT(11) ,
  `thai` INT(11) ,
  PRIMARY KEY (`pst_character_distribution_analysis_pk`) ,
  INDEX `pst_character_distribution_analysis_pk` (`pst_character_distribution_analysis_pk` ASC) ,
  INDEX `pst_column_pst_character_distribution_analysis_fk` (`profile_source_table_column_pk` ASC) ,
  CONSTRAINT `pst_column_pst_character_distribution_analysis_fk`
    FOREIGN KEY (`profile_source_table_column_pk` )
    REFERENCES `profile_app`.`profile_source_table_column` (`profile_source_table_column_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`pst_datetime_analysis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`pst_datetime_analysis` (
  `pst_datetime_analysis_pk` BIGINT(20) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_column_pk` INT(11) NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `row_count` INT(11) ,
  `null_count` INT(11) ,
  `highest_date` VARCHAR(10) ,
  `lowest_date` VARCHAR(10) ,
  `highest_time` VARCHAR(8) ,
  `lowest_time` VARCHAR(8) ,
  PRIMARY KEY (`pst_datetime_analysis_pk`) ,
  INDEX `pst_column_pst_datetime_analysis_fk` (`profile_source_table_column_pk` ASC) ,
  CONSTRAINT `pst_column_pst_datetime_analysis_fk`
    FOREIGN KEY (`profile_source_table_column_pk` )
    REFERENCES `profile_app`.`profile_source_table_column` (`profile_source_table_column_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `profile_app`.`pst_weekday_distribution_analysis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `profile_app`.`pst_weekday_distribution_analysis` (
  `pst_weekday_distribution_analysis_pk` BIGINT(20) NOT NULL AUTO_INCREMENT ,
  `profile_source_table_column_pk` INT(11) NOT NULL ,
  `dw_revision` INT(11) NOT NULL DEFAULT '1' ,
  `w_create_dt` DATETIME NOT NULL ,
  `w_update_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `w_end_dt` DATETIME NOT NULL DEFAULT '2037-12-31 11:59:59' ,
  `sunday_count` INT(11) ,
  `monday_count` INT(11) ,
  `tuesday_count` INT(11) ,
  `wednesday_count` INT(11) ,
  `thursday_count` INT(11) ,
  `friday_count` INT(11) L ,
  `saturday_count` INT(11)  ,
  PRIMARY KEY (`pst_weekday_distribution_analysis_pk`) ,
  INDEX `pst_column_pst_weekday_distribution_analysis_fk` (`profile_source_table_column_pk` ASC) ,
  CONSTRAINT `pst_column_pst_weekday_distribution_analysis_fk`
    FOREIGN KEY (`profile_source_table_column_pk` )
    REFERENCES `profile_app`.`profile_source_table_column` (`profile_source_table_column_pk` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

