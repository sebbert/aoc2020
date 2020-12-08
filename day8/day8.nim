import sugar, strutils, strformat, sequtils

type
  Instruction* = tuple
    op: Opcode
    arg: int
  Opcode* = enum opNop, opAcc, opJmp

proc parseOpcode(op: string): Opcode =
  case op
  of "nop": opNop
  of "acc": opAcc
  of "jmp": opJmp
  else: raiseAssert(fmt"Invalid opcode '{op}'")

proc parseInstruction(line: string): Instruction =
  let parts = line.splitWhitespace()
  assert(parts.len() == 2)
  let op = parseOpcode(parts[0])
  let arg = parseInt(parts[1])
  (op, arg)

proc parseProgram(program: string): seq[Instruction] =
  program.splitLines().filterIt(it.len() > 0).map(parseInstruction)

type
  Cpu = object
    program: seq[Instruction]
    pc: int
    acc: int

proc initCpu(program: seq[Instruction]): Cpu =
  Cpu(program: program, pc: 0, acc: 0)

proc isHalted(cpu: var Cpu): bool =
  cpu.pc >= cpu.program.len()

proc step(cpu: var Cpu) =
  if cpu.isHalted:
    echo "Attempted to step halted CPU"
    return
  let (op, arg) = cpu.program[cpu.pc]
  var pcOffset = 1
  case op
  of opNop: discard
  of opAcc: cpu.acc += arg
  of opJmp: pcOffset = arg
  cpu.pc += pcOffset

let program = parseProgram(readFile("input.txt"))

proc part1(): int =
  var cpu = initCpu(program)
  var visited = newSeq[bool](program.len())
  while not visited[cpu.pc]:
    visited[cpu.pc] = true
    cpu.step()
  cpu.acc

dump(part1())

proc part2(): int =
  for (index, instruction) in program.pairs:
    let (op, _) = instruction
    if op == opNop or op == opJmp:
      var mutatedProgram = program
      mutatedProgram[index].op = case op:
        of opJmp: opNop
        of opNop: opJmp
        else: raiseAssert("Unreachable")
      
      var visited = newSeq[bool](mutatedProgram.len())
      var cpu = initCpu(mutatedProgram)
      while not cpu.isHalted and not visited[cpu.pc]:
        visited[cpu.pc] = true
        cpu.step()

      if cpu.isHalted: return cpu.acc

  raiseAssert("No solution was found")

dump(part2())