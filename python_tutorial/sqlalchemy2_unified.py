#!/usr/bin/env python3

from dataclasses import dataclass
from types import new_class
import unittest
from typing import Container, Iterable, Sequence

import cx_Oracle

import sqlalchemy as sa
import sqlalchemy.orm as sorm


from sqlalchemy import Column, ForeignKey, MetaData, String, Integer
from sqlalchemy import Numeric, DateTime, and_, create_engine, insert, select, values

class SAUnifiedTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cx_Oracle.init_oracle_client("/home/djn/opt/instantclient_21_1/")

        # engine, a factory and a connection pool
        cls.engine = create_engine("oracle://DJN:freebird@10.10.0.3:1521?service_name=pdborcl.cisdi.com.cn",
                                   echo=True)

    @classmethod
    def tearDownClass(cls) -> None:
        cls.engine.dispose()

    def test_establish_connect(self):
        with self.engine.connect() as conn:
            result = conn.execute(sa.text("SELECT * FROM V$VERSION"))
            print(result.all())

        with sorm.Session(self.engine) as sess:
            result = sess.execute(sa.text("SELECT * FROM V$VERSION"))

            print(result.all())

            sess.commit() # a new connection is then used afterward

    def test_simple_update(self):
        with self.engine.connect() as conn:
            result = conn.execute(sa.text('''
            UPDATE HR.COUNTRIES
            SET COUNTRY_NAME = :CountryName
            WHERE COUNTRY_NAME = :CountryName'''),
                                  {
                                      "CountryName": "PRC"
                                  })
            self.assertEqual(result.rowcount, 1)

            conn.commit() # commit as we go

        with self.engine.begin() as conn: # automatic commit
            result = conn.execute(sa.text('''
            UPDATE HR.COUNTRIES
            SET COUNTRY_NAME = :CountryName
            WHERE COUNTRY_NAME = :CountryName'''),
                                  {
                                      "CountryName": "PRC"
                                  })
            self.assertEqual(result.rowcount, 1)
