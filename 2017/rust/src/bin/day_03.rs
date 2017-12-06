extern crate aoc;

use aoc::{day_03, utils};

fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_03/input.txt"));
    println!("{}", input);
    let val: i32 = input.parse().unwrap();
    let dist = day_03::part_1::manhattan_distance(val);
    println!("part 1: {}", dist);
}
