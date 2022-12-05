import std/strutils

const crateLength = 4
const crateSepLength = 1

type
  Crate* = char
  Stack* = seq[Crate]
  Cargo* = seq[Stack]
  CargoHold* = ref object of RootObj
    cargo*: Cargo
  Step* = object
    amount,src,dest: int

method rearrange*(cargoHold: CargoHold, step: Step) {.base.} =
  for i in 0 ..< step.amount:
    var crateToMove = cargoHold.cargo[step.src-1][^1]
    cargoHold.cargo[step.src-1].delete(cargoHold.cargo[step.src-1].len - 1)

    cargoHold.cargo[step.dest-1].add(crateToMove)

method rearrange*(cargoHold: CargoHold, steps: seq[Step]) {.base.} =
  for step in steps:
    cargoHold.rearrange(step)

proc topCrates*(cargoHold: Cargo): seq[Crate] =
  var topCrates = newSeq[Crate](cargoHold.len)
  for stackIdx, stack in cargoHold:
    topCrates[stackIdx] = stack[stack.len-1]

  return topCrates

proc parseCargoHold*(input: string): CargoHold =
  let levels = input.splitLines()
  let stackCount = int((levels[^1].len+crateSepLength) / crateLength)
  var cargoHold = CargoHold(cargo: newSeq[Stack](stackCount))

  for levelIdx in countdown(levels.len-2, 0):
    let levelContent = levels[levelIdx]
    for stackIdx in 0 ..< stackCount:
      if levelContent[stackIdx * crateLength] == '[':
        let crate: Crate = levelContent[stackIdx * crateLength + 1]
        cargoHold.cargo[stackIdx].add(crate)

  return cargoHold

proc parseStep*(input: string): Step =
  let parts = input.split(' ')
  return Step(
    amount: parseInt(parts[1]),
    src: parseInt(parts[3]),
    dest: parseInt(parts[5]),
  )

proc parseSteps*(input: string): seq[Step] =
  var steps = newSeq[Step](input.countLines())
  for line in input.splitLines():
    let step = parseStep(line)
    steps.add(step)

  return steps

iterator parseSteps*(input: string): Step =
  for line in input.splitLines():
    if line != "":
      yield parseStep(line)
