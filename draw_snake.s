  .include "color_def.s"

  .type draw_snake, @function
  .globl draw_snake
  # draw_snake rdi=pointer to snakedata rsi=block size
draw_snake:
  pushq %rbp
  movq %rsp, %rbp

  movq (%rdi), %r8
  movq 8(%rdi), %r9
  movq %rsi, %rdx
  movq %rsi, %rcx
  movq %rsi, %rdi
  movq %rsi, %rsi
  imulq %r8, %rdi
  imulq %r9, %rsi
  movq $COLOR_GREEN, %r8
  call DrawRectangle

  popq %rbp
  ret
