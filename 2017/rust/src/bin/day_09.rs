extern crate aoc;
extern crate itertools;
extern crate regex;

use aoc::utils;
use regex::Regex;


fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_09/input.txt"));
    let re = Regex::new(r"!.").unwrap();

    let mut score = 0;
    let mut global_score = 0;

    let mut garbage = false;
    let mut garbage_count = 0;

    for c in re.replace_all(&input, "").chars() {
        garbage = garbage && c != '>';
        if garbage {
            garbage_count += 1;
            continue;
        }

        match c {
            '{' => score += 1,
            '}' => {
                global_score += score;
                score -= 1;
            },
            '<' => garbage = true,
            _ => (),
        }
    }

    println!("part 1: {:?}", global_score);
    println!("part 2: {:?}", garbage_count);
}
