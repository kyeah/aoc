extern crate aoc;
extern crate itertools;

use aoc::utils;
use itertools::Itertools;

fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_10/input.txt"));

    let lengths: Vec<usize> = input
        .split(",")
        .map(|s| s.parse().unwrap())
        .collect();

    let vals_part1 = utils::run_rounds(1, &lengths);
    println!("part 1: {:?}", vals_part1[0] * vals_part1[1]);
    println!("part 2: {:02x}", utils::knot_bytes(&input[..]).iter().format(""));
}
