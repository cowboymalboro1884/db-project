import os

from sqlalchemy import (
    create_engine, Column, String, Integer, Numeric, Boolean, ForeignKey, CheckConstraint,
    TIMESTAMP, func
)
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import relationship, sessionmaker, Session

Base = declarative_base()


class UserInfo(Base):
    __tablename__ = 'user_info'
    __table_args__ = (
        CheckConstraint("email LIKE '%@%.%'", name="check_email"),
        CheckConstraint("length(phone) = 11", name="check_phone"),
        {"schema": "loyalty_program"}
    )

    user_id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    phone = Column(String, unique=True, nullable=False)

    user_accounts = relationship("UserAccount", back_populates="user")


class AccountInfo(Base):
    __tablename__ = 'account_info'
    __table_args__ = (
        CheckConstraint("balance >= 0", name="check_balance"),
        {"schema": "loyalty_program"}
    )

    account_number = Column(String, primary_key=True)
    balance = Column(Numeric(100, 5), nullable=False)
    created_at = Column(TIMESTAMP, nullable=False)
    updated_at = Column(TIMESTAMP, nullable=False)

    user_accounts = relationship("UserAccount", back_populates="account")
    merchant_accounts = relationship("MerchantAccount", back_populates="account")


class UserAccount(Base):
    __tablename__ = 'user_account'
    __table_args__ = (
        {"schema": "loyalty_program"}
    )

    account_id = Column(String, primary_key=True)
    user_id = Column(String, ForeignKey("loyalty_program.user_info.user_id"), nullable=False)
    account_number = Column(String, ForeignKey("loyalty_program.account_info.account_number"), nullable=False)
    is_active = Column(Boolean, nullable=False, default=False)

    user = relationship("UserInfo", back_populates="user_accounts")
    account = relationship("AccountInfo", back_populates="user_accounts")


class Promo(Base):
    __tablename__ = 'promo'
    __table_args__ = (
        CheckConstraint("discount >= 0", name="check_discount"),
        CheckConstraint("type IN ('absolute', 'relative')", name="check_type"),
        {"schema": "loyalty_program"}
    )

    promo_id = Column(String, primary_key=True)
    discount = Column(Numeric(8, 5), nullable=False)
    name = Column(String, nullable=False)
    type = Column(String, nullable=False)


class RegionInfo(Base):
    __tablename__ = 'region_info'
    __table_args__ = (
        CheckConstraint("tax >= 0", name="check_tax"),
        {"schema": "loyalty_program"}
    )

    region_id = Column(Integer, primary_key=True)
    tax = Column(Numeric(8, 5), nullable=False)
    iso_3 = Column(String, nullable=False)


class MerchantInfo(Base):
    __tablename__ = 'merchant_info'
    __table_args__ = (
        {"schema": "loyalty_program"}
    )

    merchant_id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    region_id = Column(Integer, ForeignKey("loyalty_program.region_info.region_id"), nullable=False)
    merchant_accounts = relationship("MerchantAccount", back_populates="merchant")


class MerchantAccountHistory(Base):
    __tablename__ = 'merchant_account_history'
    __table_args__ = (
        {"schema": "loyalty_program"}
    )
    history_id = Column(String, primary_key=True)
    account_id = Column(String, nullable=False)
    merchant_id = Column(String, ForeignKey("loyalty_program.merchant_info.merchant_id"), nullable=False)
    event_type = Column(String, nullable=False)
    is_active = Column(Boolean, nullable=False, default=False)
    updated_at = Column(TIMESTAMP, nullable=False)


class MerchantAccount(Base):
    __tablename__ = 'merchant_account'
    __table_args__ = (
        {"schema": "loyalty_program"}
    )

    account_id = Column(String, primary_key=True)
    merchant_id = Column(String, ForeignKey("loyalty_program.merchant_info.merchant_id"), nullable=False)
    account_number = Column(String, ForeignKey("loyalty_program.account_info.account_number"), nullable=False)
    is_active = Column(Boolean, nullable=False, default=False)
    account = relationship("AccountInfo", back_populates="merchant_accounts")
    merchant = relationship("MerchantInfo", back_populates="merchant_accounts")


class Currency(Base):
    __tablename__ = 'currency'
    __table_args__ = (
        CheckConstraint("exchange_rate > 0", name="check_exchange_rate"),
        {"schema": "loyalty_program"}
    )

    currency_id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    exchange_rate = Column(Numeric(8, 5), nullable=False)


class Transaction(Base):
    __tablename__ = 'transaction'
    __table_args__ = (
        CheckConstraint("amount >= 0", name="check_amount"),
        CheckConstraint("amount_before_promos >= 0", name="check_amount_b_promos"),
        {"schema": "loyalty_program"}
    )

    transaction_id = Column(String, primary_key=True)
    user_account_id = Column(String, ForeignKey("loyalty_program.user_account.account_id"), nullable=False)
    merchant_account_id = Column(String, ForeignKey("loyalty_program.merchant_account.account_id"), nullable=False)
    currency_id = Column(String, ForeignKey("loyalty_program.currency.currency_id"), nullable=False)
    amount = Column(Numeric(99, 5), nullable=False)
    timestamp = Column(TIMESTAMP, nullable=False)
    status = Column(String, nullable=False)
    amount_before_promos = Column(Numeric(99, 5), nullable=False)


class AppliedPromos(Base):
    __tablename__ = 'applied_promos'
    __table_args__ = (
        {"schema": "loyalty_program"}
    )

    transaction_id = Column(String, ForeignKey("loyalty_program.transaction.transaction_id"), primary_key=True)
    promo_id = Column(String, ForeignKey("loyalty_program.promo.promo_id"), primary_key=True)


def main():
    DATABASE_URI = os.environ.get("DATABASE_URI")
    engine = create_engine(DATABASE_URI)
    Base.metadata.create_all(engine)
    session = sessionmaker(bind=engine)()
    find_merchants_revenue_by_regions(session)
    find_inactive_accounts_with_balance(session)
    find_all_transactions_with_applied_promos_names(session)
    find_all_active_users_with_one_account(session)


def find_merchants_revenue_by_regions(session: Session):
    query = (
        session.query(
            RegionInfo.iso_3,
            func.sum(Transaction.amount).label('total_revenue')
        )
        .join(MerchantAccount, Transaction.merchant_account_id == MerchantAccount.account_id)
        .join(MerchantInfo, MerchantAccount.merchant_id == MerchantInfo.merchant_id)
        .join(RegionInfo, MerchantInfo.region_id == RegionInfo.region_id)
        .group_by(RegionInfo.iso_3)
    )
    print("Merchants revenue by regions", query.all())


def find_inactive_accounts_with_balance(session: Session):
    query = (
        session.query(
            UserAccount.account_id,
            UserAccount.account_number,
            AccountInfo.balance
        )
        .join(AccountInfo, UserAccount.account_number == AccountInfo.account_number)
        .filter(UserAccount.is_active == False)
    )
    print("Inactive accounts with balance", query.all())


def find_all_transactions_with_applied_promos_names(session: Session):
    query = (
        session.query(
            Transaction.transaction_id,
            Transaction.amount,
            func.array_agg(Promo.name).label('promos_applied')
        )
        .join(AppliedPromos, Transaction.transaction_id == AppliedPromos.transaction_id)
        .join(Promo, AppliedPromos.promo_id == Promo.promo_id)
        .group_by(Transaction.transaction_id)
    )
    print("All transactions with promos names", query.all())


def find_all_active_users_with_one_account(session: Session):
    query = (
        session.query(UserInfo.name, func.count(UserAccount.account_id).label('account_count'))
        .join(UserAccount, UserInfo.user_id == UserAccount.user_id)
        .filter(UserAccount.is_active == True)
        .group_by(UserInfo.name)
        .having(func.count(UserAccount.account_id) == 1)
    )
    print("All active users with only one account", query.all())


if __name__ == '__main__':
    main()

