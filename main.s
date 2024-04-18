# === readonly data section ===
  .include "colors.s"

  .section .rodata
TEST_FLOATS:
  .string "%.2f, %.2f\n"
WINDOW_TITLE:
  .asciz "snake game"
F1:
  .float 1.0

# === bss section ===
  .section .bss
  .lcomm score, 8             # 64 bit score
  .lcomm snake_data, 4*2*256  # size of float * Vector2 * 256

# === data section ===
#  .section .data

# === constants ===
  .equ BLOCKS_X, 25
  .equ BLOCKS_Y, 17
  .equ PIXELS_PER_BLOCK, 25
  .equ WINDOW_X, BLOCKS_X * PIXELS_PER_BLOCK
  .equ WINDOW_Y, BLOCKS_Y * PIXELS_PER_BLOCK
  .equ STARTING_SCORE, 0

  .equ KEY_NULL,  0
  .equ KEY_ESC,   256
  .equ KEY_W,     87
  .equ KEY_A,     65
  .equ KEY_S,     83
  .equ KEY_D,     68

  .equ STAL16, 0xfffffffffffffff0
  .equ ST_SNAKEDATA_ADR, 4

# === text section ===
  .section .text
  .globl _start
_start:
  # setting up the stack
  sub $8, %rsp
  movq %rsp, %rbp
  and $STAL16, %rsp

  # saving the address of snakedata to the stack
  leaq snake_data(%rip), %rax
  movq %rax, ST_SNAKEDATA_ADR(%rbp)
  # set the first Vector2 to both ones
  movss F1(%rip), %xmm0
  movss %xmm0, (%rax)
  movss %xmm0, 4(%rax)

  movq $WINDOW_X, %rdi
  movq $WINDOW_Y, %rsi
  leaq WINDOW_TITLE(%rip), %rdx
  call InitWindow

  movq $KEY_NULL, %rdi
  call SetExitKey

main_loop_begin:
_drawing:
  call BeginDrawing

  movq COLOR_WHITE(%rip), %rdi
  call ClearBackground

  movq $10, %rdi
  movq $10, %rsi
  call DrawFPS

  movq $KEY_W, %rdi
  call IsKeyDown
  test %rax, %rax
  jz no_w
  movq $40, %rdi
  movq $40, %rsi
  movq $100, %rdx
  movq $100, %rcx
  movq COLOR_RED(%rip), %r8
  call DrawRectangle
  no_w:

  call EndDrawing
  
_game_logic:

  leaq TEST_FLOATS(%rip), %rdi
  movq ST_SNAKEDATA_ADR(%rbp), %rax
  movq $0, %rbx
  cvtss2sd (%rax,%rbx,4), %xmm0
  addq $1, %rbx
  cvtss2sd (%rax,%rbx,4), %xmm1
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
