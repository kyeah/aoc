extern crate aoc;
extern crate itertools;

use aoc::utils;
use std::collections::HashMap;

fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_11/input.txt"));

    let mut dirs: HashMap<&str, isize> = HashMap::new();
    for key in vec!["n", "s", "sw", "se", "nw", "ne"] {
        dirs.insert(key, 0);
    }

    let mut max_dist = 0;
    for dir in input.split(",") {
        utils::add(&mut dirs, &dir, 1);
        max_dist = max(max_dist, distance(&dirs));
    }

    println!("part 1: {}", distance(&dirs));
    println!("part 2: {}", max_dist);
}

fn max(a: isize, b: isize) -> isize {
    if a > b { a } else { b }
}

fn distance(dirs: &HashMap<&str, isize>) -> isize {
    let left  = dirs["nw"] - dirs["se"];
    let up    = dirs["n"] - dirs["s"];
    let right = dirs["ne"] - dirs["sw"];
    up + max(left.abs(), right.abs())
}
