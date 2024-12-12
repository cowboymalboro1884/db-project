SET
	SEARCH_PATH = LOYALTY_PROGRAM,
	PUBLIC;

CREATE SEQUENCE IF NOT EXISTS ACCOUNT_NUMBER_SEQ START
WITH
	100 INCREMENT BY 1;

CREATE SEQUENCE IF NOT EXISTS USER_ACCOUNT_ID_SEQ START
WITH
	100 INCREMENT BY 1;

CREATE SEQUENCE IF NOT EXISTS USER_ID_SEQ START
WITH
	100 INCREMENT BY 1;

-- Create new user
CREATE
OR REPLACE FUNCTION CREATE_NEW_USER (P_NAME TEXT, P_EMAIL TEXT, P_PHONE TEXT) RETURNS VOID AS $$
DECLARE
    v_user_id        TEXT;
    v_account_number TEXT;
    v_account_id     TEXT;
    v_current_time   TIMESTAMP := NOW();
BEGIN
    v_user_id := NEXTVAL('user_id_seq');

    INSERT INTO USER_INFO (USER_ID, NAME, EMAIL, PHONE)
    VALUES (v_user_id, p_name, p_email, p_phone);

    v_account_number := NEXTVAL('account_number_seq');

    INSERT INTO ACCOUNT_INFO (ACCOUNT_NUMBER, BALANCE, CREATED_AT, UPDATED_AT)
    VALUES (v_account_number, 10000, v_current_time, v_current_time);

    v_account_id := NEXTVAL('user_account_id_seq');

    INSERT INTO USER_ACCOUNT (ACCOUNT_ID, USER_ID, ACCOUNT_NUMBER, IS_ACTIVE)
    VALUES (v_account_id, v_user_id, v_account_number, TRUE);

END;
$$ LANGUAGE PLPGSQL;

-- Example
-- SELECT create_new_user( 'Aboba Boba', 'aboba@example.com', '79129357814');
-- Create new transaction
CREATE SEQUENCE IF NOT EXISTS TRANSACTION_ID_SEQ START
WITH
	100 INCREMENT BY 1;

CREATE
OR REPLACE FUNCTION PROCESS_TRANSACTION (
	P_USER_ACCOUNT_ID TEXT,
	P_MERCHANT_ACCOUNT_ID TEXT,
	P_CURRENCY_ID TEXT,
	P_AMOUNT NUMERIC(99, 5),
	P_TIMESTAMP TIMESTAMP
) RETURNS VOID AS $$
DECLARE
    v_transaction_id          TEXT;
    v_user_account_number     TEXT;
    v_user_balance            NUMERIC(100, 5);
    v_merchant_account_number TEXT;
    v_merchant_balance        NUMERIC(100, 5);
    v_currency_rate           NUMERIC(8, 5);
    v_promo                   RECORD;
    v_discount                NUMERIC(99, 5) := 0;
    v_final_amount            NUMERIC(99, 5);
    v_amount_before_promos    NUMERIC(99, 5) := p_amount;

BEGIN
    SELECT EXCHANGE_RATE INTO v_currency_rate FROM CURRENCY WHERE CURRENCY_ID = p_currency_id;
    IF v_currency_rate IS NULL THEN
        RAISE EXCEPTION 'Currency % not found', p_currency_id;
    END IF;

    -- Use promo
    SELECT * INTO v_promo FROM PROMO LIMIT 1;

    IF FOUND THEN
        IF v_promo.TYPE = 'absolute' THEN
            v_discount := v_promo.DISCOUNT;
        ELSIF v_promo.TYPE = 'relative' THEN
            v_discount := p_amount * v_promo.DISCOUNT;
        END IF;
    END IF;

    v_final_amount := p_amount - v_discount;

    IF v_final_amount < 0 THEN
        v_final_amount := 0;
    END IF;

    -- Get user account number
    SELECT UA.ACCOUNT_NUMBER
    INTO v_user_account_number
    FROM USER_ACCOUNT UA
    WHERE UA.ACCOUNT_ID = p_user_account_id;

    -- Check user account
    SELECT BALANCE INTO v_user_balance FROM ACCOUNT_INFO WHERE ACCOUNT_NUMBER = v_user_account_number;

    IF v_user_balance < v_final_amount THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;

    v_user_balance := v_user_balance - v_final_amount;

    UPDATE ACCOUNT_INFO
    SET BALANCE    = v_user_balance,
        UPDATED_AT = p_timestamp
    WHERE ACCOUNT_NUMBER = v_user_account_number;

    -- Get merchant account
    SELECT MA.ACCOUNT_NUMBER
    INTO v_merchant_account_number
    FROM MERCHANT_ACCOUNT MA
    WHERE MA.ACCOUNT_ID = p_merchant_account_id;

    SELECT BALANCE INTO v_merchant_balance FROM ACCOUNT_INFO WHERE ACCOUNT_NUMBER = v_merchant_account_number;

    v_merchant_balance := v_merchant_balance + v_final_amount;

    UPDATE ACCOUNT_INFO
    SET BALANCE    = v_merchant_balance,
        UPDATED_AT = p_timestamp
    WHERE ACCOUNT_NUMBER = v_merchant_account_number;

    v_transaction_id := NEXTVAL('transaction_id_seq');


    -- Insert transaction
    INSERT INTO TRANSACTION (TRANSACTION_ID,
                             USER_ACCOUNT_ID,
                             MERCHANT_ACCOUNT_ID,
                             CURRENCY_ID,
                             AMOUNT,
                             TIMESTAMP,
                             STATUS,
                             AMOUNT_BEFORE_PROMOS)
    VALUES (v_transaction_id,
            p_user_account_id,
            p_merchant_account_id,
            p_currency_id,
            v_final_amount,
            p_timestamp,
            'Completed',
            v_amount_before_promos);

    -- Insert applied promo
    IF FOUND THEN
        INSERT INTO APPLIED_PROMOS (TRANSACTION_ID,
                                    PROMO_ID)
        VALUES (v_transaction_id,
                v_promo.PROMO_ID);
    END IF;

END;
$$ LANGUAGE PLPGSQL;

-- Example
SELECT
	PROCESS_TRANSACTION ('1', '1', 'USD', 100.00, NOW());