extern crate aoc;
extern crate itertools;

use aoc::utils;
use itertools::Itertools;

fn main() {
    let input = include_str!("../../res/day_04/input.txt");

    let part1 = input
        .lines()
        .filter(|line|
                utils::words(&line).count() ==
                utils::words(&line).unique().count()
        )
        .count();

    println!("part 1: {:?}", part1);

    let part2 = input
        .lines()
        .filter(|line|
                utils::words(&line).map(sorted_chars).count() ==
                utils::words(&line).map(sorted_chars).unique().count()
        )
        .count();

    println!("part 2: {:?}", part2);
}

pub fn sorted_chars<'a>(s: &str) -> Vec<char> {
    let mut v: Vec<_> = s.chars().collect();
    v.sort();
    v
}
