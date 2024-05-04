CREATE DATABASE company_name;

USE company_name;

CREATE TABLE customer (
	customer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	last_name VARCHAR(255) NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
    address VARCHAR(255),
	state_id VARCHAR(255),
    zipcode INT,
    birthdate DATE NOT NULL,
    
	UNIQUE INDEX (email)
);

CREATE TABLE orders (
    product_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    payment_type VARCHAR(255),
    customer_id INT,
    customer_card_number INT,

    UNIQUE INDEX (product_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE hr (
    ticket_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    description TEXT NOT NULL,

    UNIQUE INDEX (ticket_number),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES orders(product_id)
);

CREATE TABLE marketing (
    associate_id INT NOT NULL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    description TEXT NOT NULL,

    UNIQUE INDEX (associate_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES orders(product_id)
);