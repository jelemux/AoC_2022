import std/strutils
import crates

try:
  let input = readFile("day5/input.txt").split("\n\n")

  var cargoHold = parseCargoHold(input[0])
  for step in parseSteps(input[1]):
    cargoHold.simultanRearrange(step)

  var topCrates = ""
  for crate in cargoHold.topCrates():
    topCrates.add(crate)
  echo "Top crates after rearrangment: ", topCrates
except Exception:
  let
    e = getCurrentException()
    msg = getCurrentExceptionMsg()
  echo "Got exception ", repr(e), " with message ", msg
