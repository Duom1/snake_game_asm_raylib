  .type place_food, @function
  .globl place_food
  # place_food: rdi=pointer to coordinates, rsi=max x, rdx= max y
  .equ ST_COORD_PTR, -8
  .equ ST_Y, -16
place_food:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp

  decq %rsi
  decq %rdx

  movq %rdi, ST_COORD_PTR(%rbp)
  movq %rdx, ST_Y(%rbp)

  movq $0, %rdi
  call GetRandomValue
  movq ST_COORD_PTR(%rbp), %rbx
  movq %rax, (%rbx)

  movq $0, %rdi
  movq ST_Y(%rbp), %rsi
  call GetRandomValue
  movq ST_COORD_PTR(%rbp), %rbx
  movq %rax, 8(%rbx)

  addq $16, %rsp
  popq %rbp
  ret
