import std/strutils
import std/sequtils
import std/strformat
import std/sets

type
  TreePatch* = object
    columnCount: Natural
    rowCount: Natural
    data: seq[seq[Natural]]
  Tree = tuple[row, column: Natural]

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
  var
    visibleTreeCount: Natural = 0
    # Necessary for filtering out duplicates
    visibleTrees: HashSet[Tree]

    tallestTreesInColumn = newSeq[Natural](treePatch.columnCount)
    tallestTreesInColumnInverted = newSeq[Natural](treePatch.columnCount)

  for rowIdx in Natural(0) ..< treePatch.rowCount:
    var
      tallestTreeInRow = 0
      tallestTreeInRowInverted = 0
    for columnIdx in  Natural(0) ..< treePatch.columnCount:
      let tree = treePatch[rowIdx, columnIdx]
      if tree > tallestTreeInRow:
        tallestTreeInRow = tree
        let visibleTree = (row: Natural(rowIdx), column: Natural(columnIdx))
        if not visibleTrees.contains(visibleTree):
          visibleTrees.incl(visibleTree)
          inc visibleTreeCount
      if tree > tallestTreesInColumn[columnIdx]:
        tallestTreesInColumn[columnIdx] = tree
        let visibleTree = (row: Natural(rowIdx), column: Natural(columnIdx))
        if not visibleTrees.contains(visibleTree):
          visibleTrees.incl(visibleTree)
          inc visibleTreeCount

      let
        invertedRowIdx = (treePatch.rowCount-1) - rowIdx
        invertedColumnIdx = (treePatch.columnCount-1) - columnIdx
        treeInverted = treePatch[invertedRowIdx, invertedColumnIdx]
      if treeInverted > tallestTreeInRowInverted:
        tallestTreeInRowInverted = treeInverted
        let visibleTree = (row: Natural(invertedRowIdx), column: Natural(invertedColumnIdx))
        if not visibleTrees.contains(visibleTree):
          visibleTrees.incl(visibleTree)
          inc visibleTreeCount
      if treeInverted > tallestTreesInColumnInverted[invertedColumnIdx]:
        tallestTreesInColumnInverted[invertedColumnIdx] = treeInverted
        let visibleTree = (row: Natural(invertedRowIdx), column: Natural(invertedColumnIdx))
        if not visibleTrees.contains(visibleTree):
          visibleTrees.incl(visibleTree)
          inc visibleTreeCount

  return visibleTreeCount
