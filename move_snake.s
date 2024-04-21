  .type move_snake, @function
  .globl move_snake
  # move_snake: rdi=pointer to snake head, esi=direction
move_snake:
  pushq %rbp
  movq %rsp, %rbp

  cmpl $1, %esi
  je go_up
  cmpl $2, %esi
  je go_down
  cmpl $3, %esi
  je go_left
  cmpl $4, %esi
  je go_right
  jmp continue
go_up:
  decq 8(%rdi)
  jmp continue
go_down:
  incq 8(%rdi)
  jmp continue
go_left:
  decq (%rdi)
  jmp continue
go_right:
  incq (%rdi)
  jmp continue
continue:

  popq %rbp
  ret
