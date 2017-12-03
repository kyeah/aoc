extern crate aoc;

use aoc::day_03;
use std::env;

fn main() {
    let input = env::args().nth(1)
        .unwrap_or_else(|| {
            include_str!("../../res/day_03/input.txt").to_owned()
        });

    let val: i32 = input.parse().unwrap();
    let dist = day_03::part_1::manhattan_distance(val);
    println!("part 1: {}", dist);
}
