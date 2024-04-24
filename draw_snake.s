  .include "color_def.s"

  .type draw_snake, @function
  .globl draw_snake
  # draw_snake rdi=pointer to snakedata rsi=block size, rdx=score
draw_snake:
  movq %rsi, %r15
  movq %rdi, %r14
  movq %rdx, %r13
  movq $0, %r12
loop:
  movq %r12, %rax
  imulq $2, %rax
  movq (%r14,%rax,8), %rdi
  addq $1, %rax
  movq (%r14,%rax,8), %rsi
  movq %r15, %rdx
  movq %rdx, %rcx
  imulq %rdx, %rdi
  imulq %rdx, %rsi
  movq $COLOR_GREEN, %r8
  call DrawRectangle

  incq %r12
  cmpq %r13, %r12
  jng loop

  ret
