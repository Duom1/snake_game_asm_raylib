  .include "key_def.s"
  .include "dir_def.s"

  .type get_input, @function
  .globl get_input
  .equ ST_LDIR, -4
get_input:
  pushq %rbp
  movq %rsp, %rbp
  subq $4, %rsp

  movq $0, ST_LDIR(%rbp)

  movq $KEY_W, %rdi
  call IsKeyDown
  test %rax, %rax
  jz no_w
  movq $DIR_UP, ST_LDIR(%rbp)
no_w:
  movq $KEY_A, %rdi
  call IsKeyDown
  test %rax, %rax
  jz no_a
  movq $DIR_LEFT, ST_LDIR(%rbp)
no_a:
  movq $KEY_S, %rdi
  call IsKeyDown
  test %rax, %rax
  jz no_s
  movq $DIR_DOWN, ST_LDIR(%rbp)
no_s:
  movq $KEY_D, %rdi
  call IsKeyDown
  test %rax, %rax
  jz no_d
  movq $DIR_RIGHT, ST_LDIR(%rbp)
no_d:

  movq ST_LDIR(%rbp), %rax

  addq $4, %rsp
  popq %rbp
  ret
