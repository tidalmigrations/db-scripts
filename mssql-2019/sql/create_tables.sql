CREATE DATABASE DemoMSSQLDatabase
GO

Use DemoMSSQLDatabase
GO


-- Creation of product table
IF OBJECT_ID('product', 'U') IS NULL
CREATE TABLE product (
  product_id INT NOT NULL,
  name varchar(250) NOT NULL,
  PRIMARY KEY (product_id)
);
GO

-- Creation of country table
IF OBJECT_ID('country', 'U') IS NULL
CREATE TABLE country (
  country_id INT NOT NULL,
  country_name varchar(450) NOT NULL,
  PRIMARY KEY (country_id)
);
GO

-- Creation of city table
IF OBJECT_ID('city', 'U') IS NULL
CREATE TABLE city (
  city_id INT NOT NULL,
  city_name varchar(450) NOT NULL,
  country_id INT NOT NULL,
  PRIMARY KEY (city_id),
  CONSTRAINT fk_country
      FOREIGN KEY(country_id) 
	  REFERENCES country(country_id)
);
GO

-- Creation of store table
IF OBJECT_ID('store', 'U') IS NULL
CREATE TABLE store (
  store_id INT NOT NULL,
  name varchar(250) NOT NULL,
  city_id INT NOT NULL,
  PRIMARY KEY (store_id),
  CONSTRAINT fk_city
      FOREIGN KEY(city_id) 
	  REFERENCES city(city_id)
);
GO

-- Creation of user table
IF OBJECT_ID('users', 'U') IS NULL
CREATE TABLE users (
  user_id INT NOT NULL,
  name varchar(250) NOT NULL,
  PRIMARY KEY (user_id)
);
GO

-- Creation of status_name table
IF OBJECT_ID('status_name', 'U') IS NULL
CREATE TABLE status_name (
  status_name_id INT NOT NULL,
  status_name varchar(450) NOT NULL,
  PRIMARY KEY (status_name_id)
);
GO

-- Creation of sale table
IF OBJECT_ID('sale', 'U') IS NULL
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
GO

-- Creation of order_status table
IF OBJECT_ID('order_status', 'U') IS NULL
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
GO
