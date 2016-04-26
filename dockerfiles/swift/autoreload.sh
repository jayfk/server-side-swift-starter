#!/bin/sh
start () {
  swift build -Xcc -fblocks -Xlinker -ldispatch -Xcc -I/usr/local/include/libbson-1.0/
  /app/.build/debug/#PROJECT_NAME# &
  PID=$!
}

start

inotifywait -mr /app/Sources --format '%e %f' \
  -e modify -e delete -e move -e create -e attrib \
  --exclude '~.swift' \
  | while read event file; do

  echo $event $file

  kill $PID
  start

done