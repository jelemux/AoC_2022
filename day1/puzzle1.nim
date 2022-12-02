import strutils

try:
  let elvesRaw = readFile("day1/input.txt")
      .strip()
      .split("\n\n")

  var maxElf: int
  var maxCalories = 0
  for currentElf, elfRaw in elvesRaw:
    var currentCalories: int
    for caloriesRaw in elfRaw.strip().splitLines():
      let calories = parseInt(caloriesRaw.strip())
      currentCalories += calories

    if currentCalories > maxCalories:
      maxCalories = currentCalories
      maxElf = currentElf+1

  echo "Elf carrying the most: ", maxElf, " with ", maxCalories, " calories"
except IOError:
  let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
  echo "Got exception ", repr(e), " with message ", msg

# alternative solution
try:
  let input = open("day1/input.txt")

  var maxElf: int
  var maxCalories = 0
  var currentElf = 1
  var currentCalories = 0

  for line in input.lines:
    if line.isEmptyOrWhitespace():
      if currentCalories > maxCalories:
        maxElf = currentElf
        maxCalories = currentCalories
      currentElf += 1
      currentCalories = 0
      continue

    currentCalories += parseInt(line)

  echo "Elf carrying the most: ", maxElf, " with ", maxCalories, " calories"
except IOError:
  let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
  echo "Got exception ", repr(e), " with message ", msg