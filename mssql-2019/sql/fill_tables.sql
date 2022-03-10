USE DemoMSSQLDatabase;
GO

INSERT INTO product (
	product_id,
	name
)
VALUES 
	(1, 'Guitar'),
	(2, 'Piano'),
	(3, 'Drum'),
	(4, 'Bass');
	


INSERT INTO country (
	country_id,
	country_name
)
VALUES 
	(1, 'Canada'),
	(2, 'Australia'),
	(3, 'United States'),
	(4, 'Colombia');



INSERT INTO city (
	city_id,
	city_name,
	country_id
)
VALUES 
	(1, 'Toronto', 1),
	(2, 'Halifax', 1),
	(3, 'Vancouver', 1),
	(4, 'sidney', 2),
	(5, 'melbourne', 2),
	(6, 'Bogota', 4);




INSERT INTO store (
	store_id,
	name,
	city_id	
)
VALUES 
	(1, 'Toronto store', 1),
	(2, 'Halifax store', 1),
	(3, 'Vancouver store', 1),
	(4, 'sidney store', 2),
	(5, 'melbourne store', 2),
	(6, 'Bogota store', 4);




INSERT INTO users (
	user_id,
	name	
)
VALUES 
	(1, 'Freddy Mercury'),
	(2, 'Brian May'),
	(3, 'John Deacon'),
	(4, 'Roger Taylor');


INSERT INTO status_name (
	status_name_id,
	status_name
)
VALUES 
	(1, 'Done'),
	(2, 'Unknown'),
	(3, 'Pending'),
	(4, 'Removed');



INSERT INTO sale (
	sale_id,
	amount,
	date_sale,
	product_id,
	user_id,
	store_id
)
VALUES 
	("283e046b-7e8a-4495-a159-d23b20f02cad", 222, "20220105", 3, 1, 6 ),
	("c48bc5d2-9d5b-4b39-91e3-cdf3147e6502", 502, "20220211", 2, 1, 6 ),
	("12b3aebe-7db6-4e54-a9ce-95de95b97ae3", 31, "20220212", 1, 1, 6 ),
	("b3ec5a17-f3c0-45fc-a97b-7453f1c8ecb9", 106, "20220112", 4, 1, 6 );	



INSERT INTO order_status (
	order_status_id,
	update_at,
	sale_id,
	status_name_id	
)
VALUES 
	("813b254f-3091-4ad4-9fca-69ce14a9c83f", "20220222", "283e046b-7e8a-4495-a159-d23b20f02cad", 3),
	("59efc756-669b-4e60-bc58-3ae49c8166ec", "20220222", "c48bc5d2-9d5b-4b39-91e3-cdf3147e6502", 2),
	("dfbd7ffe-1ca7-410c-bef3-19ca5b74efb5", "20220222", "12b3aebe-7db6-4e54-a9ce-95de95b97ae3", 1),
	("353a26ee-be2c-40b2-b203-632ada77ffdf", "20220222", "b3ec5a17-f3c0-45fc-a97b-7453f1c8ecb9", 4);	
