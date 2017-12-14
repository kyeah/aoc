extern crate aoc;
extern crate itertools;

use aoc::utils;
use std::collections::HashMap;
use itertools::Itertools;

fn parse_row(row: String) -> Vec<bool> {
    let hex = utils::knot_hash(&row[..]);
    let binary_s = format!(
        "{:04b}",
        hex.chars()
            .map(|c| usize::from_str_radix(&c.to_string()[..], 16).unwrap())
            .format("")
    );

    binary_s
        .chars()
        .map(|c| c == '1')
        .collect()
}

fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_14/input.txt"));
    let grid = (0..128)
        .map(|i| parse_row(format!("{}-{}", input, i)))
        .collect::<Vec<_>>();

    let sum: usize = grid.iter()
        .map(|row| row.iter().filter(|c| **c).count())
        .sum();

    println!("part 1: {}", sum);

    let mut max_group = 0;
    let mut groups = HashMap::new();

    for y in 0..128 {
        for x in 0..128 {
            if grid[y][x] && groups.get(&(x, y)).is_none() {
                max_group += 1;
                set_group(&grid, &mut groups, x, y, max_group);
            }
        }
    }

    println!("part 2: {}", max_group);
}

fn set_group(grid: &Vec<Vec<bool>>,
             groups: &mut HashMap<(usize, usize), usize>,
             x: usize,
             y: usize,
             group_num: usize) {
    if grid[y][x] && groups.get(&(x, y)).is_none() {
        groups.insert((x, y), group_num);
        if y != 0 {
            set_group(grid, groups, x, y - 1, group_num);
        }
        if y != 127 {
            set_group(grid, groups, x, y + 1, group_num);
        }
        if x != 0 {
            set_group(grid, groups, x - 1, y, group_num);
        }
        if x != 127 {
            set_group(grid, groups, x + 1, y, group_num);
        }
    }
}

