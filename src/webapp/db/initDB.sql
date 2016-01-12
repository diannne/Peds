CREATE DATABASE IF NOT EXISTS peds;
GRANT ALL PRIVILEGES ON peds.* TO dpopa@localhost IDENTIFIED BY 'dpopa';

USE peds;

CREATE TABLE IF NOT EXISTS roles (  
  id int(6) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  role varchar(20) NOT NULL
) engine=InnoDB;
  
CREATE TABLE IF NOT EXISTS users (  
  id int(6) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  login varchar(20) NOT NULL,  
  password varchar(20) NOT NULL
) engine=InnoDB;
  
CREATE TABLE IF NOT EXISTS user_roles (  
  user_id int(6) UNSIGNED NOT NULL,  
  role_id int(6) UNSIGNED NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (role_id) REFERENCES roles(id),
  UNIQUE (user_id,role_id)
) engine=InnoDB;

CREATE TABLE IF NOT EXISTS pediatricians (
  id INT(4) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(30),
  last_name VARCHAR(30),
  grade VARCHAR(80),
  specialty_id INT(4) UNSIGNED NOT NULL,
  INDEX(last_name),
  FOREIGN KEY (specialty_id) REFERENCES specialties(id)
) engine=InnoDB;

CREATE TABLE IF NOT EXISTS specialties (
  id INT(4) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80),
  INDEX(name)
) engine=InnoDB;

CREATE TABLE IF NOT EXISTS peds_specialties (
  ped_id INT(4) UNSIGNED NOT NULL,
  specialty_id INT(4) UNSIGNED NOT NULL,
  FOREIGN KEY (ped_id) REFERENCES pediatricians(id),
  FOREIGN KEY (specialty_id) REFERENCES specialties(id),
  UNIQUE (ped_id,specialty_id)
) engine=InnoDB;


CREATE TABLE IF NOT EXISTS parents (
  id INT(4) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(30),
  last_name VARCHAR(30),
  address VARCHAR(255),
  city VARCHAR(80),
  telephone VARCHAR(20),
  email VARCHAR(45) NOT NULL,
  password VARCHAR(45) NOT NULL,
  INDEX(email)
) engine=InnoDB;

CREATE TABLE IF NOT EXISTS kids (
  id INT(4) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30),
  birth_date DATE,
  parent_id INT(4) UNSIGNED NOT NULL,
  INDEX(name),
  FOREIGN KEY (parent_id) REFERENCES parents(id)
) engine=InnoDB;

CREATE TABLE IF NOT EXISTS consultations (
  id INT(4) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  kid_id INT(4) UNSIGNED NOT NULL,
  ped_id INT(4) UNSIGNED NOT NULL,
  visit_date DATE,
  start_time TIME,
  end_time TIME,
  reason VARCHAR(255),
  prescription VARCHAR(255),
  comments VARCHAR(255),
  FOREIGN KEY (kid_id) REFERENCES kids(id),
  FOREIGN KEY (ped_id) REFERENCES pediatricians(id)
) engine=InnoDB;