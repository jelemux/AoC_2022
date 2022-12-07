import std/strutils

const crateLength = 4
const crateSepLength = 1

type
  Crate* = char
  Stack* = seq[Crate]
  Cargo* = seq[Stack]
  CargoHold* = ref object of RootObj
    cargo: Cargo
  Step* = object
    amount, src, dest: int

proc getLastFrom*(cargoHold: CargoHold, stackNumber: int;
    beginningWith = ^1): seq[Crate] =
  return cargoHold.cargo[stackNumber-1][beginningWith .. ^1]

method deleteFrom*(cargoHold: CargoHold, stackNumber: int;
    beginningWith = ^1) {.base.} =
  for _ in 1 .. int(beginningWith):
    cargoHold.cargo[stackNumber-1].delete(cargoHold.cargo[stackNumber-1].len - 1)

method addTo*(cargoHold: CargoHold, stackNumber: int, crates: seq[
    Crate]) {.base.} =
  cargoHold.cargo[stackNumber-1].add(crates)

method sequentialRearrange*(cargoHold: CargoHold, step: Step) {.base.} =
  for _ in 0 ..< step.amount:
    let crateToMove = cargoHold.getLastFrom(step.src)
    cargoHold.deleteFrom(step.src)
    cargoHold.addTo(step.dest, crateToMove)

method sequentialRearrange*(cargoHold: CargoHold, steps: seq[Step]) {.base.} =
  for step in steps:
    cargoHold.sequentialRearrange(step)

method simultanRearrange*(cargoHold: CargoHold, step: Step) {.base.} =
  let cratesToMove = cargoHold.getLastFrom(step.src, ^step.amount)
  cargoHold.deleteFrom(step.src, ^step.amount)
  cargoHold.addTo(step.dest, cratesToMove)

method simultanRearrange*(cargoHold: CargoHold, steps: seq[Step]) {.base.} =
  for step in steps:
    cargoHold.simultanRearrange(step)

proc topCrates*(cargoHold: CargoHold): seq[Crate] =
  var topCrates = newSeq[Crate](cargoHold.cargo.len)
  for stackIdx, stack in cargoHold.cargo:
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
