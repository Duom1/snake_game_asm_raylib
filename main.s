# === constants ===
  .equ BLOCKS_X, 15
  .equ BLOCKS_Y, 12
  .equ PIXELS_PER_BLOCK, 50
  .equ WINDOW_X, BLOCKS_X * PIXELS_PER_BLOCK
  .equ WINDOW_Y, BLOCKS_Y * PIXELS_PER_BLOCK
  .equ STARTING_SCORE, 0
  .equ TARGET_FPS, 60
  .equ UPDATE_FR, 18

  .include "key_def.s"
  .include "dir_def.s"
  .include "color_def.s"

  .equ STAL16, 0xfffffffffffffff0

# === readonly data section ===
  .section .rodata
TEST_FLOATS:
  .string "%.2f, %.2f\n"
TEST_INT:
  .string "%i\n"
WINDOW_TITLE:
  .string "snake game"

# === bss section ===
  .section .bss
  .lcomm score, 8             # 64 bit score
  .lcomm snake_data, 8*2*256  # size of quad word * vec2 * 256
  .lcomm snake_data_ptr, 8    # this is used to store the pointer to snake_data
  .lcomm update_cnt, 8        # counting the update time

# === data section ===
  .section .data
direction:
  .long 4

# === text section ===
  .section .text
  .globl _start
_start:
  # setting up the stack
  sub $8, %rsp
  movq %rsp, %rbp
  and $STAL16, %rsp

  # saving the address of snake_data
  leaq snake_data(%rip), %rax
  movq %rax, snake_data_ptr(%rip)
  # set the first Vector2 to both ones
  movq $1, (%rax)
  movq $2, 8(%rax)

  movq $WINDOW_X, %rdi
  movq $WINDOW_Y, %rsi
  leaq WINDOW_TITLE(%rip), %rdx
  call InitWindow

  movl $KEY_NULL, %edi
  call SetExitKey

  movl $TARGET_FPS, %edi
  call SetTargetFPS

main_loop_begin:
_drawing:
  call BeginDrawing

  movq $COLOR_BLACK, %rdi
  call ClearBackground

  movq snake_data_ptr(%rip), %rdi
  movq $PIXELS_PER_BLOCK, %rsi
  #movq score(%rip), %rdx
  call draw_snake

  call EndDrawing
  
_game_logic:
  
  #changing the direction based on the input
  call get_input
  testl %eax, %eax
  jz no_change
  movl %eax, direction(%rip)
no_change:

  # update the snake position
  movq update_cnt(%rip), %rbx
  cmpq $UPDATE_FR, %rbx
  jng no_update
  movq $0, update_cnt(%rip)
  movq direction(%rip), %rax
  movq snake_data_ptr(%rip), %rbx
  cmpl $1, %eax
  je go_up
  cmpl $2, %eax
  je go_down
  cmpl $3, %eax
  je go_left
  cmpl $4, %eax
  je go_right
  jmp no_update
go_up:
  decq 8(%rbx)
  jmp no_change
go_down:
  incq 8(%rbx)
  jmp no_change
go_left:
  decq (%rbx)
  jmp no_change
go_right:
  incq (%rbx)
  jmp no_change
no_update:
  addq $1, update_cnt(%rip)

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

