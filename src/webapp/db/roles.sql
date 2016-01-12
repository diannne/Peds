CREATE DATABASE IF NOT EXISTS peds_roles;
USE peds_roles;

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
