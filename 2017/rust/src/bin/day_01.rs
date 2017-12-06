extern crate aoc;

use aoc::utils;

fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_01/input.txt"));
    println!("part 1: {}", consecutive_sum(&input));
    println!("part 2: {}", halfway_sum(&input));
}

fn consecutive_sum(captcha: &str) -> u32 {
    let mut chars = utils::digits(captcha);
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

fn halfway_sum(captcha: &str) -> u32 {
    let mid = captcha.len() / 2;
    let (first_half, second_half) = captcha.split_at(mid);

    utils::digits(first_half)
        .zip(utils::digits(second_half))
        .filter(|&(a, b)| a == b)
        .map(|(a, b)| a + b)
        .sum()
}
