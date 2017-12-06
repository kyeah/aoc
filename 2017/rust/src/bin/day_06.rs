extern crate aoc;
extern crate itertools;

use aoc::utils;
use std::collections::HashSet;

fn main() {
    let input = include_str!("../../res/day_06/input.txt");

    let mut banks: Vec<usize> = utils::parsed_row(
        input.lines().next().expect("no input provided")
    ).collect();

    let iters = redistribute_until_loop(&mut banks);
    println!("part 1: {}", iters);

    let inner_iters = redistribute_until_loop(&mut banks);
    println!("part 2: {}", inner_iters);
}

fn redistribute_until_loop(banks: &mut Vec<usize>) -> usize {
    let mut seen = HashSet::new();
    while !seen.contains(banks) {
        seen.insert(banks.clone());
        redistribute(banks);
    }
    seen.len()
}

fn redistribute(banks: &mut Vec<usize>) {
    let len = banks.len();

    // this is unnecessarily dense and probably
    // worse than my initial solution
    let (pos, max_value) = banks.iter()
        .enumerate()
        .max_by_key(|&(pos, item)| (item, -(pos as i32)))
        .map(|(pos, val)| (pos, val.to_owned()))
        .expect("no items");

    banks[pos] = 0;
    for offset in 1..max_value+1 {
        banks[(pos + offset) % len] += 1;
    }
}
