.section .data
a:
  .float 1.933
fmt:
  .string "%f\n"

.section .text
.globl _start
_start:
  movq $a, %rdi     # Load the address of 'a' into rdi
  flds (%rdi)       # Load the float from memory into the FPU stack
  fstps (%rsp)      # Store the float from the FPU stack to the top of the stack
  movq $fmt, %rsi   # Load the address of 'fmt' into rsi
  call printf       # Call printf

  movq $60, %rax    # Exit syscall
  xor %rdi, %rdi
  syscall
