  .include "key_def.s"
  .include "dir_def.s"

  .type get_input, @function
  .globl get_input
  .equ ST_LDIR, -4
get_input:
  pushq %rbp
  movq %rsp, %rbp
  subq $4, %rsp

  movl $0, ST_LDIR(%rbp)

  movl $KEY_W, %edi
  call IsKeyDown
  test %rax, %rax
  jz no_w
  movl $DIR_UP, ST_LDIR(%rbp)
no_w:
  movl $KEY_A, %edi
  call IsKeyDown
  test %rax, %rax
  jz no_a
  movl $DIR_LEFT, ST_LDIR(%rbp)
no_a:
  movl $KEY_S, %edi
  call IsKeyDown
  test %rax, %rax
  jz no_s
  movl $DIR_DOWN, ST_LDIR(%rbp)
no_s:
  movl $KEY_D, %edi
  call IsKeyDown
  test %rax, %rax
  jz no_d
  movl $DIR_RIGHT, ST_LDIR(%rbp)
no_d:

  movl ST_LDIR(%rbp), %eax

  addq $4, %rsp
  popq %rbp
  ret
