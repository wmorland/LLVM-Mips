//===-- MipsTargetInfo.cpp - Mips Target Implementation -------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Mips.h"
#include "llvm/Module.h"
#include "llvm/Target/TargetRegistry.h"
using namespace llvm;

Target llvm::TheMipsTarget, llvm::TheMipselTarget, llvm:TheMips64Target;

extern "C" void LLVMInitializeMipsTargetInfo() {
  RegisterTarget<Triple::mips,
        /*HasJIT=*/true> X(TheMipsTarget, "mips", "Mips");

  RegisterTarget<Triple::mipsel,
        /*HasJIT=*/true> Y(TheMipselTarget, "mipsel", "Mipsel");

  RegisterTarget<Triple::mips64,
        /*HasJIT=*/true> Z(TheMips64Target, "mips64", "Mips64");
}
