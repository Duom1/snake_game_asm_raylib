  .include "const_def.s"

  .section .text
  .globl out_of_bounds
  # out_of_bounds: %rdi=snake pointer, %rsi=max x, %rdx=max y
  # returns 1 to %al if snake head is out of bounds
  .equ LOCAL_ST, 48
  .equ ST_HEAD_Y, -8
  .equ ST_HEAD_X, -16
  .equ ST_SCORE, -24
  .equ ST_MAX_X, -32
  .equ ST_MAX_Y, -40
out_of_bounds:
  pushq %rbp
  movq %rsp, %rbp
  subq $LOCAL_ST, %rsp

  movq (%rdi), %rbx 
  movq %rbx, ST_HEAD_X(%rbp)
  movq 8(%rdi), %rbx 
  movq %rbx, ST_HEAD_Y(%rbp)

  movq %rsi, ST_MAX_X(%rbp)
  movq %rdx, ST_MAX_Y(%rbp)

  movq ST_HEAD_X(%rbp), %r8
  movq ST_MAX_X(%rbp), %r9
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
  movq ST_HEAD_Y(%rbp), %r8
  movq ST_MAX_Y(%rbp), %r9
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
  addq $LOCAL_ST, %rsp
  popq %rbp
  ret
