import std/strutils
import std/sequtils

try:
  let input = readFile("day6/input.txt")

  var charsBeforeStart = 0
  for i in 0 ..< input.len-14:
    let sectionToObserve = input[i ..< i+14]
    if sectionToObserve.deduplicate().len == 14:
      echo "Marker: ", sectionToObserve
      charsBeforeStart = i+14
      break

  echo "Chars before start-of-message: ", charsBeforeStart
except Exception:
  let
    e = getCurrentException()
    msg = getCurrentExceptionMsg()
  echo "Got exception ", repr(e), " with message ", msg
