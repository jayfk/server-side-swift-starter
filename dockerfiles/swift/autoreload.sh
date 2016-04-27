#!/bin/sh

start () {
  # starts the build process in debug configuration and launches the binary in detached mode
  swift build -Xcc -fblocks -Xlinker -ldispatch -Xcc -I/usr/local/include/libbson-1.0/
  /app/.build/debug/#PROJECT_NAME# &
  PID=$!
}

start

# listens for code changes in /app/Sources and reruns start() whenever there is a change detected
inotifywait -mr /app/Sources --format '%e %f' \
  -e modify -e delete -e move -e create -e attrib \
  --exclude '~.swift' \
  | while read event file; do

  echo $event $file

  kill $PID
  start

done