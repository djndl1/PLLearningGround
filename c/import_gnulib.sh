#!/usr/bin/bash

GNULIB_MODULES="unistr/u16-to-u32 \
    unistr/u16-to-u8 \
    unistr/u32-to-u16 \
    unistr/u32-to-u8 \
    unistr/u8-to-u16 \
    unistr/u8-to-u32 \
    nullptr \
    stdbool"

GNULIB_TOOL=$1

"${GNULIB_TOOL}" --import ${GNULIB_MODULES} "${@:2}"
