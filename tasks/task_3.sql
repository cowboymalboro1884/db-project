CREATE SCHEMA IF NOT EXISTS loyalty_program;
SET search_path = loyalty_program, public;

DROP TABLE IF EXISTS user_info CASCADE;
CREATE TABLE user_info
(
    user_id text primary key,
    name    text not null,
    email   text unique
        constraint check_email
            check (email ~~ '%@%.%'::text),
    phone   text not null unique
        constraint check_phone
            check (length(phone) = 11)
);

DROP TABLE IF EXISTS account_info CASCADE;
CREATE TABLE account_info
(
    account_number text primary key,
    balance        numeric(100, 5)
        constraint check_balance
            check ( balance >= 0 ),
    created_at     date not null,
    updated_at     date not null

);

DROP TABLE IF EXISTS user_account CASCADE;
CREATE TABLE user_account
(
    account_id     text primary key,
    user_id        text    not null references user_info (user_id),
    account_number text    not null references account_info (account_number),
    is_active      boolean not null default false,
    created_at     date    not null
);

DROP TABLE IF EXISTS promo CASCADE;
CREATE TABLE promo
(
    promo_id text primary key,
    discount numeric(8, 5)
        constraint check_discount
            check ( discount >= 0 ),
    name     text not null,
    type     text not null
        constraint check_type
            check ( type ~~ 'absolute'::text or type ~~ 'relative'::text)
);

DROP TABLE IF EXISTS region_info CASCADE;
CREATE TABLE region_info
(
    region_id integer primary key,
    tax       numeric(8, 5)
        constraint check_tax
            check ( tax >= 0 ),
    iso_3     text not null
);


DROP TABLE IF EXISTS merchant_info CASCADE;
CREATE TABLE merchant_info
(
    merchant_id text primary key,
    name        text    not null,
    region_id   integer not null references region_info (region_id)
);

DROP TABLE IF EXISTS merchant_account_history CASCADE;
CREATE TABLE merchant_account_history
(
    account_id  text primary key,
    merchant_id text    not null references merchant_info (merchant_id),
    event_type  text    not null,
    is_active   boolean not null default false,
    updated_at  date    not null
);


DROP TABLE IF EXISTS merchant_account CASCADE;
CREATE TABLE merchant_account
(
    account_id     text primary key,
    merchant_id    text    not null references merchant_info (merchant_id),
    account_number text    not null references account_info (account_number),
    is_active      boolean not null default false
);

DROP TABLE IF EXISTS currency CASCADE;
CREATE TABLE currency
(
    currency_id   text primary key,
    name          text not null,
    exchange_rate numeric(8, 5)
        constraint check_exchange_rate
            check ( exchange_rate > 0 )
);

DROP TABLE IF EXISTS transaction CASCADE;
CREATE TABLE transaction
(
    transaction_id       text primary key,
    user_account_id      text   not null references user_account (account_id),
    merchant_account_id  text   not null references merchant_account (account_id),
    currency_id          text   not null references currency (currency_id),
    amount               numeric(99, 5)
        constraint check_amount
            check ( amount >= 0 ),
    timestamp            date   not null,
    status               text   not null,
    amount_before_promos numeric(99, 5)
        constraint check_amount_b_promos
            check ( amount_before_promos >= 0 )
);

DROP TABLE IF EXISTS applied_promos CASCADE;
CREATE TABLE applied_promos(
    transaction_id text references transaction(transaction_id),
    promo_id text references promo(promo_id)
)
