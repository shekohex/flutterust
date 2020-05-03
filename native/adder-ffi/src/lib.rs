#[no_mangle]
pub extern "C" fn add(a: i64, b: i64) -> i64 {
    adder::add(a, b)
}
