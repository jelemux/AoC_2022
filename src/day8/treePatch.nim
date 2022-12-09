import std/strutils
import std/sequtils
import std/strformat

type
  TreePatch* = object
    columnCount: Natural
    rowCount: Natural
    data: seq[seq[Natural]]

proc `[]=`(treePatch: var TreePatch, row, column, value: Natural) =
  if row > treePatch.rowCount-1:
    raise newException(IndexDefect, fmt("Row index {row} exceeds height of tree patch"))
  if column > treePatch.rowCount-1:
    raise newException(IndexDefect, fmt("Column index {column} exceeds width of tree patch"))
  if treePatch.data.len() == 0:
    treePatch.data = newSeqWith(treePatch.rowCount, newSeq[Natural](treePatch.columnCount))
  treePatch.data[row][column] = value

proc `[]`(treePatch: TreePatch, row, column: Natural): Natural =
  return treePatch.data[row][column]

proc readTreePatch*(input: string): TreePatch =
  let rows = input.strip().splitLines()
  var treePatch = TreePatch(rowCount: rows.len(), columnCount: rows[0].len)
  for rowIdx, row in rows:
    for columnIdx, tree in row:
      treePatch[rowIdx,columnIdx] = int(tree) - int('0')

  return treePatch

proc countVisibleTrees*(treePatch: TreePatch): Natural =
  var visibleTreeCount: Natural = 0

  var tallestTreesInColumn = newSeq[Natural](treePatch.columnCount)
  var tallestTreesInColumnInverted = newSeq[Natural](treePatch.columnCount)
  for rowIdx in Natural(0) ..< treePatch.rowCount:
    var tallestTreeInRow = 0
    var tallestTreeInRowInverted = 0
    for columnIdx in  Natural(0) ..< treePatch.columnCount:
      let tree = treePatch[rowIdx, columnIdx]
      if tree > tallestTreeInRow:
        inc visibleTreeCount
        tallestTreeInRow = tree
      if tree > tallestTreesInColumn[columnIdx]:
        inc visibleTreeCount
        tallestTreesInColumn[columnIdx] = tree

      let treeInverted = treePatch[(treePatch.rowCount-1) - rowIdx, (treePatch.columnCount-1) - columnIdx]
      if treeInverted > tallestTreeInRowInverted:
        inc visibleTreeCount
        tallestTreeInRowInverted = treeInverted
      if treeInverted > tallestTreesInColumnInverted[(treePatch.columnCount-1) - columnIdx]:
        inc visibleTreeCount
        tallestTreesInColumnInverted[(treePatch.columnCount-1) - columnIdx] = treeInverted

  return visibleTreeCount
