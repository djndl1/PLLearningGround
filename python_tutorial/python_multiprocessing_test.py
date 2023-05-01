import unittest
import time
import random
import datetime
from test_utils import Stopwatch
from multiprocessing import Process


class MultiProcessingTest(unittest.TestCase):
    def calculate_prime_factors(self, n):
        primfac = []
        d = 2
        while d*d <= n:
            while (n % d) == 0:
                primfac.append(d)  # supposing you want multiple factors repeated
                n //= d
            d += 1
        if n > 1:
            primfac.append(n)
        return primfac

    def test_sequential_prime_factors(self) -> None:
        stopwatch = Stopwatch()
        stopwatch.start()

        for i in range(100000):
            rand = random.randint(20000, 100_000_000)
            self.calculate_prime_factors(rand)

        stopwatch.stop()

        print(f"Sequential Execution time is {stopwatch.elapsed_seconds}")

    def process_calculate_prime_factors(self):
        for i in range(10000):
            rand = random.randint(20000, 100_000_000)
            self.calculate_prime_factors(rand)


    def test_multiprocessing_prime_factors(self) -> None:
        stopwatch = Stopwatch()
        stopwatch.start()

        procs = []
        for i in range(10):
            proc = Process(target=self.process_calculate_prime_factors, args=())
            procs.append(proc)
            proc.start()

        for proc in procs:
            proc.join()

        stopwatch.stop()

        print(f"Multiprocessing Execution time is {stopwatch.elapsed_seconds}")
