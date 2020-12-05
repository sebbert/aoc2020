import sugar, tables, sets, strutils, sequtils, options
import nre except toSeq

let file = readFile("input.txt")

iterator passports(file: string): Table[string, string] =
  for entry in split(file, "\n\n"):
    yield collect(initTable(2)):
      for field in entry.split({' ', '\n'}):
        let parts = field.split(':')
        { parts[0]: parts[1] }

let allPassports = toSeq(passports(file))

let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
let passportsWithRequiredFields =
  allPassports.filter(passport =>
    requiredFields.all(k => passport.hasKey(k)))

echo "Part 1: ", passportsWithRequiredFields.len()

proc attempt[A, B](fn: A -> B, value: A): Option[B] =
  try: option(fn(value))
  except: none[B]()

proc isValidYear(year: string, range: Slice[int]): bool =
  parseInt
    .attempt(year)
    .map(year => year in range)
    .get(false)

proc combine[L, R](left: Option[L], right: Option[R]): Option[(L, R)] =
  left.flatMap(
    proc(l: L): Option[(L, R)] =
      right.map(
        proc(r: R): (L, R) = (l, r)))

type
  HeightUnit = enum Centimeters, Inches
  Height = tuple
    value: int
    unit: HeightUnit

proc parseHeightUnit(unit: string): Option[HeightUnit] =
  case unit
  of "cm": some(Centimeters)
  of "in": some(Inches)
  else: none(HeightUnit)


let heightRegex = re"^(\d+)(cm|in)$"
proc parseHeight(height: string): Option[Height] =
  height.find(heightRegex).flatMap(
    proc(match: RegexMatch): Option[Height] =
      combine(
        parseInt.attempt(match.captures[0]),
        parseHeightUnit(match.captures[1])
      )
  )

proc validRange(unit: HeightUnit): Slice[int] =
  case unit:
    of Centimeters: 150..193
    of Inches: 59..76

proc isValid(height: Height): bool = height.value in height.unit.validRange()

proc doesMatch(str: string, regex: Regex): bool =
  str.find(regex).isSome()

proc isValidHexColor(color: string): bool =
  color.doesMatch(re"^#[0-9a-f]{6}$")

let validEyeColors = toHashSet(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

proc isValidEyeColor(ecl: string): bool = ecl in validEyeColors

proc isValidPassportID(id: string): bool = id.doesMatch(re"^\d{9}$")

proc hasValidData(passport: Table[string, string]): bool =
  passport["byr"].isValidYear(1920..2002) and
  passport["iyr"].isValidYear(2010..2020) and
  passport["eyr"].isValidYear(2020..2030) and
  passport["hgt"].parseHeight().map(isValid).get(false) and
  passport["hcl"].isValidHexColor() and
  passport["ecl"].isValidEyeColor() and
  passport["pid"].isValidPassportID()

let validPassports = passportsWithRequiredFields.filter(hasValidData)

echo "Part 2: ", validPassports.len()