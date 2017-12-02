extern crate aoc;

use aoc::day_02;

fn main() {
    let input = include_str!("../../res/day_02/input.txt");

    let sum: i32 = input
        .lines()
        .map(|line| day_02::part_1::row_diff(line))
        .sum();

    println!("part 1: {}", sum);

    let div: i32 = input
        .lines()
        .map(|line| day_02::part_2::row_div(line))
        .sum();

    println!("part 2: {}", div);
}
