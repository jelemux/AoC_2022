import std/strutils
import std/sequtils

try:
  let input = readFile("day6/input.txt")

  var charsBeforeStart = 0
  for i in 0 ..< input.len-4:
    let sectionToObserve = input[i ..< i+4]
    if sectionToObserve.deduplicate().len == 4:
      echo "Marker: ", sectionToObserve
      charsBeforeStart = i+4
      break

  echo "Chars before start-of-packet: ", charsBeforeStart
except Exception:
  let
    e = getCurrentException()
    msg = getCurrentExceptionMsg()
  echo "Got exception ", repr(e), " with message ", msg
