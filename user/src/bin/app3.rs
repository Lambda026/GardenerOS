// user/src/bin/app3.rs
#![no_std]
#![no_main]

#[macro_use]
extern crate user_lib;

#[no_mangle]
fn main() -> i32 {
    println!("Hello from App3!");
    for i in 0..5 {
        println!("App3 counting: {}", i);
    }
    println!("App3 finished.");
    0
}
