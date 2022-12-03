import strutils
import std/sets
import priority

try:
  let input = open("day3/input.txt")

  var prioritySum = 0
  var firstElfInGroup = initHashSet[char]()
  var secondElfInGroup = initHashSet[char]()
  var groupCounter = 0

  for line in input.lines:
    inc groupCounter
    case groupCounter
    of 1:
      for item in line:
        firstElfInGroup.incl(item)
    of 2:
      for item in line:
        secondElfInGroup.incl(item)
    else:
      for item in line:
        if item in firstElfInGroup and item in secondElfInGroup:
          prioritySum += getPriority(item)
          break
      groupCounter = 0
      firstElfInGroup.clear()
      secondElfInGroup.clear()

  echo "Total sum of priorities is: ", prioritySum
except Exception:
  let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
  echo "Got exception ", repr(e), " with message ", msg