import sets, strutils, sequtils, sugar

let file = readFile("expense-report.txt")
let lines = file.splitLines()

let values = toHashSet(lines.map(parseInt))

for value in values:
  let remaining = 2020 - value
  if remaining != value and remaining in values:
    echo value, " * ", remaining, " = ", value*remaining

echo "Done!"