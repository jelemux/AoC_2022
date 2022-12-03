import std/strformat

type
  Shape* {.pure.} = enum Rock = 1, Paper = 2, Scissors = 3,
  ShapeNotMatching* = object of ValueError

proc fromOpponent*(input: string): Shape =
  case input
  of "A":
    return Rock
  of "B":
    return Paper
  of "C":
    return Scissors
  else:
    raise newException(ShapeNotMatching, fmt"Own Shape '{input}' does not match any of A, B, C")

proc fromOwn*(input: string): Shape =
  case input
  of "X":
    return Rock
  of "Y":
    return Paper
  of "Z":
    return Scissors
  else:
    raise newException(ShapeNotMatching, fmt"Opponent Shape '{input}' does not match any of X, Y, Z")

proc scoreForShape*(shape: Shape): int =
  case shape
  of Rock:
    return 1
  of Paper:
    return 2
  of Scissors:
    return 3

proc scoreForOutcome*(opponent, own : Shape): int =
  if own == opponent:
    return 3

  if (scoreForShape(own) == scoreForShape(opponent)+1 and scoreForShape(opponent) >= 1) or
     (scoreForShape(own) == 1 and scoreForShape(opponent) == 3):
    return 6

  return 0


proc scoreForRound*(opponent, own : Shape): int =
  return scoreForShape(own) + scoreForOutcome(opponent, own)

proc scoreForRoundWithRaw*(opponent, own : string): int =
  let ownShape = fromOwn(own)
  let opponentShape = fromOpponent(opponent)
  result = scoreForRound(opponentShape, ownShape)