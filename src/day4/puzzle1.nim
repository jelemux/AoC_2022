import strutils
import assignment

proc day4puzzle1*() =
  try:
    let input = open("src/day4/input.txt")

    var numOfFullContains = 0
    for elfPair in input.lines:
      var assignments = elfPair.split(',')
      var firstAssignment = parse(assignments[0])
      var secondAssignment = parse(assignments[1])
      if firstAssignment.contains(secondAssignment) or
         secondAssignment.contains(firstAssignment):
        inc numOfFullContains

    echo "Number of assignment pairs fully containing the other: ", numOfFullContains
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
