  .include "const_def.s"

  # this is a program to test the pos_check function
  .section .rodata
equal:
  .string "equal"
not_equal:
  .string "not equal"
  .section .data
first_pos:
  .quad 4,4
second_pos:
  .quad 4,4
third_pos:
  .quad 2,8
fourth_pos:
  .quad 3,8
  .section .text
  .globl _start
_start:
  subq $8, %rsp
  andq $STAL16, %rsp

  leaq first_pos(%rip), %rdi
  leaq second_pos(%rip), %rsi
  call pos_check
  testb %al, %al
  jz not_e_1
  leaq equal(%rip), %rdi
  call puts
  jmp next
not_e_1:
  leaq not_equal(%rip), %rdi
  call puts
next:
  leaq third_pos(%rip), %rdi
  leaq fourth_pos(%rip), %rsi
  call pos_check
  testb %al, %al
  jz not_e_2
  leaq equal(%rip), %rdi
  call puts
  jmp exit
not_e_2:
  leaq not_equal(%rip), %rdi
  call puts
exit:

  movq $60, %rax
  xorq %rdi, %rdi
  syscall
