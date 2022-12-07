import strutils

type
  Section = int
  Assignment* = object
    first, last: Section

proc contains*(this: Assignment, other: Assignment): bool =
  return this.first <= other.first and
         this.last >= other.last

proc overlaps*(this: Assignment, other: Assignment): bool =
  return (other.first <= this.last and other.last >= this.first) or
         (other.first >= this.last and other.last <= this.first)

proc parse*(assignment: string): Assignment =
  var sections = assignment.split('-')
  return Assignment(
      first: sections[0].parseInt(),
      last: sections[1].parseInt()
  )
