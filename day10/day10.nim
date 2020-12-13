import sugar, strutils, sequtils, algorithm

let file = readFile("input.txt")
var adapters =
  file.splitLines()
  .filterIt(it.len() > 0)
  .map(parseInt)

adapters.sort()
let highestAdapter = adapters[adapters.len - 1]
adapters.add(highestAdapter + 3)

proc part1(): int =
  var diffs: array[3, int]

  var prev = 0
  for adapter in adapters:
    let diff = adapter - prev
    assert(diff > 0)
    assert(diff <= 3)
    diffs[diff-1] += 1
    prev = adapter

  diffs[0] * diffs[2]

dump part1()

iterator descendants(parentIdx: int): int =
  let parentValue = adapters[parentIdx]
  let first = parentIdx + 1
  let last = min(parentIdx + 3, adapters.len - 1)
  for index in first..last:
    let value = adapters[index]
    if value - parentValue > 3:
      break

    yield index


proc part2(): int =
  var counts = newSeq[int](adapters.len)
  for index in countdown(adapters.len-1, 0):
    var count = 0
    for descIndex in descendants(index):
      count += counts[descIndex]
    counts[index] = max(1, count)

  # HACK: We don't represent the outlet (0) in the list of adapters, so sum the paths from 0 here
  var finalSum = 0
  for (i, a) in adapters.pairs:
    if a > 3: break
    finalSum += counts[i]
  finalSum

dump part2()