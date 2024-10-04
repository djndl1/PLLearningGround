#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest

class Parent1:
    def __init__(self):
        self.name = "Parent1"
        print(f'Initializing {self.name} from {type(self)}')

    @property
    def Name(self):
        return self.name

    @staticmethod
    def static_name():
        return "Parent1"

class MIParent1(Parent1):
    def __init__(self):
        self.name = "MIParent1"
        print(f'Initializing {self.name} from {type(self)}')
        super().__init__()
        # MIParent2  is already initialized
        self.Parent1 = True
        self.Parent2 = False

class MIParent2(Parent1):
    def __init__(self):
        self.name = "MIParent2"
        print(f'Initializing {self.name} from {type(self)}')
        super().__init__()
        self.Parent1 = False
        self.Parent2 = True

class Parent2(Parent1):
    def __init__(self):
        self.name = "Parent2"
        print(f'Initializing {self.name} from {type(self)}')

    @property
    def Name(self):
        return self.name

    @staticmethod
    def static_name():
        return "Parent2"

class Child0(Parent2):
    def __init__(self):
        super().__init__()
        self.myself = isinstance(self, Child0)

class Child1(Parent1):
    def __init__(self):
        super(Child1, self).__init__()

class Child2(Parent2):
    def __init__(self):
        super(Parent2, self).__init__()

class Child3(Parent2):
    def __init__(self):
        super(Parent2, Child3).__init__(self)

class Child4(Parent2):
    def __init__(self):
        sup = super(Child0, Child0)
        sup.__init__(self)

class MIChild(MIParent1, MIParent2):
    def __init__(self):
        super().__init__()

    @property
    def parent1_name(self):
        return super().Name

    @property
    def parent2_name(self):
        return super(MIParent1, self).Name

class RecursiveSuperParent:
    def __init__(self):
        print("From RecursiveSuperParent")
        super(self.__class__, self).__init__()

class RecursiveSuperChild(RecursiveSuperParent):
    def __init__(self):
        print('From RecursiveSuperChil.d')
        super(self.__class__, self).__init__()



class OOPTests(unittest.TestCase):
    def test_super_single(self):
        p1 = Parent1()
        p2 = Parent2()
        self.assertEqual(Child0().Name, p2.Name, "should have Parent2")
        self.assertEqual(Child1().Name, p1.Name, "should have Parent1")
        self.assertEqual(Child2().Name, p1.Name, "should have Parent1")
        self.assertEqual(Child3().Name, p1.Name, "should have Parent1")
        self.assertEqual(Child4().Name, p2.Name, "should have Parent2")


    def test_super_double(self):
        p1 = Parent1()
        p2 = Parent2()

        mp1 = MIParent1()
        mp2 = MIParent2()

        mi = MIChild()
        self.assertEqual(mi.Name, p1.Name)
        self.assertTrue(mi.Parent1)
        self.assertFalse(mi.Parent2)

        self.assertEqual(mi.parent1_name, mp1.Name)
        self.assertEqual(mi.parent2_name, mp2.Name)

    def test_recursive_super(self):
        self.assertRaises(RecursionError, RecursiveSuperChild)
