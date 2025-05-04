#![no_std]
#![no_main]
#![feature(panic_info_message)]

#[macro_use]
mod console;

mod sbi;
mod lang_items;

use core::arch::global_asm;
use core::panic::PanicInfo;

global_asm!(include_str!("entry.asm"));

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    sbi::shutdown()
}

#[no_mangle]
pub fn rust_main() -> ! {
    println!("Hello from bare-metal Rust!");
    println!("Stack and .bss are all set up.");
    sbi::shutdown()
}

