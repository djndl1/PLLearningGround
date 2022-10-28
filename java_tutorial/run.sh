#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

JAVA_PROJECT_CP=$(mvn dependency:build-classpath -quiet -Dmdep.outputFile=/dev/stdout)
java  -cp "$JAVA_PROJECT_CP:${SCRIPT_DIR}/target/classes" com.java.tutorial.App "$@"
