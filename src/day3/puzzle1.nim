import std/sets
import priority

proc day3puzzle1*() =
  try:
    let input = open("src/day3/input.txt")

    var prioritySum = 0
    for line in input.lines:
      var firstCompartment: HashSet[char]
      for item in line[0 .. int(line.len/2)-1]:
        firstCompartment.incl(item)

      for item in line[int(line.len/2) .. ^1]:
        if item in firstCompartment:
          prioritySum += getPriority(item)
          break

    echo "Total sum of priorities is: ", prioritySum
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
