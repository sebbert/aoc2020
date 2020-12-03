import sets, strutils, sequtils, options

let file = readFile("input.txt")
let lines = file.splitLines().filterIt(it.len() > 0)

proc get(x, y: int): char =
  let line = lines[y]
  line[x mod line.len()]

proc countSlope(dx, dy: int): int =
  var x = 0
  var y = 0
  var sum = 0
  while y < lines.len():
    if get(x, y) == '#':
      sum += 1
    x += dx
    y += dy
  sum

echo "Part 1: ", countSlope(3, 1)

let part2 = (
  countSlope(1, 1) *
  countSlope(3, 1) *
  countSlope(5, 1) *
  countSlope(7, 1) *
  countSlope(1, 2)
)
echo "part 2: ", part2