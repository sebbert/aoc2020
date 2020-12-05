import strutils, sequtils, strformat, sets

let file = readFile("input.txt")
let lines = file.splitLines().filterIt(it.len() > 0)

type
  Half = enum Lower, Upper
  Direction = enum Row, Col
  Partitioning = tuple
    direction: Direction
    half: Half
  Grid = object
    rows: Slice[int]
    cols: Slice[int]

proc midpoint(slice: Slice[int]): int =
  slice.a + (slice.b - slice.a) div 2

proc partition(slice: Slice[int], half: Half): Slice[int] =
  case half
  of Lower: slice.a .. slice.midpoint
  of Upper: slice.midpoint+1 .. slice.b

proc parsePartitioning(op: char): Partitioning =
  case op
  of 'F': (Row, Lower)
  of 'B': (Row, Upper)
  of 'L': (Col, Lower)
  of 'R': (Col, Upper)
  else: raiseAssert(fmt"Invalid instruction {op}")

proc partition(grid: var Grid, op: char) =
  let (direction, half) = parsePartitioning(op)

  case direction
  of Row: grid.rows = partition(grid.rows, half)
  of Col: grid.cols = partition(grid.cols, half)

proc initialGrid(): Grid = Grid(rows: 0..127, cols: 0..7)

proc printGrid(grid: Grid) =
  # Prints the grid rotated 90 degress, as it fits better on a terminal display
  var rowStr = newString(128)
  for col in 0..7:
    for row in 0..127:
      rowStr[row] =
        if row in grid.rows and col in grid.cols: '#'
        else: '.'
    
    echo rowStr
  echo ""

proc seatPosition(ops: string): (int, int) =
  var grid = initialGrid()
  for op in ops:
    partition(grid, op)

  assert(grid.rows.len() == 1, "Exact match on row")
  assert(grid.cols.len() == 1, "Exact match on column")

  (grid.rows.a, grid.cols.a)

proc seatID(pos: (int, int)): int =
  let (row, col) = pos
  row*8 + col

let seatPositions = lines.map(seatPosition)
let seatIds = seatPositions.map(seatID)

echo "Part 1: ", seatIds.max()

let missingSeatIds = (0..(7*127)).toSeq.filterIt(not (it in seatIds))

echo "Missing seat IDs: ", missingSeatIds