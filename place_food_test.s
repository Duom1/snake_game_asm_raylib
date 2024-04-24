  .include "const_def.s"
  # This is a program to test the place_food function.

  .section .rodata # rodtata
fmt:
  .string "%i, %i\n"
exp:
  .string "expected to be: 3, 3"
seed:
  .quad 0x61ea76ade53ff10a

  .section .bss # bss
  .lcomm POS, 16

  .section .data # data
snake:
  .quad 0,0, 1,0, 2,0, 3,0,  0,1, 1,1, 2,1, 3,1
  .quad 0,2, 1,2, 2,2, 3,2,  0,3, 1,3, 2,3

  .section .text #text
  .globl _start
_start:
  subq $8, %rsp
  and $STAL16, %rsp

  leaq seed, %rax
  movq (%rax), %rdi
  call SetRandomSeed

  leaq POS(%rip), %rdi
  leaq snake(%rip), %rcx
  movq $4, %rsi
  movq $4, %rdx
  movq $14, %r8
  call place_food

  leaq exp(%rip), %rdi
  call puts

  leaq fmt(%rip), %rdi
  leaq POS(%rip), %rax
  movq (%rax), %rsi
  movq 8(%rax), %rdx
  call printf

  movl $60, %eax
  xorl %edi, %edi
  syscall
