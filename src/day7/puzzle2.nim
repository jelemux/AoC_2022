proc day7puzzle2*() =
  try:
    let input = readFile("src/day7/input.txt")
    var rootDir = readFromHistory(input)
    echo "size of directory to delete: ", findSizeOfDirToDelete(rootDir)
  except Exception:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
