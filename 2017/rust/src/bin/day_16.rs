#![feature(slice_rotate)]

extern crate aoc;
extern crate itertools;

use aoc::utils;
use std::collections::HashMap;
use itertools::Itertools;
use std::num::Wrapping;

fn run(line: &mut Vec<char>, cmd: &str) {
    let first = cmd.chars().next().unwrap();
    let rest = &cmd[1..];
    match first {
        's' => {
            let n: usize = rest.parse().unwrap();
            let mid = line.len() - n;
            line.rotate(mid);
        },
        'x' => {
            let split: Vec<&str> = rest.split("/").collect();
            let (a, b) = (split[0].parse().unwrap(), split[1].parse().unwrap());
            line.swap(a, b);
        },
        'p' => {
            let split: Vec<&str> = rest.split("/").collect();
            let a = line.iter().position(|x| x.to_string() == split[0]).unwrap();
            let b = line.iter().position(|x| x.to_string() == split[1]).unwrap();
            line.swap(a, b);
        },
        _ => panic!("invalid cmd: {}", cmd),
    }
}

fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_16/input.txt"));
    let mut line: Vec<char> = "abcdefghijklmnop".chars().collect();

    let mut seen = HashMap::new();

    let mut iter = Wrapping(1);
    while iter <= Wrapping(1_000_000_000) {
        for cmd in utils::split(&input, ",") {
            run(&mut line, cmd);
        }

        let ans = line.iter().join("");
        if iter == Wrapping(1) {
            println!("part_1: {:?}", ans);
        }

        if seen.get(&ans).is_some() {
            let loop_len = iter - seen[&ans];
            while iter <= Wrapping(1_000_000_000) - loop_len {
                iter = iter + loop_len;
            }
            seen.clear();
        } else {
            seen.insert(ans, iter);
        }
        iter += Wrapping(1);
    }
    println!("part_2: {:?}", line.iter().join(""));
}
