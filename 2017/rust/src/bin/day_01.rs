extern crate aoc;

use aoc::day_01;
use std::env;

fn main() {
    let input = env::args().nth(1).unwrap_or_else(|| include_str!("../../res/day_01/input.txt").to_owned());
    println!("part 1: {}", day_01::part_1::solve_captcha(&input));
    println!("part 2: {}", day_01::part_2::solve_captcha(&input));
}
