extern crate aoc;
extern crate itertools;

use std::collections::HashMap;
use std::collections::HashSet;

fn main() {
    let input = include_str!("../../res/day_13/input.txt");
    println!("part 1: {}", penalty(input, 0, false));
    println!("part 2: {}", part_2(input));
}

fn part_2(input: &str) -> usize {
    let max = 10000000;
    let mut x = (1..max).collect::<HashSet<usize>>();

    for (col, len) in input.lines().map(parse_row) {
        let round_trip = 2*(len - 1);
        let first_bad_delay = round_trip - col / round_trip;
        for y in 0..max/round_trip {
            x.remove(&(first_bad_delay + round_trip*y));
        }
    }

    *x.iter().min().unwrap()
}

// return col and length of that col.
fn parse_row(s: &str) -> (usize, usize) {
    let mut parts = s.split(": ");
    (parts.next().unwrap().parse().unwrap(),
     parts.next().unwrap().parse().unwrap())
}

fn advance<'a>(map: &HashMap<usize, usize>, firewall: &mut HashMap<&usize, (usize, bool)>) {
    for (k, v) in firewall {
        advance_col(map, *k, v);
    }
}

fn advance_col(map: &HashMap<usize, usize>, k: &usize, v: &mut (usize, bool)) {
    let new_inc = (v.1 && v.0 != map[k] - 1) || (!v.1 && v.0 == 0);
    let new_v = if new_inc { v.0 + 1 } else { v.0 - 1 };
    v.0 = new_v;
    v.1 = new_inc;
}

fn penalty(input: &str, delay: usize, break_early: bool) -> usize {
    let map = input.lines().map(parse_row).collect::<HashMap<_,_>>();
    let mut firewall = map.keys().map(|k| (k, (0usize, true))).collect::<HashMap<_,_>>();

    let size = *map.keys().max().unwrap();
    let mut p = 0;

    for _ in 0..delay+1 {
        advance(&map, &mut firewall);
    }

    for pos in 1..size+1 {
        if firewall.get(&pos).map(|f| f.0).unwrap_or(1) == 0 {
            p += pos * map[&pos];
            if break_early {
                return p;
            }
        }
        advance(&map, &mut firewall);
    }

    p
}
