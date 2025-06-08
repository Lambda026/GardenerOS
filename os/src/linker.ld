/* os/src/linker.ld */
OUTPUT_ARCH(riscv)
ENTRY(_start) /* 你的 entry.asm 应该定义了 _start 作为内核的入口点 */

/* 
 * 内核加载基地址。对于QEMU virt机器，通常是0x80200000。
 * 这个地址不能是0x0，因为0x0是用户空间的起始地址。
 */
BASE_ADDRESS = 0x80200000; 

SECTIONS
{
    . = BASE_ADDRESS;

    stext = .; /* .text段开始符号 */
    .text : {
        *(.text.entry)      /* 来自 entry.asm */
        . = ALIGN(4K);
        strampoline = .;     /* 跳板代码段开始，来自 trap.S */
        *(.text.trampoline)
        . = ALIGN(4K);
        *(.text .text.*)    /* 其他所有 .text 代码 */
    }
    etext = .; /* .text段结束符号 */

    . = ALIGN(4K);
    srodata = .; /* .rodata段开始符号 */
    .rodata : {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    }
    erodata = .; /* .rodata段结束符号 */

    . = ALIGN(4K);
    sdata = .; /* .data段开始符号 */
    .data : {
        *(.data .data.*)
        *(.sdata .sdata.*)
        /* 由 build.rs 生成的 link_app.S 中的应用数据会放在 .data 段 */
    }
    edata = .; /* .data段结束符号 */

    . = ALIGN(4K);
    /* 
     * 定义 .bss 段的起始符号。
     * Rust代码中 MemorySet::new_kernel 引用了 sbss_with_stack。
     * rust_main 中的 clear_bss 和 heap_allocator 中的 heap_test 引用了 sbss 和 ebss。
     * 我们将它们都指向 .bss 段的实际开始和结束。
     */
    sbss_with_stack = .; 
    sbss = sbss_with_stack; /* 让 sbss 和 sbss_with_stack 指向同一地址 */
    .bss (NOLOAD) : ALIGN(16) { /* BSS段通常不需要加载，对齐到16字节 */
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }
    ebss = .; /* .bss段结束符号 */
    
    /* 
     * ekernel 标记内核镜像（包括所有代码和静态数据如 .text, .rodata, .data, .bss）的末尾。
     * 它通常用于物理内存帧分配器的起始点。
     */
    . = ALIGN(4096); /* 对齐到页边界 */
    ekernel = .; /* 所有内核段之后的当前地址 */


    /DISCARD/ : {
        *(.eh_frame)
        *(.debug*)
    }
}

