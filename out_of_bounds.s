  .include "const_def.s"

  .section .text
  .globl out_of_bounds
  # out_of_bounds: %rdi=snake pointer, %rsi=max x, %rdx=max y
  # returns 1 to %al if snake head is out of bounds
out_of_bounds:
  movq (%rdi), %r15
  movq 8(%rdi), %r14

  movq %rsi, %r13
  movq %rdx, %r12

  movq %r15, %r8
  movq %r13, %r9
  movq $-1, %r10
  cmpq %r8, %r9
  jne no_x_max
  movb $TRUE, %al
  jmp exit
no_x_max:
  cmpq %r8, %r10
  jne no_x_min
  movb $TRUE, %al
  jmp exit
no_x_min:
  movq %r14, %r8
  movq %r12, %r9
  movq $-1, %r10
  cmpq %r8, %r9
  jne no_y_max
  movb $TRUE, %al
  jmp exit
no_y_max:
  cmpq %r8, %r10
  jne no_y_min
  movb $TRUE, %al
  jmp exit
no_y_min:
  movb $FALSE, %al

exit:
  ret
