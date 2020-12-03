import sugar
import strutils
import sequtils
import nre except toSeq

type
  Constraint = object
    range: Slice[int]
    character: char
  Entry = object
    constraint: Constraint
    password: string

let entryRegex = re"(?m)^(\d+)-(\d+) (.): (.+)$"
iterator iterEntries(file: string): Entry =
  for match in file.findIter(entryRegex):
    let min = parseInt(match.captures[0])
    let max = parseInt(match.captures[1])
    yield Entry(
      constraint: Constraint(
        range: min..max,
        character: match.captures[2][0]
      ),
      password: match.captures[3]
    )

let file = readFile("input.txt")
let entries = toSeq(iterEntries(file))

proc countChar(input: string, subject: char): int =
  var count = 0
  for ch in input:
    if ch == subject:
      count += 1
  count

# part 1
proc isAssumedValid(entry: Entry): bool =
  let count = countChar(entry.password, entry.constraint.character)
  count in entry.constraint.range

echo "Number of passwords assumed to be valid: ", entries.filter(isAssumedValid).len()

# party 2
proc isActuallyValid(entry: Entry): bool =
  let bounds = entry.constraint.range
  let a = entry.password[bounds.a-1]
  let b = entry.password[bounds.b-1]
  a != b and (a == entry.constraint.character or b == entry.constraint.character)

echo "Number of actually valid passwords: ", entries.filter(isActuallyValid).len()