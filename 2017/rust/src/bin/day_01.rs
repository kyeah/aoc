extern crate aoc;

use aoc::day_01;
use std::env;

fn main() {
    let input = env::args().nth(1).unwrap();
    println!("{}", day_01::part_1::solve_captcha(&input));
}
