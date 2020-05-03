pub fn add(a: i64, b: i64) -> i64 {
    a.wrapping_add(b)
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(super::add(2, 2), 4);
    }
}
