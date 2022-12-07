import std/tables
import std/strutils
import std/sequtils

type
  Command = object
    args: seq[string]
    outputLines: seq[string]
  File = object
    name: string
    size: Natural
  Dir* = ref object of RootObj
    name: string
    parent: Dir
    files: Table[string,File]
    children: Table[string,Dir]
  DirNotFoundError = ref object of ValueError
    targetDir: string

proc isEmpty(dir: Dir): bool =
  return dir.files.len == 0 and dir.children.len == 0

proc absolutePath(dir: Dir): string =
  var currentDir = dir
  while currentDir.parent.parent != nil:
    result = "/" & currentDir.name & result
    currentDir = currentDir.parent

proc cd(currentDir: Dir, dirName: string): Dir {.raises: [DirNotFoundError,KeyError].} =
  if dirName == "..":
    if currentDir.parent == nil:
      raise DirNotFoundError(targetDir: currentDir.name & "/..")
    return currentDir.parent

  if not currentDir.children.hasKey(dirName):
    raise DirNotFoundError(targetDir: currentDir.absolutePath & "/" & dirName)
  return currentDir.children[dirName]

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

proc readFromHistory*(history: string): Dir =
  var rootDir = Dir(name: "/")
  var currentDir = rootDir
  for rawCommand in history.split("\n$ ")[1 .. ^1]:
    let command = parseCommand(rawCommand)
    case command.args[0]
    of "cd":
      currentDir = currentDir.cd(command.args[1])
    of "ls":
      let listOutput = parseListOutput(command.outputLines)
      for file in listOutput.files:
        currentDir.createFile(file)
      for dir in listOutput.dirs:
        currentDir.createChild(dir)

proc flatWithSize(dir: Dir): seq[tuple[dir: Dir, size: Natural]] =
  var thisSize = 0
  for file in dir.files.values():
    thisSize += file.size
  for child in dir.children.values():
    let flatWithSizeOfChild = flatWithSize(child)
    thisSize += flatWithSizeOfChild[^1].size
    result = result & flatWithSizeOfChild

  result = result & (dir: dir, size: Natural(thisSize))

proc size(dir: Dir): Natural =
  for file in dir.files.values():
    result += file.size
  for child in dir.children.values():
    result += child.size()

proc sumSizeOfDirsWithSizeNotMoreThan100_000*(dir: Dir): Natural =
  for dirWithSize in flatWithSize(dir):
    if dirWithSize.size <= 100_000:
      result += dirWithSize.size