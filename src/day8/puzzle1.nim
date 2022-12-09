import std/strutils
import treePatch

proc day8puzzle1*() =
  try:
    let input = readFile("src/day8/test.txt")
    let treePatch = readTreePatch(input)
    echo "Visible Trees: ", treePatch.countVisibleTrees()
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
