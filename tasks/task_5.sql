SET
	SEARCH_PATH = LOYALTY_PROGRAM,
	PUBLIC;

--Table user_info

--There is a new user Alexandr Mahonin(Mr.Credo) with 2 accounts
INSERT INTO
	USER_INFO (USER_ID, NAME, EMAIL, PHONE)
VALUES
	(
		11,
		'Alexandr Mahonin',
		'mr_credo@example.com',
		'70000000000'
	);

INSERT INTO
	ACCOUNT_INFO (ACCOUNT_NUMBER, BALANCE, CREATED_AT, UPDATED_AT)
VALUES
	('1011', 9000.00000, '2025-06-01', '2025-06-01');

INSERT INTO
	USER_ACCOUNT (ACCOUNT_ID, USER_ID, ACCOUNT_NUMBER, IS_ACTIVE)
VALUES
	(11, 11, '1011', TRUE);

INSERT INTO
	ACCOUNT_INFO (ACCOUNT_NUMBER, BALANCE, CREATED_AT, UPDATED_AT)
VALUES
	('1012', 9000.00000, '2025-06-01', '2025-06-01');

INSERT INTO
	USER_ACCOUNT (ACCOUNT_ID, USER_ID, ACCOUNT_NUMBER, IS_ACTIVE)
VALUES
	(12, 11, '1012', TRUE);

--change Mr.Credo email
UPDATE USER_INFO
SET
	EMAIL = 'mr_credo_cool_raper@example.com'
WHERE
	USER_ID = '11';

--users with the longest email
SELECT
	NAME
FROM
	USER_INFO
WHERE
	LENGTH(EMAIL) = (
		SELECT
			MAX(LENGTH(EMAIL))
		FROM
			USER_INFO
	);

--Second Mr.Credo's account was banned
DELETE FROM USER_ACCOUNT
WHERE
	ACCOUNT_NUMBER = '1012';

DELETE FROM ACCOUNT_INFO
WHERE
	ACCOUNT_NUMBER = '1012';


--Table promo

--Wow it's a new promo
INSERT INTO
	PROMO (PROMO_ID, DISCOUNT, NAME, TYPE)
VALUES
	('11', 80.00000, 'WOW SALE', 'relative');

-- all sales with type = relative and discount > average discount
SELECT
	PROMO_ID,
	NAME
FROM
	PROMO
WHERE
	TYPE = 'relative'
	AND DISCOUNT > (
		SELECT
			AVG(DISCOUNT)
		FROM
			PROMO
	);

--The company realized that at this rate they would soon go bankrupt, and reduced the discount
UPDATE PROMO
SET
	DISCOUNT = 40.00000,
	NAME = 'WOW SALE v2.0'
WHERE
	PROMO_ID = '11';

--The promotion is over
DELETE FROM PROMO
WHERE
	PROMO_ID = '11';