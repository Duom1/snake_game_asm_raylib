# === constants ===
  .include "const_def.s"
  .include "key_def.s"
  .include "dir_def.s"
  .include "color_def.s"

# === readonly data section ===
  .section .rodata
WINDOW_TITLE:
  .string "snake game"
SCORE_FMT:
  .string "Score: %i"
PAUSE_MSG:
  .string "Paused"

# === bss section ===
  .section .bss
  .lcomm score, 8             # 64 bit score
  .lcomm snake_data, 8*2*256  # int * vec2 * 256 long list
  .lcomm snake_data_ptr, 8    # this is used to store the pointer to snake_data
  .lcomm update_cnt, 8        # counting the update time
  .lcomm food_pos, 8*2        # x, y coordinates
  .lcomm score_str, 16        # space for the printable score
  .lcomm pause, 1             # the boolen to check if game is paused
  .lcomm direction, 4         # used to store the direction player is going in

# === data section ===
#  .section .data

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

  movq $WINDOW_X, %rdi
  movq $WINDOW_Y, %rsi
  leaq WINDOW_TITLE(%rip), %rdx
  call InitWindow

  movl $KEY_NULL, %edi
  call SetExitKey

  movl $TARGET_FPS, %edi
  call SetTargetFPS

  jmp init

game_over:
init:
  movq $STARTING_SCORE, score(%rip)

  movl $0, direction(%eip)

  movq snake_data_ptr(%rip), %rax
  movq $0, (%rax)
  movq $0, 8(%rax)

  movb $FALSE, pause(%rip)

  leaq food_pos(%rip), %rdi
  movq $BLOCKS_X, %rsi
  movq $BLOCKS_Y, %rdx
  movq snake_data_ptr(%rip), %rcx
  movq score(%rip), %r8
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
  movq score(%rip), %rdx
  call draw_snake

  leaq food_pos(%rip), %rdi
  movq $PIXELS_PER_BLOCK, %rsi
  call draw_food

  leaq pause(%rip), %rax
  movb (%rax), %bl
  testb %bl, %bl
  jz draw_score
  leaq PAUSE_MSG(%rip), %rdi
  movq $10, %rsi
  movq $10, %rdx
  movq $SCORE_TEXT_SIZE, %rcx
  addq $40, %rcx
  movq $COLOR_RED, %r8
  call DrawText
  jmp no_score
draw_score:
  leaq score_str(%rip), %rdi
  movq $10, %rsi
  movq $10, %rdx
  movq $SCORE_TEXT_SIZE, %rcx
  movq $COLOR_WHITE, %r8
  call DrawText
no_score:

  call EndDrawing                   # drawing end
  
  #changing the direction based on the input
  lea pause(%rip), %rdi
  call get_input
  testl %eax, %eax
  jz no_input_change
  movl %eax, direction(%rip)
no_input_change:

  # check if it is time to update
  movq update_cnt(%rip), %rbx
  cmpq $UPDATE_FR, %rbx
  jng no_update
  leaq pause(%rip), %rax
  movb (%rax), %bl
  testb %bl, %bl
  jnz no_update

  # -> START UPDATING
  movq $0, update_cnt(%rip)
  # update snake segments
  movq snake_data_ptr(%rip), %rdi
  movq score(%rip), %rsi
  call update_snake_segments
  # move the snake head
  movq snake_data_ptr(%rip), %rdi
  movl direction(%rip), %esi
  call move_snake

  # cheking ig the snake if out of bounds
  movq snake_data_ptr(%rip), %rdi
  movq $BLOCKS_X, %rsi
  movq $BLOCKS_Y, %rdx
  call out_of_bounds
  testb %al, %al
  jz not_out_of_bounds
  jmp game_over
not_out_of_bounds:

  # eat check
  leaq food_pos(%rip), %rdi
  movq snake_data_ptr(%rip), %rsi
  call eat_check
  testb %al, %al
  jz no_update

  # increase score
  incq score(%rip)
  # move the food
  leaq food_pos(%rip), %rdi
  movq $BLOCKS_X, %rsi
  movq $BLOCKS_Y, %rdx
  movq snake_data_ptr(%rip), %rcx
  movq score(%rip), %r8
  call place_food
  # change the score string
  leaq score_str(%rip), %rdi
  leaq SCORE_FMT(%rip), %rsi
  movq score(%rip), %rdx
  call sprintf
  # -> END UPDATING

no_update:
  addq $1, update_cnt(%rip)

  # checking if the window should be closed
  call WindowShouldClose
  testq %rax, %rax
  jz main_loop_begin

  # closing the window
  call CloseWindow

exit_program:
  movq $60, %rax
  xorq %rdi, %rdi
  syscall

