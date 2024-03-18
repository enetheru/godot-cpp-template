#!/bin/bash

if [ "${GODOT}" = "" ]; then
  echo "Godot binary not specified, aborting tests"
  exit 1
fi
echo "GODOT=$GODOT"

END_STRING="==== TESTS FINISHED ===="
FAILURE_STRING="******** FAILED ********"

OUTPUT=$($GODOT --path ./test/project --headless --quit)
ERRCODE=$?

echo "$OUTPUT"
echo

if ! echo "$OUTPUT" | grep -e "$END_STRING" >/dev/null; then
    echo "ERROR: Tests failed to complete"
    exit 1
fi

if echo "$OUTPUT" | grep -e "$FAILURE_STRING" >/dev/null; then
    exit 1
fi

# Success!
exit 0
