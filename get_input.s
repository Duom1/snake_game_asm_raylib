  .include "key_def.s"
  .include "dir_def.s"
  .include "const_def.s"

  .type get_input, @function
  .globl get_input
  # get_input: %rdi=pause pointer
get_input:

  movl $0, %r15d
  movq %rdi, %r14

  movl $KEY_ESC, %edi
  call IsKeyPressed
  testb %al, %al
  jz no_esc
  movb (%r14), %bl
  testb %bl, %bl
  jz make_t
  movb $FALSE, (%r14)
  jmp no_d
make_t:
  movb $TRUE, (%r14)
  jmp no_d
no_esc:
  movl $KEY_W, %edi
  call IsKeyDown
  testb %al, %al
  jz no_w
  movl $DIR_UP, %r15d
no_w:
  movl $KEY_A, %edi
  call IsKeyDown
  testb %al, %al
  jz no_a
  movl $DIR_LEFT, %r15d
no_a:
  movl $KEY_S, %edi
  call IsKeyDown
  testb %al, %al
  jz no_s
  movl $DIR_DOWN, %r15d
no_s:
  movl $KEY_D, %edi
  call IsKeyDown
  testb %al, %al
  jz no_d
  movl $DIR_RIGHT, %r15d
no_d:

  movl %r15d, %eax

  ret
