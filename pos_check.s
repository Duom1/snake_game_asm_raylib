  .include "const_def.s"

  .section .text
  .globl pos_check
  # pos_check: %rdi=first pos, %rsi=second pos
  # Return true or false in %rax.
  # The size of eacg position is expected to be 16 bytes
  # (int64, int64)
  .equ LOCAL_ST, 32
  .equ ST_FIRST_Y, -8
  .equ ST_FIRST_X, -16
  .equ ST_SECOND_Y, -24
  .equ ST_SECOND_X, -32
pos_check:
  pushq %rbp
  movq %rsp, %rbp
  subq $LOCAL_ST, %rsp

  movb $FALSE, %al

  movq (%rdi), %rbx
  movq %rbx, ST_FIRST_X(%rbp)
  movq 8(%rdi), %rbx
  movq %rbx, ST_FIRST_Y(%rbp)
  movq (%rsi), %rbx
  movq %rbx, ST_SECOND_X(%rbp)
  movq 8(%rsi), %rbx
  movq %rbx, ST_SECOND_Y(%rbp)

  movq ST_FIRST_X(%rbp), %r8
  movq ST_SECOND_X(%rbp), %r9
  cmpq %r8, %r9
  jne exit
  movq ST_FIRST_Y(%rbp), %r8
  movq ST_SECOND_Y(%rbp), %r9
  cmpq %r8, %r9
  jne exit
  movb $TRUE, %al
exit:

  addq $LOCAL_ST, %rsp
  popq %rbp
  ret
