  .include "const_def.s"

  .section .text
  .type self_hit, @function
  .globl self_hit
  # self_hiy: %rdi=snake pointer, %rsi=score
self_hit:
  movq %rsi, %r14
  movq %rdi, %r15

loop:
  testq %r14, %r14
  jnz loop_continue
  movb $FALSE, %al
  jmp exit

loop_continue:
  movq %r14, %rax
  imulq $2, %rax
  movq %r15, %rdi
  leaq (%r15,%rax,8), %rsi
  call pos_check
  testb %al, %al
  jnz exit_t

  decq %r14
  jmp loop

exit_t:
  movb $TRUE, %al
exit:
  ret
