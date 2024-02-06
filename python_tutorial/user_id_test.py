#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from unittest import TestCase
import os, pwd, grp


class OSUserIdTest(TestCase):
    def test_show_my_id(self) -> None:
        uids = [os.getuid(), os.geteuid()]
        user_names = [pwd.getpwuid(i).pw_name for i in uids]

        print(user_names)
