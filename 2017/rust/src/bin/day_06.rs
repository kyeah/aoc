extern crate aoc;
extern crate itertools;

use aoc::day_06;
use std::collections::HashSet;

fn main() {
    let input = include_str!("../../res/day_06/input.txt");

    let mut banks: Vec<usize> = input
        .lines()
        .next()
        .expect("no input provided")
        .split_whitespace()
        .map(|s| s.parse().unwrap())
        .collect();

    let mut seen = HashSet::new();
    while !seen.contains(&banks) {
        seen.insert(banks.clone());
        banks = redistribute(banks);
    }

    println!("part 1: {}", seen.len());

    seen.clear();
    while !seen.contains(&banks) {
        seen.insert(banks.clone());
        banks = redistribute(banks);
    }

    println!("part 2: {}", seen.len());
}

fn redistribute(banks: Vec<usize>) -> Vec<usize> {
    let mut bank: Vec<_> = banks.clone();

    // This is a terrible ineffecient way to do this sorry
    let max_value = banks.iter().max().expect("no values");
    let pos = banks.iter().position(|val| val == max_value).expect("lol");

    bank[pos] = 0;
    for offset in 1..max_value+1 {
        bank[(pos + offset) % banks.len()] += 1;
    }
    bank
}
