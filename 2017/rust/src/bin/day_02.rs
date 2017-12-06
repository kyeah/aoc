extern crate aoc;

use aoc::utils;

fn main() {
    let input = include_str!("../../res/day_02/input.txt");

    let sum: i32 = input
        .lines()
        .map(row_diff)
        .sum();

    println!("part 1: {}", sum);

    let div: i32 = input
        .lines()
        .map(row_div)
        .sum();

    println!("part 2: {}", div);
}

pub fn row_diff(row: &str) -> i32 {
    let (min, max) = utils::parsed_row(row)
        .fold((<i32>::max_value(), <i32>::min_value()), |(min, max), val| {
            // There are utility fns i can probably use
            // but i'm gonna do this manually
            let nmin = if val < min { val } else { min };
            let nmax = if val > max { val } else { max };
            (nmin, nmax)
        });

    max - min
}

pub fn row_div(row: &str) -> i32 {
    let vals: Vec<i32> = utils::parsed_row(row).collect();

    for (i, el1) in vals.iter().enumerate() {
        for el2 in vals[i+1..vals.len()].iter() {
            if el1 > el2 && el1 % el2 == 0 {
                return el1 / el2
            } else if el2 > el1 && el2 % el1 == 0 {
                return el2 / el1
            } 
        }
    }

    panic!("invalid input: no evenly-divisible pair.")
}
