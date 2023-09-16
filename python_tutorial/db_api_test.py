#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pymysql
from unittest import TestCase
import uuid

import pyodbc
import cx_Oracle
import sqlite3
import pymssql
from datetime import datetime, timedelta

class DBAPITest(TestCase):
    '''
    This test tutorial uses the employee sample database
    '''
    def setUp(self) -> None:
        self.mysql_connection_params = {
            "host": "10.10.0.3",
            "user": 'djn',
            "password": 'freebird',
            "database": 'employees',
            "charset": 'utf8mb4',
            "cursorclass": pymysql.cursors.DictCursor
        }

    def test_pymssql_globals(self):
        self.print_globals(pymssql)

    def test_pymysql_globals(self):
        '''
        https://pymysql.readthedocs.io/en/latest/modules/cursors.html

        paramstyle: format, pyformat
        '''
        self.print_globals(pymysql)

    def test_pyodbc_globals(self):
        '''
        paramstyle: qmark, one can however parse the named-param sql
        to construct a qmark-sql with positional parameters
        '''
        self.print_globals(pyodbc)

    def test_oracle_globals(self):
        '''
        paramstyle: named
        '''
        self.print_globals(cx_Oracle)

    def test_sqlite3_globals(self):
        '''
        paramstyle: qmark, numeric and named
        '''
        self.print_globals(sqlite3)

    def print_globals(self, db_api_module) -> None:
        print(db_api_module)
        print(f"apilevel: {db_api_module.apilevel}")
        print(f"threadsafety: {db_api_module.threadsafety}")
        print(f"paramstyle : {db_api_module.paramstyle}")

        for attr in ["STRING", "BINARY", "NUMBER", "DATETIME", "ROWID"]:
            print(f"{attr}: {getattr(db_api_module, attr) if hasattr(db_api_module, attr) else None}")

    def _create_connection_with_module(self, db_api_module):
        return db_api_module.connect(**self.mysql_connection_params)

    def create_connection(self):
        return self._create_connection_with_module(pymysql)

    def test_create_connection(self) -> None:
        with self.create_connection() as conn:
            conn.select_db("employees")
            conn.ping()

            self.assertTrue(conn.open, "Connection failed to open")

    def test_select_one(self):
        with self.create_connection() as conn:
            with conn.cursor() as curs:
                curs.execute('''
                    SELECT e.emp_no as emp_no, e.emp_no as emp_no
                     FROM `employees` e
                     WHERE `emp_no` = 10001
                ''')

                print(curs.description) # print columns

                row = curs.fetchone() # cursor move to the next row
                self.assertEqual(curs.rowcount, 1) # one row

                print(row, type(row))

    def test_update_single(self) -> None:
        with self.create_connection() as conn:
            with conn.cursor() as curs:
                curs.execute('''UPDATE `employees`
                                   SET `first_name` = %(first_name)s
                                 WHERE `emp_no` = %(employee_id)s
                             ''',
                             {
                                 "first_name": str(uuid.uuid4())[:14],
                                 "employee_id": 10001, # always %s
                             })
                self.assertEqual(curs.rowcount, 1, "Updated one")

            conn.commit()

    def test_see_mysql_sql(self) -> None:
        with self._create_connection_with_module(pymysql) as conn:
            with conn.cursor() as curs:
                sql = curs.mogrify('''
                    INSERT INTO `employees` (
                        `emp_no`, `birth_date`, `first_name`, `last_name`, `gender`, `hire_date`
                    ) SELECT
                        MAX(emp_no) + 1, %(birth_date)s, %(first_name)s, %(last_name)s, %(gender)s, %(hire_date)s
                    FROM `employees`
                ''',
                             {
                                 "birth_date": datetime.now(),
                                 "first_name": str(uuid.uuid4())[:14],
                                 "last_name": str(uuid.uuid4())[:14],
                                 "gender": "M",
                                 "hire_date": datetime.now(),
                             })
                print(f"Mogrified SQL: {sql}")


    def test_update_many(self) -> None:
        with self.create_connection() as conn:
            with conn.cursor() as curs:
                curs.executemany('''UPDATE `employees`
                                   SET `first_name` = %(first_name)s
                                 WHERE `emp_no` = %(employee_id)s
                             ''',
                             [
                                 {
                                     "first_name": str(uuid.uuid4())[:14],
                                     "employee_id": 10001, # always %s
                                 },
                                 {
                                     "first_name": str(uuid.uuid4())[:14],
                                     "employee_id": 10002, # always %s
                                 },
                              ],)
                self.assertEqual(curs.rowcount, 2, "Updated two")

            conn.commit() # pymysql requires a commit
