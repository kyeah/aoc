extern crate aoc;

use aoc::day_02;

fn main() {
    let sum: i32 = include_str!("../../res/day_02/input.txt")
        .lines()
        .map(|line| day_02::part_1::row_diff(line))
        .sum();

    println!("part 1: {}", sum);
}
