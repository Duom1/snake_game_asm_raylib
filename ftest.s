.section .data
a:
  .float 1.933
fmt:
  .string "%f\n"

.section .text
.globl _start
_start:
  subq $32, %rsp
  movsd a(%rip), %xmm0
  movq $fmt, %rsi   # Load the address of 'fmt' into rsi
  call printf       # Call printf

  movq $60, %rax    # Exit syscall
  xor %rdi, %rdi
  syscall
