--Dealership Table
CREATE TABLE dealership(
	dealer_id SERIAL PRIMARY KEY,
	address VARCHAR(100),
	phn_number VARCHAR(15),
	website VARCHAR(150)	
);	


--Sales Person Table
CREATE TABLE sales person(
	sales_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	contact_num VARCHAR(15),
	email VARCHAR(150),
	dealer_id INTEGER NOT NULL
);


--Customer Table
CREATE TABLE customer(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	address VARCHAR(150),
	email VARCHAR(150),
	phone_number VARCHAR(15),
	auto_id INTEGER FOREIGN KEY,	
	invoice_num INTEGER FOREIGN KEY,
	FOREIGN KEY
);

--Mechanics Table
CREATE TABLE mechanics(
	mech_id SERIAL PRIMARY KEY
);

--Parts Table
CREATE TABLE parts(
	upc SERIAL PRIMARY KEY,
	part_num INTEGER NOT NULL,
	part_amt NUMERIC(5,2)
);


--Service Table
CREATE TABLE service(
	auto_id SERIAL PRIMARY KEY,
	mech_id INTEGER NOT NULL,
	labor_cost NUMERIC (6,2),
	upc INTEGER,
	FOREIGN KEY(mech_id) REFERENCES mechanics(mech_id)
	FOREIGN KEY(upc) REFERENCES parts(upc)
);


--Cars Table
CREATE TABLE cars(
	manufacturer_id SERIAL PRIMARY KEY,
	car_amount NUMERIC(6,2),
	make VARCHAR(100),
	model VARCHAR(100),
	_year VARCHAR(5),
	VIN VARCHAR(100),
	customer_id INTEGER NOT NULL FOREIGN KEY,
	sales_id INTEGER NOT NULL FOREIGN KEY,
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
	FOREIGN KEY(sales_id) REFERENCES sales person(sales_id)
);

--Invoice Table
CREATE TABLE invoice(
	invoice_num SERIAL PRIMARY KEY,
	service_date DATE(current date),
	sub_total NUMERIC(6,2),
	total_cost NUMERIC(6,2),
	dealer_id INTEGER NOT NULL FOREIGN KEY,
	manufacturer_id INTEGER NOT NULL FOREIGN KEY,
	FOREIGN KEY(dealer_id) REFERENCES dealership(dealer_id),
	FOREIGN KEY(manufacturer_id) REFERENCES cars(manufacturer_id)
);

-- Add Customer
CREATE OR REPLACE FUNCTION add_customer(
	_customer_id INTEGER,
	_first_name VARCHAR,
	_last_name VARCHAR,
	_email VARCHAR,
	_address VARCHAR,
	_phone_number VARCHAR,
	_last_update TIMESTAMP WITHOUT TIME ZONE
)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO customer(customer_id,first_name,last_name,email,address,phone_number,last_update)
	VALUES(_customer_id,_first_name,_last_name,_email,_address,_phone_number,_last_update);

END;

-- Add invoice
CREATE OR REPLACE PROCEDURE generate_inv(
	invoice_id INTEGER,
	customer_id INTEGER,
	sales_id INTEGER,
	auto_id INTEGER,
	manufacturer_id INTEGER,
	car_amount DECIMAL,
	part_amt DECIMAL,
	labor_cost DECIMAL
	sub_total DECIMAL,
	total_cost DECIMAL
)
AS $$
BEGIN
	--ADD late fee to customer payment amount
	UPDATE invoice
	SET total_cost = car_amount + part_amt + labor_cost
	WHERE customer_id = customer;
	
	--Commit the above statement inside of a transaction (amount)
	COMMIT;
	
END;
$$
LANGUAGE plpgsql;
