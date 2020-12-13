import sugar, strutils, sequtils, algorithm, deques, strformat

let file = readFile("input.txt")
let numbers = file.splitLines().filterIt(it.len() > 0).map(parseInt)

var window = initDeque[int]()

proc containsSum[T](window: var Deque[T], target: T): bool =
  for a in window:
    for b in window:
      if a != b and (a+b == target):
        return true

proc part1(): int =
  for number in numbers:
    if window.len() < 25:
      window.addLast(number)
    elif window.len() > 25:
      raiseAssert("Window should never grow beyond 25")
    else:
      if not window.containsSum(number):
        return number
      discard window.popFirst()
      window.addLast(number)

  raiseAssert("No solution was found")

let firstInvalidNumber = part1()
echo "Part 1: ", firstInvalidNumber

proc rangeSummingToK(values: openArray[int], k: int): Slice[int] =
  var slice = 0..1
  var sum = numbers[slice.a] + numbers[slice.b]
  while slice.b < numbers.len():
    if sum == k:
      return slice
    elif sum < k:
      slice.b += 1
      sum += values[slice.b]
    elif sum > k:
      sum -= values[slice.a]
      slice.a += 1
      assert(slice.a < slice.b)

  raiseAssert(fmt"Did not find a subarray summing to {k}")

let part2Range = rangeSummingToK(numbers, firstInvalidNumber)
let part2Sum = part2Range.mapIt(numbers[it]).foldl(a + b)
assert(part2Sum == firstInvalidNumber) # Verify the solution

var min = firstInvalidNumber
var max = 0
for index in part2Range:
  let n = numbers[index]
  if n < min: min = n
  if n > max: max = n

echo "Part 2: ", min + max