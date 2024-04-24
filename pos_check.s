  .include "const_def.s"

  .section .text
  .globl pos_check
  # pos_check: %rdi=first pos, %rsi=second pos
  # Return true or false in %rax.
  # The size of each position is expected to be 16 bytes
  # (int64, int64)
pos_check:
  movb $FALSE, %al

  movq (%rdi), %r8
  movq (%rsi), %r9
  cmpq %r8, %r9
  jne exit
  movq 8(%rdi), %r8
  movq 8(%rsi), %r9
  cmpq %r8, %r9
  jne exit
  movb $TRUE, %al
exit:

  ret
