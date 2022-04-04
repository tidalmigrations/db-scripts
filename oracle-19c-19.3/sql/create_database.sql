CREATE TABLE product (
  product_id INT NOT NULL,
  name varchar(250) NOT NULL,
  PRIMARY KEY (product_id)
);

CREATE TABLE country (
  country_id INT NOT NULL,
  country_name varchar(450) NOT NULL,
  PRIMARY KEY (country_id)
);

CREATE TABLE city (
  city_id INT NOT NULL,
  city_name varchar(450) NOT NULL,
  country_id INT NOT NULL,
  PRIMARY KEY (city_id),
  CONSTRAINT fk_country
      FOREIGN KEY(country_id) 
	  REFERENCES country(country_id)
);

CREATE TABLE store (
  store_id INT NOT NULL,
  name varchar(250) NOT NULL,
  city_id INT NOT NULL,
  PRIMARY KEY (store_id),
  CONSTRAINT fk_city
      FOREIGN KEY(city_id) 
	  REFERENCES city(city_id)
);

CREATE TABLE users (
  user_id INT NOT NULL,
  name varchar(250) NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE status_name (
  status_name_id INT NOT NULL,
  status_name varchar(450) NOT NULL,
  PRIMARY KEY (status_name_id)
);

CREATE TABLE sale (
  sale_id varchar(200) NOT NULL,
  amount DECIMAL(20,3) NOT NULL,
  date_sale DATE NOT NULL,
  product_id INT NOT NULL,
  user_id INT NOT NULL,
  store_id INT NOT NULL, 
  PRIMARY KEY (sale_id),
  CONSTRAINT fk_product
      FOREIGN KEY(product_id) 
	  REFERENCES product(product_id),
  CONSTRAINT fk_user
      FOREIGN KEY(user_id) 
	  REFERENCES users(user_id),
  CONSTRAINT fk_store
      FOREIGN KEY(store_id) 
	  REFERENCES store(store_id)	  
);

CREATE TABLE order_status (
  order_status_id varchar(200) NOT NULL,
  update_at DATE NOT NULL,
  sale_id varchar(200) NOT NULL,
  status_name_id INT NOT NULL,
  PRIMARY KEY (order_status_id),
  CONSTRAINT fk_sale
      FOREIGN KEY(sale_id) 
	  REFERENCES sale(sale_id),
  CONSTRAINT fk_status_name
      FOREIGN KEY(status_name_id) 
	  REFERENCES status_name(status_name_id)  
);

INSERT ALL
  INTO product (product_id, name) VALUES (1, 'Guitar')
  INTO product (product_id, name) VALUES (2, 'Piano')
  INTO product (product_id, name) VALUES (4, 'Bass')
SELECT * FROM dual;

INSERT ALL
  INTO country (country_id, country_name) VALUES (1, 'Canada')
  INTO country (country_id, country_name) VALUES (2, 'Australia')
  INTO country (country_id, country_name) VALUES (3, 'United States')
  INTO country (country_id, country_name) VALUES (4, 'Colombia')
SELECT * FROM dual;

INSERT ALL
  INTO city (city_id, city_name, country_id) VALUES (1, 'Toronto', 1)
  INTO city (city_id, city_name, country_id) VALUES (2, 'Halifax', 1)
  INTO city (city_id, city_name, country_id) VALUES (3, 'Vancouver', 1)
  INTO city (city_id, city_name, country_id) VALUES (4, 'Sydney', 2)
  INTO city (city_id, city_name, country_id) VALUES (5, 'Melbourne', 2)
  INTO city (city_id, city_name, country_id) VALUES (6, 'Bogota', 4)
SELECT * FROM dual;

INSERT ALL
  INTO store (store_id, name, city_id) VALUES (1, 'Toronto store', 1)
  INTO store (store_id, name, city_id) VALUES (2, 'Halifax store', 1)
  INTO store (store_id, name, city_id) VALUES (3, 'Vancouver store', 1)
  INTO store (store_id, name, city_id) VALUES (4, 'Sydney store', 2)
  INTO store (store_id, name, city_id) VALUES (5, 'Melbourne store', 2)
  INTO store (store_id, name, city_id) VALUES (6, 'Bogota store', 4)
SELECT * FROM dual;

INSERT ALL
  INTO users (user_id, name) VALUES (1, 'Freddy Mercury')
  INTO users (user_id, name) VALUES (2, 'Brian May')
  INTO users (user_id, name) VALUES (3, 'John Deacon')
  INTO users (user_id, name) VALUES (4, 'Roger Taylor')
SELECT * FROM dual;

INSERT ALL
  INTO status_name (status_name_id, status_name) VALUES (1, 'Done')
  INTO status_name (status_name_id, status_name) VALUES (2, 'Unknown')
  INTO status_name (status_name_id, status_name) VALUES (3, 'Pending')
  INTO status_name (status_name_id, status_name) VALUES (4, 'Removed')
SELECT * FROM dual;

CREATE USER tidal identified by "Dev12345";
GRANT CREATE SESSION to tidal;
GRANT select_catalog_role to tidal;
