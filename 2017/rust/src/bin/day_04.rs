extern crate aoc;
extern crate itertools;

use aoc::day_04;

use itertools::Itertools;

fn main() {
    let input = include_str!("../../res/day_04/input.txt");

    let part1 = input
        .lines()
        .filter(|line|
                line.trim().split_whitespace().count() ==
                line.trim().split_whitespace().unique().count()
        )
        .count();

    println!("part 1: {:?}", part1);

    let part1 = input
        .lines()
        .filter(|line|
                line.trim().split_whitespace().map(sorted_chars).count() ==
                line.trim().split_whitespace().map(sorted_chars).unique().count()
        )
        .count();

    println!("part 1: {:?}", part1);
}

pub fn sorted_chars<'a>(s: &str) -> Vec<char> {
    let mut v: Vec<_> = s.chars().collect();
    v.sort();
    v
}
