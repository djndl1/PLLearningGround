# -*- coding: utf-8 -*-

from dataclasses import dataclass
from types import new_class
import unittest
from typing import Container, Iterable, Sequence

import cx_Oracle

import sqlalchemy as sa
import sqlalchemy.orm as sorm


from sqlalchemy import Column, ForeignKey, MetaData, String, Integer, Numeric, DateTime, create_engine, insert, values

Base = sorm.declarative_base()


class SACoreTest(unittest.TestCase):
    def __init__(self, methodName: str = ...) -> None:
        super().__init__(methodName)

    @classmethod
    def setUpClass(cls) -> None:

        cx_Oracle.init_oracle_client("/home/djn/opt/instantclient_21_1/")

        cls.engine = create_engine("oracle://SQLAlchemy:sqlalchemy@10.10.0.3:1521?service_name=pdbmgyard.docker.internal",
                                   future=True,
                                   echo=True)

    @classmethod
    def tearDownClass(cls) -> None:
        cls.engine.dispose()

    def create_session(self) -> sorm.Session:
        return sorm.Session(self.engine, future=True)

    def test_version_check(self) -> None:
        print(sa.__version__)

    def test_create_connection(self) -> None:
        '''
            create a Core connection
        '''
        with self.engine.connect() as conn:
            result = conn.execute(sa.text("SELECT 1 from dual"))

            print(result.all())

    def test_create_table_commit(self) -> None:
        with self.engine.connect() as conn:
            conn.execute(sa.text(
                "INSERT INTO some_table (x, y) VALUES (:x, :y)"
            ), [{"x": 1, "y": 2},
                {"x": 3, "y": 4}])
            conn.commit()

        # begin transaction and commit automatically before the connection is dropped
        with self.engine.begin() as conn:
            conn.execute(sa.text(
                "INSERT INTO some_table (x, y) VALUES (:x, :y)"
            ), [{"x": 1, "y": 2},
                {"x": 3, "y": 4}])

    def test_fetch_rows(self) -> None:
        with self.engine.connect() as conn:
            result: sa.engine.Result = conn.execute(
                sa.text("SELECT x, y FROM some_table WHERE y = :y"), {"y": 2})
            for row in result:
                print(f"{row.x}\t{row.y}")


class SAMetaDataTest(unittest.TestCase):
    def __init__(self, methodName: str = ...) -> None:
        super().__init__(methodName)

    @classmethod
    def setUpClass(cls) -> None:

        cx_Oracle.init_oracle_client("/home/djn/opt/instantclient_21_1/")

        cls.engine = create_engine("oracle://SQLAlchemy:sqlalchemy@10.10.0.3:1521?service_name=pdbmgyard.docker.internal",
                                   future=True,
                                   echo=True)

        cls.metadata = sa.MetaData()  # comparable to Database schema

        cls.user_table = sa.Table(
            "user_account",
            cls.metadata,
            Column("ID", Integer, primary_key=True),
            Column("NAME", String(30)),
            Column("FULL_NAME", String(60))
        )

        cls.address_table = sa.Table(
            "address", cls.metadata,
            Column("id", Integer, primary_key=True),
            Column("user_id", ForeignKey("user_account.ID"), nullable=False),
            Column("email_address", String(60), nullable=False)
        )

    @classmethod
    def tearDownClass(cls) -> None:
        cls.engine.dispose()

    def test_create_tables_from_metadata(self):
        self.metadata.create_all(self.engine)

    def test_reflect_on_database(self) -> None:
        metadata = MetaData()
        user_table = sa.Table("user_account", metadata,
                              autoload_with=self.engine)

        print(user_table.c)

    def test_insert(self) -> None:
        insert_stmt = insert(self.user_table).values(
            NAME="DJN", FULL_NAME="D JN")
        print(insert_stmt)

        compiled_stmt = insert_stmt.compile()
        print(compiled_stmt, compiled_stmt.params)

        with self.engine.connect() as conn:
            result = conn.execute(insert_stmt, [
                {"NAME": "AFD", "FULL_NAME": "fd dfa"}
            ])
            conn.commit()

            print(result.inserted_primary_key)

    def test_insert_select(self) -> None:
        insert_select = insert(self.address_table).from_select(
            ["user_id", "email_address"], sa.select(
                self.user_table.c.ID, self.user_table.c.NAME)
            )

        print(insert_select)

    def test_insert_returning(self) -> None:
        insert_returning_stmt = insert(self.user_table).returning(
            self.user_table.c.ID, self.user_table.c.NAME
        )

        print(insert_returning_stmt.compile())
