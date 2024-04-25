  .include "color_def.s"

  .section .text
  .type draw_food, @function
  .globl draw_food
  # draw_food rdi=pointer to food coordinates rsi=block size
draw_food:
  movq (%rdi), %r8
  movq 8(%rdi), %r9
  movq %rsi, %rdx
  movq %rsi, %rcx
  movq %rsi, %rdi
  movq %rsi, %rsi
  imulq %r8, %rdi
  imulq %r9, %rsi
  movq $COLOR_RED, %r8
  call DrawRectangle

  ret
