import strutils
import assignment

try:
  let input = open("day4/input.txt")

  var numOfOverlaps = 0
  for elfPair in input.lines:
    var assignments = elfPair.split(',')
    var firstAssignment = parse(assignments[0])
    var secondAssignment = parse(assignments[1])
    if firstAssignment.overlaps(secondAssignment):
      inc numOfOverlaps

  echo "Number of assignment overlaps: ", numOfOverlaps
except Exception:
  let
    e = getCurrentException()
    msg = getCurrentExceptionMsg()
  echo "Got exception ", repr(e), " with message ", msg
