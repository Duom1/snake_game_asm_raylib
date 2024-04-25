  .type place_food, @function
  .globl place_food
  # place_food: rdi=pointer to coordinates, rsi=max x, rdx= max y,
  # rcx=snake pointer, r8=score
  .equ LOCAL_ST, 16
place_food:
  pushq %rbp
  movq %rsp, %rbp
  subq $LOCAL_ST, %rsp

  decq %rsi
  decq %rdx
  incq %r8

  pushq %rcx
  pushq %r8
  pushq %rdi
  pushq %rdx
  pushq %rsi

generate:
  movq %rdx, %r15
  movq $0, %rdi
  call GetRandomValue
  movq %rax, %r14

  movq $0, %rdi
  movq %r15, %rsi
  call GetRandomValue
  popq %rdi
  movq %rax, 8(%rdi)
  movq %r14, (%rdi)

  popq %r15 # score
  popq %r12 # pointer to snake
  movq $0, %r14 #counter
  movq %rdi, %r13 # pointer to food pos
check_loop:
  movq %r14, %rax
  imulq $2, %rax
  leaq (%r12,%rax,8), %rdi
  movq %r13, %rsi
  call pos_check
  testb %al, %al
  #jz generate

  incq %r14
  cmpq %r15, %r14
  jne check_loop
  
  addq $LOCAL_ST, %rsp
  popq %rbp
  ret
