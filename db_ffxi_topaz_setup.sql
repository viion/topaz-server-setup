CREATE USER 'topazadmin'@'localhost' IDENTIFIED BY 'topazisawesome';
CREATE DATABASE tpzdb;
USE tpzdb;
GRANT ALL PRIVILEGES ON tpzdb.* TO 'topazadmin'@'localhost';
FLUSH PRIVILEGES;
