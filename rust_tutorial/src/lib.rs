pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {


    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);

    }

    #[test]
    fn print_test() {
        println!("I'm printing")
    }

    #[test]
    #[should_panic]
    fn should_panic_test() {
        panic!("I'm panicking");
    }
}
