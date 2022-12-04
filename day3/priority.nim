import strutils

proc getPriority*(item: char): int =
  if item.isUpperAscii:
    result = ord(item) - 38
  else:
    result = ord(item) - 96
  echo item, " : ", ord(item), " : ", result
