pub fn solve_captcha(captcha: &str) -> u32 {
    let mid = captcha.len() / 2;
    let (first_half, second_half) = captcha.split_at(mid);

    first_half.chars().map(|c| c.to_digit(10).unwrap())
        .zip(second_half.chars().map(|c| c.to_digit(10).unwrap()))
        .filter(|&(a, b)| a == b)
        .map(|(a, b)| a + b)
        .sum()
}
