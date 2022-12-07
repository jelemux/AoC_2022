import strutils
import rockPaperScissors
import std/strformat

proc lineToResult1(line: string): int =
  case line[0 .. 2]
  of "B X":
    return 1
  of "C Y":
    return 2
  of "A Z":
    return 3
  of "A X":
    return 4
  of "B Y":
    return 5
  of "C Z":
    return 6
  of "C X":
    return 7
  of "A Y":
    return 8
  of "B Z":
    return 9
  else:
    raise newException(ShapeNotMatching, fmt"Shape '{line}' does not match")

proc day2puzzle1*() =
  try:
    let input = open("src/day2/input.txt")

    var totalScore = 0
    for line in input.lines:
      let shapes = line.strip().split(" ")
      let roundScore = scoreForRoundWithRaw(shapes[0], shapes[1])
      totalScore += roundScore

    echo "Total score is: ", totalScore
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg

  # alternative method
  try:
    let input = open("src/day2/input.txt")

    var totalScore = 0
    for line in input.lines:
      let roundScore = lineToResult1(line)
      totalScore += roundScore

    echo "Total score is: ", totalScore
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
