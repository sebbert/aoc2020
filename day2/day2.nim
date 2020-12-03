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

proc isValid(entry: Entry): bool =
  let count = countChar(entry.password, entry.constraint.character)
  count in entry.constraint.range

# part 1
echo "Number of valid passwords: ", entries.filter(isValid).len()