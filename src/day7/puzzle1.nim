import std/strutils
import fileTree

proc day7puzzle1*() =
  try:
    let input = readFile("src/day7/input.txt")
    var rootDir = readFromHistory(input)
    echo rootDir[]
    echo "sum of directories with a total size of at most 100000: ", sumSizeOfDirsWithSizeNotMoreThan100_000(rootDir)
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
