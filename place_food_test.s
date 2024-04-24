  .include "const_def.s"
  # This is a program to test the place_food function.
  # If it just hangs without giving any input the ""test"" passes.
  # That is because the entire playing field if full and 
  # the function is trying to find a random coordinate to place the
  # food but it just hangs.

  .section .rodata # rodtata
fmt:
  .string "%i, %i\n"
seed:
  .quad 0x66ea76ade53ff10a

  .section .bss # bss
  .lcomm POS, 16

  .section .data # data
snake:
  .quad 0,0, 1,0, 2,0, 3,0,  0,1, 1,1, 2,1, 3,1
  .quad 0,2, 1,2, 2,2, 3,2,  0,3, 1,3, 2,3, 3,3

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
  movq $15, %r8
  call place_food
  leaq fmt(%rip), %rdi
  leaq POS(%rip), %rax
  movq (%rax), %rsi
  movq 8(%rax), %rdx
  call printf

  movl $60, %eax
  xorl %ebx, %ebx
  syscall
