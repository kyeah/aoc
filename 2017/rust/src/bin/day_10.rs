extern crate aoc;
extern crate itertools;

use aoc::utils;
use itertools::Itertools;

fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_10/input.txt"));

    let lengths: Vec<usize> = input
        .split(",")
        .map(|s| s.parse().unwrap())
        .collect();

    let vals_part1 = run_rounds(1, &lengths);
    println!("part 1: {:?}", vals_part1[0] * vals_part1[1]);

    let ascii_lengths: Vec<usize> =
        [input.as_bytes(), &[17, 31, 73, 47, 23]]
          .concat()
          .iter()
          .map(|v| *v as usize)
          .collect();

    let vals_part2 = run_rounds(64, &ascii_lengths);
    let sparse_hash = vals_part2
        .chunks(16)
        .map(|arr| {
            let mut i = arr.iter();
            let first = i.next().unwrap();
            i.fold(*first, |a, b| a ^ b) as u8
        });

    println!("part 2: {:02x}", sparse_hash.format(""));
}

fn reverse(vals: &mut Vec<usize>, pos: usize, length: usize) {
    for i in 0..(length / 2) {
        let start_pos = (pos + i) % vals.len();
        let end_pos   = (pos + length - 1 - i) % vals.len();
        let start_val = vals[start_pos];
        let end_val   = vals[end_pos];

        vals[start_pos] = end_val;
        vals[end_pos] = start_val;
    }
}

fn run_rounds(n: usize, lengths: &Vec<usize>) -> Vec<usize> {
    let mut pos = 0;
    let mut skip_size = 0;
    let mut vals = (0..256).collect::<Vec<usize>>();

    for _ in 0..n {
        for length in lengths {
            reverse(&mut vals, pos, *length);
            pos = (pos + *length + skip_size) % vals.len();
            skip_size += 1;
        }
    }

    vals
}
