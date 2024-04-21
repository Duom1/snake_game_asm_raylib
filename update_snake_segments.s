  .type update_snake_segments, @function
  .globl update_snake_segments
  # update_snake_segments: rdi=snake data pointer, rsi=score
  .equ ST_COUNTER, -8
update_snake_segments:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp

  addq $1, %rsi
  movq %rsi, ST_COUNTER(%rbp)
loop:
  testq %rsi, %rsi
  jz exit_loop

  imulq $2, %rsi
  movq %rsi, %rcx
  subq $2, %rcx
  leaq (%rdi,%rsi,8), %rax
  movq (%rdi,%rcx,8), %r8
  movq %r8, (%rax)
  addq $1, %rsi
  addq $1, %rcx
  leaq (%rdi,%rsi,8), %rax
  movq (%rdi,%rcx,8), %r8
  movq %r8, (%rax)

  decq ST_COUNTER(%rbp)
  movq ST_COUNTER(%rbp), %rsi
  jmp loop
exit_loop:

  addq $16, %rsp
  popq %rbp
  ret
