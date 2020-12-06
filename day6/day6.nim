import strutils, sequtils

proc charset(str: string): set[char] =
  var chars: set[char] = {}
  for ch in str: chars = chars + {ch}
  chars

let file = readFile("input.txt")
let groups = file.split("\n\n").mapIt(it.splitLines().filterIt(it.len() > 0))

proc countAny(group: openArray[string]): int =
  var s: set[char] = {}
  for person in group:
    s = s + person.charset()
  s.len()

echo "Part 1:", groups.mapIt(it.countAny()).foldl(a + b)

proc countAll(group: openArray[string]): int =
  var s: set[char] = {'a'..'z'}
  for person in group:
    s = s * person.charset()
  s.len()

echo "Part 2:", groups.mapIt(it.countAll()).foldl(a + b)