#!/usr/bin/env bash

# truncate a file
LOG_DIR=/var/log
pushd $(pwd)

cd "${LOG_DIR}"
cat /dev/null > wtmp

echo "wtmp cleaned up."

popd
