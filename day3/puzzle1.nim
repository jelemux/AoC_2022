import strutils
import std/sets

proc getPriority(item: char): int =
  if item.isUpperAscii:
    result = ord(item) - 38
  else:
    result = ord(item) - 96
  echo item, " : ", ord(item), " : ", result

try:
  let input = open("day3/input.txt")

  var prioritySum = 0
  for line in input.lines:
    var firstCompartment = initHashSet[char]()
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