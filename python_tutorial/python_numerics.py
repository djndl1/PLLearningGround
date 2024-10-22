#!/usr/bin/env python3

import decimal
import math
import unittest

def truncated_divmod(dividend, divisor):
    '''
        the remainder has the same sign as the dividend
    '''
    quotient = int(dividend / divisor)
    remainder = dividend - divisor * quotient

    return (quotient, remainder)

def floored_divmod(dividend, divisor):
    '''
        actually, the built-in `divmod` is floored division
        the remainder has the same sign as the divisor
    '''
    q = math.floor(dividend / divisor)

    remainder = dividend - divisor * quotient
    return (q, remainder)

def euclidean_divmod(dividend, divisor):
    '''
        the remainder is guaranteed non-negative
    '''
    fq = dividend / divisor
    if divisor > 0:
        q = math.ceil(fq)
    elif divisor < 0:
        q = math.floor(fq)
    else:
        raise ZeroDivisionError()

    remainder = dividend - divisor * q
    return (q, remainder)

def euclidean_modulo(dividend, divisor):
    pass


class NumericsTest(untitest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass
