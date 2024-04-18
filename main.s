  .include "colors.s"

  .section .rodata
TEST_FLOATS:
  .string "%f, %f\n"
TEST_FLOAT:
  .string "%.4f\n"

WINDOW_TITLE:
  .asciz "snake game"

  .equ STAL16, 0xfffffffffffffff0
  .equ BLOCKS_X, 25
  .equ BLOCKS_Y, 17
  .equ PIXELS_PER_BLOCK, 25
  .equ WINDOW_X, BLOCKS_X * PIXELS_PER_BLOCK
  .equ WINDOW_Y, BLOCKS_Y * PIXELS_PER_BLOCK

  .section .data
score:
  .long 0
snake_data:
  .float 1.0
  .float 1.0
  .rept 255
  .float 0.0
  .float 0.0
  .endr

  .globl _start
  .section .text
_start:
  sub $8, %rsp
  and $STAL16, %rsp

  movq $WINDOW_X, %rdi
  movq $WINDOW_Y, %rsi
  leaq WINDOW_TITLE(%rip), %rdx
  call InitWindow

main_loop_begin:
  call BeginDrawing

  movq COLOR_WHITE(%rip), %rdi
  call ClearBackground

  movq $10, %rdi
  movq $10, %rsi
  call DrawFPS

  call EndDrawing

  leaq TEST_FLOAT(%rip), %rdi
  cvtss2sd snake_data(%rip), %xmm0
  mov $1, %rax
  call printf

_window_close_check:
  call WindowShouldClose
  testq %rax, %rax
  jz main_loop_begin

main_loop_exit:
  call CloseWindow

exit_program:
  movq $60, %rax
  xor %rbx, %rbx
  syscall
