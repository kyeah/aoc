pub fn solve_captcha(captcha: &str) -> u32 {
    let mut chars = captcha.chars().map(|c| c.to_digit(10).unwrap());
    let first_val = chars.next().unwrap_or(0);

    let (sum, last_val) = chars.fold((0, first_val), |(sum, prev_val), next_val| {
        if prev_val == next_val {
            (sum + next_val, next_val)
        } else {
            (sum, next_val)
        }
    });

    if captcha.len() >= 2 && first_val == last_val {
        sum + last_val
    } else {
        sum
    }
}
