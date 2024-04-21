  .include "const_def.s"
  .type eat_check, @function
  .globl eat_check
  # eat_check: rdi=food position pointer, rsi=snake head pointer
  # return true or false on %rax
eat_check:
  pushq %rbp
  movq %rsp, %rbp

  movq $FALSE, %rax
  movq (%rdi), %r8
  movq (%rsi), %r9
  cmpq %r8, %r9
  jne no_eating
  movq 8(%rdi), %r8
  movq 8(%rsi), %r9
  cmpq %r8, %r9
  jne no_eating
  movq $TRUE, %rax
no_eating:

  popq %rbp
  ret
