-- Показывает статистику по пользователям - количество транзакций, количесто потраченных денег, количество сэкономленных денег и средний размер транзакции 

CREATE OR REPLACE VIEW user_transaction_summary AS
SELECT
    ui.USER_ID,
    ui.NAME,
    COUNT(t.TRANSACTION_ID) AS total_transactions,
    SUM(t.AMOUNT) AS total_amount_spent,
    AVG(t.AMOUNT) AS average_transaction_amount,
    SUM(t.AMOUNT_BEFORE_PROMOS - t.AMOUNT) AS total_amount_saved
FROM
    USER_INFO ui
    INNER JOIN USER_ACCOUNT ua ON ui.USER_ID = ua.USER_ID
    INNER JOIN TRANSACTION t ON ua.ACCOUNT_ID = t.USER_ACCOUNT_ID
GROUP BY
    ui.USER_ID, ui.NAME;


-- Аналогичная статистика по продавцам
CREATE OR REPLACE VIEW merchant_sales_summary AS
SELECT
    mi.MERCHANT_ID,
    mi.NAME,
    COUNT(t.TRANSACTION_ID) AS total_transactions,
    SUM(t.AMOUNT) AS total_sales_amount,
    AVG(t.AMOUNT) AS average_transaction_amount,
    SUM(t.AMOUNT_BEFORE_PROMOS - t.AMOUNT) AS total_amount_discounted
FROM
    MERCHANT_INFO mi
    INNER JOIN MERCHANT_ACCOUNT ma ON mi.MERCHANT_ID = ma.MERCHANT_ID
    INNER JOIN TRANSACTION t ON ma.ACCOUNT_ID = t.MERCHANT_ACCOUNT_ID
GROUP BY
    mi.MERCHANT_ID, mi.NAME;


-- Статистики по промо компаниям: количество транзакций, количество поучавствовавших пользователей и потраченный бюджет 
CREATE OR REPLACE VIEW promo_usage_summary AS
WITH transaction_discount AS (
    SELECT
        t.TRANSACTION_ID,
        t.USER_ACCOUNT_ID,
        (t.AMOUNT_BEFORE_PROMOS - t.AMOUNT) AS total_discount,
        COUNT(ap.PROMO_ID) AS num_promos_applied
    FROM
        TRANSACTION t
        JOIN APPLIED_PROMOS ap ON t.TRANSACTION_ID = ap.TRANSACTION_ID
    GROUP BY
        t.TRANSACTION_ID,
        t.USER_ACCOUNT_ID,
        t.AMOUNT_BEFORE_PROMOS,
        t.AMOUNT
)
SELECT
    p.PROMO_ID,
    p.NAME,
    COUNT(*) AS total_times_used,
    COUNT(DISTINCT td.USER_ACCOUNT_ID) AS unique_users_used,
    SUM(td.total_discount / td.num_promos_applied) AS total_discount_amount
FROM
    PROMO p
    INNER JOIN APPLIED_PROMOS ap ON p.PROMO_ID = ap.PROMO_ID
    INNER JOIN transaction_discount td ON ap.TRANSACTION_ID = td.TRANSACTION_ID
GROUP BY
    p.PROMO_ID, p.NAME;
    