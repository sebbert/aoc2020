import sugar, strutils, sequtils, nre, tables, sets

type
  Rule* = tuple
    color: string
    children: seq[Child]

  Child* = tuple
    count: int
    color: string

proc parseRule(desc: string): Rule =
  let color = desc.find(re"^([a-z]+ [a-z]+)").get().captures[0]
  var children: seq[Child] = @[]
  for match in desc.findIter(re"(\d+) ([a-z]+ [a-z]+) bags?[.,]"):
    children.add (
      count: parseInt(match.captures[0]),
      color: match.captures[1]
    )
  (color, children)

let file = readFile("input.txt")
let lines = file.splitLines().filterIt(it.len() > 0)
let rules = lines.map(parseRule)

let invertedGraph = newTable[string, HashSet[string]]()
for rule in rules:
  for child in rule.children:
    if child.count > 0:
      invertedGraph.mgetOrPut(child.color, initHashSet[string]()).incl(rule.color)

proc collectParents(
  child: string,
  visited: var HashSet[string]
): void =
  if child notin invertedGraph:
    return
  let parents = invertedGraph[child]
  for parent in parents:
    if parent notin visited:
      visited.incl(parent)
      collectParents(parent, visited)

var canContainShinyGoldBag = initHashSet[string]()
collectParents("shiny gold", canContainShinyGoldBag)

echo "Part 1: ", canContainShinyGoldBag.len()

let ruleTable = rules.toTable
proc countChildren(color: string): int =
  let children = ruleTable[color]
  for child in children:
    result += child.count + child.count * child.color.countChildren()

echo "Part 2: ", countChildren("shiny gold")