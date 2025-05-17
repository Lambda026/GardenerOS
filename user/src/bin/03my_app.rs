// user/src/bin/03my_app.rs
     #![no_std]
     #![no_main]
     #[macro_use]
     extern crate user_lib;
     #[no_mangle]
     fn main() -> i32 {
         println!("This is my custom app!");
         0
     }
