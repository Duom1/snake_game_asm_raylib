  .include "color_def.s"

  .type draw_snake, @function
  .globl draw_snake
  # draw_snake rdi=pointer to snakedata rsi=block size, rdx=score
  .equ ST_COUNTER, -8
  .equ ST_SCORE, -16
  .equ ST_SNAKE, -24
  .equ ST_BLOCK_SIZE, -32
draw_snake:
  pushq %rbp
  movq %rsp, %rbp
  subq $32, %rsp

  movq %rsi, ST_BLOCK_SIZE(%rbp)
  movq %rdi, ST_SNAKE(%rbp)
  movq %rdx, ST_SCORE(%rbp)
  incq ST_SCORE(%rbp)
  movq $0, ST_COUNTER(%rbp)
loop:
  cmpq ST_SCORE(%rbp), %rdx
  je exit_loop

  movq ST_SNAKE(%rbp), %rbx
  movq ST_COUNTER(%rbp), %rax
  imulq $2, %rax
  movq (%rbx,%rax,8), %rdi
  addq $1, %rax
  movq (%rbx,%rax,8), %rsi
  movq ST_BLOCK_SIZE(%rbp), %rdx
  movq %rdx, %rcx
  imulq %rdx, %rdi
  imulq %rdx, %rsi
  movq $COLOR_GREEN, %r8
  # rdi=x, rsi=y, rdx=width, rcx=height, r8=color
  call DrawRectangle

  incq ST_COUNTER(%rbp)
  movq ST_COUNTER(%rbp), %rdx
  jmp loop
exit_loop:

  addq $32, %rsp
  popq %rbp
  ret
