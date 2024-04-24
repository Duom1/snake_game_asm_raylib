  .include "key_def.s"
  .include "dir_def.s"
  .include "const_def.s"

  .type get_input, @function
  .globl get_input
  .equ LOCAL_ST, 16
  .equ ST_LDIR, -4
  .equ ST_PAUSE_PTR, -12
  # get_input: %rdi=pause pointer
get_input:
  pushq %rbp
  movq %rsp, %rbp
  subq $LOCAL_ST, %rsp

  movl $0, ST_LDIR(%rbp)
  movq %rdi, ST_PAUSE_PTR(%rbp)

  movl $KEY_ESC, %edi
  call IsKeyPressed
  testb %al, %al
  jz no_esc
  movq ST_PAUSE_PTR(%rbp), %rax
  movb (%rax), %bl
  testb %bl, %bl
  jz make_t
  movb $FALSE, (%rax)
  jmp no_d
make_t:
  movb $TRUE, (%rax)
  jmp no_d
no_esc:
  movl $KEY_W, %edi
  call IsKeyDown
  testb %al, %al
  jz no_w
  movl $DIR_UP, ST_LDIR(%rbp)
no_w:
  movl $KEY_A, %edi
  call IsKeyDown
  testb %al, %al
  jz no_a
  movl $DIR_LEFT, ST_LDIR(%rbp)
no_a:
  movl $KEY_S, %edi
  call IsKeyDown
  testb %al, %al
  jz no_s
  movl $DIR_DOWN, ST_LDIR(%rbp)
no_s:
  movl $KEY_D, %edi
  call IsKeyDown
  testb %al, %al
  jz no_d
  movl $DIR_RIGHT, ST_LDIR(%rbp)
no_d:

  movl ST_LDIR(%rbp), %eax

  addq $LOCAL_ST, %rsp
  popq %rbp
  ret
