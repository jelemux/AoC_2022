import strutils
import rockPaperScissors
import std/strformat


proc lineToResult(line: string): int =
  case line[0 .. 2]
  of "B X":
    return 1
  of "C X":
    return 2
  of "A X":
    return 3
  of "A Y":
    return 4
  of "B Y":
    return 5
  of "C Y":
    return 6
  of "C Z":
    return 7
  of "A Z":
    return 8
  of "B Z":
    return 9
  else:
    raise newException(ShapeNotMatching, fmt"Shape '{line}' does not match")

try:
  let input = open("day2/input.txt")

  var totalScore = 0
  for line in input.lines:
    let roundScore = lineToResult(line)
    totalScore += roundScore

  echo "Total score is: ", totalScore
except Exception:
  let
    e = getCurrentException()
    msg = getCurrentExceptionMsg()
  echo "Got exception ", repr(e), " with message ", msg
