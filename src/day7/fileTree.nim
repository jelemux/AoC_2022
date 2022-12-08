import std/tables
import std/strutils

type
  Command = object
    args: seq[string]
    outputLines: seq[string]
  File = object
    name: string
    size: Natural
  Dir* = ref object of RootObj
    name*: string
    parent*: Dir
    files*: Table[string, File]
    children*: Table[string, Dir]
  DirNotFoundError* = ValueError

proc isEmpty(dir: Dir): bool =
  return dir.files.len == 0 and dir.children.len == 0

proc absolutePath(dir: Dir; path = ""): string =
  if dir.parent == nil:
    return path

  return absolutePath(dir.parent, "/" & dir.name & path)

method cd(currentDir: Dir, dirName: string): Dir {. base raises: [DirNotFoundError].} =
  if dirName == "..":
    if currentDir.parent == nil:
      raise newException(DirNotFoundError, "targetDir '" & currentDir.absolutePath() & "/..' could not be found")
    return currentDir.parent

  try:
    return currentDir.children[dirName]
  except KeyError:
    raise newException(DirNotFoundError, "targetDir '" & currentDir.absolutePath() & "/" & dirName & "' could not be found")

method createFile(dir: Dir, file: File) {.base.} =
  let _ = dir.files.hasKeyOrPut(file.name, file)

method createChild(dir: Dir, child: Dir) {.base.} =
  let _ = dir.children.hasKeyOrPut(child.name, child)

proc parseCommand(raw: string): Command =
  let lines = raw.splitLines()
  let args = lines[0].split(' ')

  var output: seq[string]
  if lines.len > 1:
    output = lines[1 .. ^1]

  return Command(args: args, outputLines: output)

proc parseListOutput(lsOutput: seq[string]): tuple[files: seq[File], dirs: seq[Dir]] =
  for line in lsOutput:
    if line == "":
      continue
    let fileOrDirInfo = line.split(' ')
    if fileOrDirInfo[0] == "dir":
      let dir = Dir(name: fileOrDirInfo[1])
      result.dirs.add(dir)
    else:
      let size = parseInt(fileOrDirInfo[0])
      let file = File(name: fileOrDirInfo[1], size: size)
      result.files.add(file)

method readSubDirs(currentDir: Dir, history: seq[string]) {.base.} =
  if history.len < 1:
    return
  let newHistory = history[1 .. ^1]
  echo "History: ", newHistory[0 .. 2]
  for rawCommand in newHistory:
    let command = parseCommand(rawCommand)
    case command.args[0]
    of "cd":
      echo "cd ", command.args[1]
      currentDir.cd(command.args[1])
          .readSubDirs(newHistory)
      break
    of "ls":
      echo "ls ", currentDir.name
      let listOutput = parseListOutput(command.outputLines)
      echo "files:"
      for file in listOutput.files:
        echo "  ", file.name
        currentDir.createFile(file)
      echo "dirs:"
      for dir in listOutput.dirs:
        echo "  ", dir.name
        currentDir.createChild(dir)
    echo "----"

proc readFromHistory*(history: string): Dir =
  var rootDir = Dir(name: "/")
  rootDir.readSubDirs(history.split("\n$ "))
  return rootDir

proc allSizes(dir: Dir): seq[Natural] =
  var thisSize: Natural = 0
  for file in dir.files.values():
    thisSize += file.size
  for child in dir.children.values():
    let sizesOfChild = child.allSizes()
    thisSize += sizesOfChild[^1]
    result.add(sizesOfChild)

  result.add(thisSize)

proc size(dir: Dir): Natural =
  for file in dir.files.values():
    result += file.size
  for child in dir.children.values():
    result += child.size()

proc sumSizeOfDirsWithSizeNotMoreThan100_000*(dir: Dir): Natural =
  echo dir.allSizes()
  for size in dir.allSizes():
    if size <= 100_000:
      result += size