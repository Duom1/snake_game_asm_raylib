# === constants ===
  .include "const_def.s"
  .include "key_def.s"
  .include "dir_def.s"
  .include "color_def.s"

# === readonly data section ===
  .section .rodata
TEST:
  .string "%i, %i\n"
WINDOW_TITLE:
  .string "snake game"
SCORE_FMT:
  .string "Score: %i"

# === bss section ===
  .section .bss
  .lcomm score, 8             # 64 bit score
  .lcomm snake_data, 8*2*256  # int * vec2 * 256 long list
  .lcomm snake_data_ptr, 8    # this is used to store the pointer to snake_data
  .lcomm update_cnt, 8        # counting the update time
  .lcomm food_pos, 8*2        # x, y coordinates
  .lcomm score_str, 16         # space for the printable score

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

  leaq food_pos(%rip), %rdi
  movq $BLOCKS_X, %rsi
  movq $BLOCKS_Y, %rdx
  call place_food

  leaq score_str(%rip), %rdi
  leaq SCORE_FMT(%rip), %rsi
  movq score(%rip), %rdx
  call sprintf

main_loop_begin:
  call BeginDrawing                 # drawing start

  movq $COLOR_BLACK, %rdi
  call ClearBackground

  movq snake_data_ptr(%rip), %rdi
  movq $PIXELS_PER_BLOCK, %rsi
  call draw_snake

  leaq food_pos(%rip), %rdi
  movq $PIXELS_PER_BLOCK, %rsi
  call draw_food

  # draw score
  leaq score_str(%rip), %rdi
  movq $10, %rsi
  movq $10, %rdx
  movq $SCORE_TEXT_SIZE, %rcx
  movq $COLOR_WHITE, %r8
  call DrawText

  call EndDrawing                   # drawing end
  
  #changing the direction based on the input
  call get_input
  testl %eax, %eax
  jz no_change
  movl %eax, direction(%rip)
no_change:

  # check if it is time to update
  movq update_cnt(%rip), %rbx
  cmpq $UPDATE_FR, %rbx
  jng no_update
  # START UPDATING
  # move the snake
  movq $0, update_cnt(%rip)
  movl direction(%rip), %eax
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
  jmp continue_update
go_down:
  incq 8(%rbx)
  jmp continue_update
go_left:
  decq (%rbx)
  jmp continue_update
go_right:
  incq (%rbx)
  jmp continue_update
continue_update:
  # eat check
  movq snake_data_ptr(%rip), %rax
  leaq food_pos(%rip), %rbx
  movq (%rax), %r8
  movq (%rbx), %r9
  cmpq %r8, %r9
  jne no_eating
  movq 8(%rax), %r8
  movq 8(%rbx), %r9
  cmpq %r8, %r9
  jne no_eating
  incq score(%rip)
  leaq food_pos(%rip), %rdi
  movq $BLOCKS_X, %rsi
  movq $BLOCKS_Y, %rdx
  call place_food
  leaq score_str(%rip), %rdi
  leaq SCORE_FMT(%rip), %rsi
  movq score(%rip), %rdx
  call sprintf
no_eating:
  # END UPDATING
no_update:
  addq $1, update_cnt(%rip)

  # checking if the window should be closed
  call WindowShouldClose
  testq %rax, %rax
  jz main_loop_begin

  # actually closing the window
  call CloseWindow

exit_program:
  movq $60, %rax
  xor %rbx, %rbx
  syscall

