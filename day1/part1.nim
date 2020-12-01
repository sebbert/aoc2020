import sets, strutils, sequtils, algorithm

let file = readFile("expense-report.txt")
let lines = file.splitLines()

let values = lines.map(parseInt)

proc part1() =
  let values_set = toHashSet(values)
  for value in values_set:
    let remaining = 2020 - value
    if remaining != value and remaining in values_set:
      echo value, " * ", remaining, " = ", value*remaining
      return

proc permuteK[A](items: var seq[A], k: Natural): bool =
  ## Adapted from https://alistairisrael.wordpress.com/2009/09/22/simple-efficient-pnk-algorithm/

  let n = len(items)
  let edge = k-1
  var j = k
  while j < n and items[j] < items[edge]:
    j += 1

  if j < n:
    swap(items[j], items[edge])
  else:
    reverse(items, k, n)

    var i = edge - 1
    while i >= 0 and items[i] >= items[i+1]:
      i -= 1
    
    if i < 0:
      return false

    j = n-1
    while j > i and items[i] >= items[j]:
      j -= 1

    swap(items[i], items[j])
    reverse(items, i+1, n)
  
  return true

proc part2() =
  var stuff = sorted(values)
  while permuteK(stuff, 3):
    let a = stuff[0]
    let b = stuff[1]
    let c = stuff[2]
    if a + b + c == 2020:
      echo a, " * ", b, " * ", c , " = ", a*b*c
      return

part1()
part2()

echo "Done!"