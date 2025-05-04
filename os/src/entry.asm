    .section .text.entry
    .globl _start
_start:
    # 将栈指针 sp 指向 boot_stack_top
    la   sp, boot_stack_top
    # 跳转到 Rust 层入口
    call rust_main

    # 为栈分配空间：16×4 KiB
    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 * 16
    .globl boot_stack_top
boot_stack_top:
