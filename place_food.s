  .include "const_def.s"

  .type place_food, @function
  .globl place_food
  # place_food: rdi=pointer to coordinates, rsi=max x, rdx= max y,
  # rcx=snake pointer, r8=score
  .equ LOCAL_ST, 48
  #.equ ST_COORD_PTR, -8
  #.equ ST_SNAKE_PTR, -16
  #.equ ST_Y, -24
  #.equ ST_X, -32
  #.equ ST_SCORE, -40
  .equ ST_Y_MAX, -8
  .equ ST_X_MAX, -16
  .equ ST_OG_SCORE, -24
  .equ ST_FF, -40
  .equ ST_LAST, -41
place_food:
  pushq %rbp
  movq %rsp, %rbp
  subq $LOCAL_ST, %rsp

  decq %rsi
  decq %rdx
  movq %rsi, ST_X_MAX(%rbp)
  movq %rdx, ST_Y_MAX(%rbp)
  movq %r8, ST_OG_SCORE(%rbp)
  movq %rdi, %r15
  movq %rcx, %r14
  #movq %rdi, ST_COORD_PTR(%rbp)
  #movq %rcx, ST_SNAKE_PTR(%rbp)

generate_numbers:
  movq ST_X_MAX(%rbp), %rsi
  movq $0, %rdi
  call GetRandomValue
  movq %rax, %r13
  movq ST_Y_MAX(%rbp), %rsi
  movq $0, %rdi
  call GetRandomValue
  movq %rax, %r12

  movq ST_OG_SCORE(%rbp), %rbx
  
  jmp exit_check

check_loop:
  movq %r15, %rcx
  movq %rbx, %rax
  imulq $2, %rax
  leaq (%rcx,%rax,8), %rdi
  leaq ST_FF(%rbp), %rsi
  movq %r13, (%rsi)
  movq %r12, 8(%rsi)
  call pos_check
  testb %al, %al
  jnz continue
  jmp generate_numbers
continue:

  decq %rbx
exit_check:
  cmpq $0 , %rbx
  jne check_loop

  movq %r13, (%r15)
  movq %r12, 8(%r15)

  addq $LOCAL_ST, %rsp
  popq %rbp
  ret
