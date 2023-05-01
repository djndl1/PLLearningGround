#!/usr/bin/env python
#-*- coding: utf8 -*-

from datetime import timedelta
import time

class StopwatchNotStartedError(Exception):
    def __init__(self, *args: object) -> None:
        super().__init__(*args)

class Stopwatch:
    def __init__(self) -> None:
        self._start_time = None
        self._stop_time = None

    def start(self) -> None:
        self._start_time = time.perf_counter_ns()

    def stop(self) -> None:
        if self._start_time is None:
            raise StopwatchNotStartedError()

        self._stop_time = time.perf_counter_ns()

    @property
    def elapsed_time(self) -> int:
        if self._start_time is None:
            raise StopwatchNotStartedError()

        stop_time = self._stop_time
        if stop_time is None:
            stop_time = time.perf_counter_ns()

        return stop_time - self._start_time

    @property
    def elapsed_seconds(self) -> float:
        return self.elapsed_time / 1e9
