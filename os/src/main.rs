#![no_std]
#![no_main]

#[macro_use]
mod console;

use console::sys_exit;
use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    sys_exit(-1)
}

#[no_mangle]
extern "C" fn _start() -> ! {
    println!("Hello, world!");
    sys_exit(0)
}

