#!/usr/bin/env python3
# -*- coding: utf8 -*-

import threading
import unittest
import datetime
from threading import Thread, Timer
import time

import urllib.request

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

class ThreadedDownloadTest(unittest.TestCase):
    def download_image(self, image_path, file_name):
        print(f"Downloading Image from {image_path} at {datetime.datetime.now()}")
        urllib.request.urlretrieve(image_path, file_name)

    def test_sequential_download(self) -> None:
        start_time: int = time.perf_counter_ns()

        for i in range(10):
            image_name = f'threading-pics/image-{i}.jpg'
            self.download_image("http://iph.href.lu/640x360", image_name)

        stop_time: int = time.perf_counter_ns()

        print(f"Sequential download time elapsed: {(stop_time - start_time) / 1e9}")

    def test_concurrent_download(self) -> None:
        start_time: int = time.perf_counter_ns()

        threads = []
        for i in range(10):
            image_name = f'threading-pics/image-{i}.jpg'
            thread = threading.Thread(target=self.download_image, args=("http://iph.href.lu/640x360", image_name))
            threads.append(thread)
            thread.start()

        for th in threads:
            th.join()

        stop_time: int = time.perf_counter_ns()

        print(f"Sequential download time elapsed: {(stop_time - start_time) / 1e9}")


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