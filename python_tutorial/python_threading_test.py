#!/usr/bin/env python3
# -*- coding: utf8 -*-

import unittest
from threading import Thread, Timer
import time

class CounterThread(Thread):
    def __init__(self):
        super().__init__()
        self.count: int = 0

    def run(self) -> None:
        start_time: int = time.perf_counter_ns()

        while self.count < 1e7:
            self.count += 1

        stop_time: int = time.perf_counter_ns()

        print(f"time elapsed: {(stop_time - start_time) / 1e9}")

class ThreadTest(unittest.TestCase):
    def test_counter_thread_synchrously(self) -> None:
        bg_counter = CounterThread()

        bg_counter.run()

    def test_counter_thread_async(self) -> None:
        bg_counter = CounterThread()

        bg_counter.start()

        self.assertTrue(bg_counter.is_alive())

        bg_counter.join()

    def test_timer(self) -> None:
        timer_finished: bool = False
        def timer_func():
            nonlocal timer_finished
            timer_finished = True

        timer = Timer(5, timer_func)

        timer.start()

        timer.join()
        self.assertTrue(timer_finished)