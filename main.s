  .include "colors.s"

  .section .rodata
TEST_FLOATS:
  .string "%f, %f\n"
TEST_FLOAT:
  .string "%.4f\n"
TEST_INT:
  .string "%i\n"
TEST_HEX:
  .string "%x\n"

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
test_val:
  .float 3.1415
snake_data:
  .float 1.2
  .float 1.7
  .rept 255
  .float 0.0
  .float 0.0
  .endr

  .globl _start
  .section .text
_start:
  movq $WINDOW_X, %rdi
  movq $WINDOW_Y, %rsi
  leaq WINDOW_TITLE(%rip), %rdx
  call InitWindow

main_loop_begin:
  call BeginDrawing

  movq COLOR_WHITE(%rip), %rdi
  call ClearBackground

  call EndDrawing

  sub $8, %rsp
  and $STAL16, %rsp
  pxor %xmm0, %xmm0
  cvtss2sd test_val(%rip), %xmm0
  movq $1, %rax
  leaq TEST_FLOAT(%rip), %rdi
  call printf
  add $8, %rsp

_window_close_check:
  sub $8, %rsp
  call WindowShouldClose
  testq %rax, %rax
  jz main_loop_begin

main_loop_exit:
  call CloseWindow

exit_program:
  movq $60, %rax
  xor %rbx, %rbx
  syscall
