//===- MipsInstr64.td - Mips 64-bit Instruction Information --*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the Mips 64-bit instruction set.
//
//===----------------------------------------------------------------------===//

// 64-bit predicate
def IsMips64  : Predicate<"Subtarget.isMips64()">;

//===----------------------------------------------------------------------===//
// Instructions specific format
//===----------------------------------------------------------------------===//

class DArithOverflowR<bits<6> op, bits<6> func, string instr_asm,
                     bit isComm = 0>:
  FR<op, func, (outs CPURegs:$dst), (ins CPURegs:$b, CPURegs:$c),
     !strconcat(instr_asm, "\t$dst, $b, $c"), [], IIAlu> {
  let isCommutable = isComm;
}

class DArithOverflowI<bits<6> op, string instr_asm, SDNode OpNode,
             Operand Od, PatLeaf imm_type> :
  FI<op, (outs CPURegs:$dst), (ins CPURegs:$b, Od:$c),
     !strconcat(instr_asm, "\t$dst, $b, $c"), [], IIAlu>;

class DArithR<bits<6> op, bits<6> func, string instr_asm, SDNode OpNode,
             InstrItinClass itin, bit isComm = 0>:
  FR<op, func, (outs CPURegs:$dst), (ins CPURegs:$b, CPURegs:$c),
     !strconcat(instr_asm, "\t$dst, $b, $c"),
     [(set CPURegs:$dst, (OpNode CPURegs:$b, CPURegs:$c))], itin> {
  let isCommutable = isComm;
}

class DArithI<bits<6> op, string instr_asm, SDNode OpNode,
             Operand Od, PatLeaf imm_type> :
  FI<op, (outs CPURegs:$dst), (ins CPURegs:$b, Od:$c),
     !strconcat(instr_asm, "\t$dst, $b, $c"),
     [(set CPURegs:$dst, (OpNode CPURegs:$b, imm_type:$c))], IIAlu>;

class DLogicR_shift_rotate_imm<bits<6> func, bits<5> _rs, string instr_asm,
                              SDNode OpNode>:
  FR<0x00, func, (outs CPURegs:$dst), (ins CPURegs:$b, shamt:$c),
     !strconcat(instr_asm, "\t$dst, $b, $c"),
     [(set CPURegs:$dst, (OpNode CPURegs:$b, immZExt5:$c))], IIAlu> {
  let rs = _rs;
}

class DLogicR_shift_rotate_reg<bits<6> func, bits<5> _shamt, string instr_asm,
                              SDNode OpNode>:
  FR<0x00, func, (outs CPURegs:$dst), (ins CPURegs:$c, CPURegs:$b),
     !strconcat(instr_asm, "\t$dst, $b, $c"),
     [(set CPURegs:$dst, (OpNode CPURegs:$b, CPURegs:$c))], IIAlu> {
  let shamt = _shamt;
}


//===----------------------------------------------------------------------===//
// Instruction definition
//===----------------------------------------------------------------------===//

let Predicates = [IsMips64] in {
def DADD    : DArithOverflowR<0x00, 0x2c, "dadd", 1>;
//Find where this is being cracked open to check stuff like commutability
def DSUB    : DArithOverflowR<0x00, 0x2e, "dsub">;
def DADDI   : DArithOverflowI<0x18, "daddi", add, simm16, immSExt16>;
def DADDIU  : DArithI<0x19, "daddiu", add, simm16, immSExt16>;
def DADDU   : DArithR<0x00, 0x2d, "daddu", 1>;
def DSUBU   : DArithR<0x00, 0x2f, "dsubu">;

//What is second column
def DSLL    : DLogicR_shift_rotate_imm<0x38, 0x00, "dsll", shl>;
def DSRL    : DLogicR_shift_rotate_imm<0x3a, 0x00, "dsrl", srl>;
def DSRA    : DLogicR_shift_rotate_imm<0x3b, 0x00, "dsra", sra>;
def DSLLV   : DLogicR_shift_rotate_reg<0x14, 0x00, "dsllv", shl>;
def DSRLV   : DLogicR_shift_rotate_reg<0x16, 0x00, "dsrlv", srl>;
def DSRAV   : DLogicR_shift_rotate_reg<0x17, 0x00, "dsrav", sra>;

//Not sure how to implement, may be a way in
//def DSLL32  : DLogicR_shift_rotate_imm<0x3c, 0x

def DDIV    : DDiv
} //end of "let Predicates = [IsMips64]
