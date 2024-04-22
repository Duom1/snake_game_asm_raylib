  .type place_food, @function
  .globl place_food
  # place_food: rdi=pointer to coordinates, rsi=max x, rdx= max y,
  # rcx=snake pointer, r8=score
  .equ LOCAL_ST, 64
  .equ ST_COORD_PTR, -8
  .equ ST_SNAKE_PTR, -16
  .equ ST_X, -24
  .equ ST_Y, -32
  .equ ST_SCORE, -40
  .equ ST_X_MAX, -48
  .equ ST_Y_MAX, -56
place_food:
  pushq %rbp
  movq %rsp, %rbp
  subq $LOCAL_ST, %rsp

  decq %rsi
  decq %rdx
  movq %rsi, ST_X_MAX(%rbp)
  movq %rdx, ST_Y_MAX(%rbp)
  movq %r8, ST_SCORE(%rbp)
  movq %rdi, ST_COORD_PTR(%rbp)
  movq %rcx, ST_SNAKE_PTR(%rbp)

  movq ST_X_MAX(%rbp), %rsi
  movq $0, %rdi
  call GetRandomValue
  movq %rax, ST_X(%rbp)
  movq ST_Y_MAX(%rbp), %rsi
  movq $0, %rdi
  call GetRandomValue
  movq %rax, ST_Y(%rbp)

  movq ST_COORD_PTR(%rbp), %rbx
  movq ST_X(%rbp), %rcx
  movq %rcx, (%rbx)
  movq ST_Y(%rbp), %rcx
  movq %rcx, 8(%rbx)

  addq $LOCAL_ST, %rsp
  popq %rbp
  ret
