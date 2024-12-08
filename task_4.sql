INSERT INTO
	CURRENCY (CURRENCY_ID, NAME, EXCHANGE_RATE)
VALUES
	('1', 'USD', 1),
	('2', 'EUR', 1.06),
	('3', 'BYN', 0.31),
	('4', 'KZT', 0.002),
	('5', 'RUB', 0.01),
	('7', 'SGD', 0.74),
	('8', 'CNY', 0.14),
	('9', 'JPY', 0.0067),
	('10', 'AMD', 0.0025),
	('11', 'AZN', 0.59),
	('12', 'GEL', 0.36),
	('13', 'UZS', 0.000078),
	('14', 'KGS', 0.012),
	('15', 'TMT', 0.29),
	('16', 'TRY', 0.029);

INSERT INTO
	REGION_INFO (REGION_ID, TAX, ISO_3)
VALUES
	(1, 0.20, 'RUS'),
	(2, 0.18, 'USA'),
	(3, 0.19, 'DEU'),
	(4, 0.21, 'KAZ'),
	(5, 0.15, 'CHN');

INSERT INTO
	MERCHANT_INFO (MERCHANT_ID, NAME, REGION_ID)
VALUES
	('1', 'Russian Retailer', 1),
	('2', 'Moscow Electronics', 1),
	('3', 'St. Petersburg Furniture', 1),
	('4', 'Novosibirsk Grocery', 1),
	('5', 'Yekaterinburg Sports', 1),
	('6', 'Kazan Fashion', 1),
	('7', 'Sochi Delicacies', 1),
	('8', 'Vladivostok Books', 1),
	('9', 'Kaliningrad Tech', 1),
	('10', 'Rostov Auto', 1);

-- Insert into account_info
INSERT INTO
	ACCOUNT_INFO (ACCOUNT_NUMBER, BALANCE, CREATED_AT, UPDATED_AT)
VALUES
	('1001', 1000.00000, '2023-01-01', '2024-01-01'),
	('1002', 2500.00000, '2023-03-01', '2024-03-01'),
	('1003', 1500.00000, '2023-05-01', '2024-05-01'),
	('1004', 3000.00000, '2023-07-01', '2024-07-01'),
	('1005', 4000.00000, '2023-09-01', '2024-09-01'),
	('1006', 5000.00000, '2023-11-01', '2024-11-01'),
	('1007', 6000.00000, '2023-12-01', '2024-12-01'),
	('1008', 7000.00000, '2023-02-01', '2024-02-01'),
	('1009', 8000.00000, '2023-04-01', '2024-04-01'),
	('1010', 9000.00000, '2023-06-01', '2024-06-01');

INSERT INTO
	MERCHANT_ACCOUNT (
		ACCOUNT_ID,
		MERCHANT_ID,
		ACCOUNT_NUMBER,
		IS_ACTIVE
	)
VALUES
	('1', '1', '1001', TRUE),
	('2', '2', '1002', TRUE),
	('3', '3', '1003', TRUE),
	('4', '4', '1004', TRUE),
	('5', '5', '1005', TRUE),
	('6', '6', '1006', TRUE),
	('7', '7', '1007', TRUE),
	('8', '8', '1008', TRUE),
	('9', '9', '1009', TRUE),
	('10', '10', '1010', TRUE);

INSERT INTO
	USER_INFO (USER_ID, NAME, EMAIL, PHONE)
VALUES
	(
		'1',
		'John Doe',
		'johndoe@example.com',
		'79991234567'
	),
	(
		'2',
		'Jane Smith',
		'janesmith@example.com',
		'79997654321'
	),
	(
		'3',
		'Ali Khan',
		'alikhan@example.com',
		'79993456789'
	),
	(
		'4',
		'Elena Ivanova',
		'elenaivanova@example.com',
		'79992345678'
	),
	(
		'5',
		'Michael Brown',
		'michaelbrown@example.com',
		'79994567890'
	),
	(
		'6',
		'Anna Petrova',
		'annapetrova@example.com',
		'79993214567'
	),
	(
		'7',
		'Ivan Sidorov',
		'ivansidorov@example.com',
		'79998765432'
	),
	(
		'8',
		'Olga Smirnova',
		'olgasmirnova@example.com',
		'79992134567'
	),
	(
		'9',
		'Sergey Pavlov',
		'sergeypavlov@example.com',
		'79991023456'
	),
	(
		'10',
		'Natalia Romanova',
		'nataliaromanova@example.com',
		'79992347654'
	);

INSERT INTO
	USER_ACCOUNT (
		ACCOUNT_ID,
		USER_ID,
		ACCOUNT_NUMBER,
		IS_ACTIVE,
		CREATED_AT
	)
VALUES
	('1', '1', '1001', TRUE, '2023-01-01'),
	('2', '2', '1002', TRUE, '2023-03-01'),
	('3', '3', '1003', TRUE, '2023-05-01'),
	('4', '4', '1004', TRUE, '2023-07-01'),
	('5', '5', '1005', TRUE, '2023-09-01'),
	('6', '6', '1006', TRUE, '2023-11-01'),
	('7', '7', '1007', TRUE, '2023-12-01'),
	('8', '8', '1008', TRUE, '2023-02-01'),
	('9', '9', '1009', TRUE, '2023-04-01'),
	('10', '10', '1010', TRUE, '2023-06-01');

INSERT INTO
	PROMO (PROMO_ID, DISCOUNT, NAME, TYPE)
VALUES
	('1', 10.00000, 'New Year Discount', 'absolute'),
	('2', 5.00000, 'Holiday Sale', 'relative'),
	('3', 15.00000, 'Summer Promo', 'absolute'),
	('4', 7.50000, 'Winter Promo', 'relative'),
	('5', 20.00000, 'Black Friday', 'absolute'),
	('6', 12.00000, 'Spring Savings', 'relative'),
	('7', 8.00000, 'Autumn Deals', 'absolute'),
	('8', 18.00000, 'Cyber Monday', 'relative'),
	('9', 25.00000, 'Mega Sale', 'absolute'),
	('10', 30.00000, 'Anniversary Promo', 'relative');

INSERT INTO
	MERCHANT_ACCOUNT_HISTORY (
		ACCOUNT_ID,
		MERCHANT_ID,
		EVENT_TYPE,
		IS_ACTIVE,
		UPDATED_AT
	)
VALUES
	('1', '1', 'created', TRUE, '2024-01-01'),
	('2', '2', 'updated', TRUE, '2024-03-01'),
	('3', '3', 'created', TRUE, '2024-05-01'),
	('4', '4', 'updated', TRUE, '2024-07-01'),
	('5', '5', 'created', TRUE, '2024-09-01'),
	('6', '6', 'created', TRUE, '2024-11-01'),
	('7', '7', 'updated', TRUE, '2024-12-01'),
	('8', '8', 'created', TRUE, '2024-02-01'),
	('9', '9', 'updated', TRUE, '2024-04-01'),
	('10', '10', 'created', TRUE, '2024-06-01');

INSERT INTO
	TRANSACTION (
		TRANSACTION_ID,
		USER_ACCOUNT_ID,
		MERCHANT_ACCOUNT_ID,
		CURRENCY_ID,
		AMOUNT,
		TIMESTAMP,
		STATUS,
		AMOUNT_BEFORE_PROMOS
	)
VALUES
	(
		'1',
		'1',
		'1',
		'5',
		100.00000,
		'2024-01-01',
		'completed',
		120.00000
	),
	(
		'2',
		'2',
		'2',
		'5',
		200.00000,
		'2024-03-01',
		'completed',
		250.00000
	),
	(
		'3',
		'3',
		'3',
		'5',
		300.00000,
		'2024-05-01',
		'completed',
		350.00000
	),
	(
		'4',
		'4',
		'4',
		'5',
		400.00000,
		'2024-07-01',
		'completed',
		500.00000
	),
	(
		'5',
		'5',
		'5',
		'5',
		500.00000,
		'2024-09-01',
		'completed',
		600.00000
	),
	(
		'6',
		'6',
		'6',
		'5',
		600.00000,
		'2024-11-01',
		'completed',
		700.00000
	),
	(
		'7',
		'7',
		'7',
		'5',
		700.00000,
		'2024-12-01',
		'completed',
		800.00000
	),
	(
		'8',
		'8',
		'8',
		'5',
		800.00000,
		'2024-02-01',
		'completed',
		900.00000
	),
	(
		'9',
		'9',
		'9',
		'5',
		900.00000,
		'2024-04-01',
		'completed',
		1000.00000
	),
	(
		'10',
		'10',
		'10',
		'5',
		1000.00000,
		'2024-06-01',
		'completed',
		1100.00000
	);

INSERT INTO
	APPLIED_PROMOS (TRANSACTION_ID, PROMO_ID)
VALUES
	('1', '1'),
	('1', '2'),
	('2', '3'),
	('2', '4'),
	('3', '5'),
	('4', '6'),
	('4', '7'),
	('5', '8'),
	('6', '9'),
	('6', '10'),
	('7', '1'),
	('7', '5'),
	('8', '2'),
	('8', '3'),
	('9', '6'),
	('9', '8'),
	('10', '7'),
	('10', '9');














