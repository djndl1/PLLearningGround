#!/usr/bin/env python3
"""Renumber BASIC program lines in multiples of a given step.

Usage:
    python renumber.py program.bas            # output to stdout (step=10)
    python renumber.py -i program.bas         # modify in place (step=10)
    python renumber.py -s 100 program.bas     # step of 100
"""

import sys
import re
import argparse


def build_mapping(lines, step=10):
    old_nums = []
    for line in lines:
        m = re.match(r'^\s*(\d+)', line)
        if m:
            old_nums.append(int(m.group(1)))
    return {old: (i + 1) * step for i, old in enumerate(old_nums)}


def renumber_line(line, mapping, errors):

    def replace_lineno(m):
        old = int(m.group(2))
        new = mapping.get(old)
        if new is None:
            return m.group(0)
        return m.group(1) + str(new)

    new_line = re.sub(r'^(\s*)(\d+)', replace_lineno, line)

    m = re.match(r'^(\s*)(\d+)', line)
    if m:
        rest = line[m.end():].lstrip().upper()
        if rest.startswith('REM') or rest.startswith('DATA'):
            return new_line

    def replace_ref(m):
        keyword = m.group(1)
        old = int(m.group(2))
        new = mapping.get(old)
        if new is None:
            errors.append(f"referenced line {old} not found: {m.group(0).strip()}")
            return m.group(0)
        return f'{keyword} {new}'

    new_line = re.sub(r'\b(GOTO|GOSUB)\s+(\d+)\b', replace_ref, new_line, flags=re.IGNORECASE)
    new_line = re.sub(r'\bTHEN\s+(\d+)\b', replace_ref, new_line, flags=re.IGNORECASE)

    return new_line


def main():
    parser = argparse.ArgumentParser(description='Renumber BASIC program lines')
    parser.add_argument('file', help='BASIC program file')
    parser.add_argument('-i', '--in-place', action='store_true', help='Modify file in place')
    parser.add_argument('-s', '--step', type=int, default=10, help='Line number step (default: 10)')
    args = parser.parse_args()

    with open(args.file) as f:
        lines = f.readlines()

    mapping = build_mapping(lines, step=args.step)
    errors = []
    new_lines = [renumber_line(line, mapping, errors) for line in lines]
    output = ''.join(new_lines)

    if errors:
        for err in errors:
            print(f"Error: {err}", file=sys.stderr)
        sys.exit(1)

    if args.in_place:
        with open(args.file, 'w') as f:
            f.write(output)
        print(f"Renumbered {len(mapping)} lines in {args.file}", file=sys.stderr)
    else:
        sys.stdout.write(output)


if __name__ == '__main__':
    main()
