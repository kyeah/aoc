extern crate aoc;
extern crate itertools;

use aoc::utils;
use std::collections::HashMap;

fn main() {
    let input = include_str!("../../res/day_08/input.txt");

    let instructions: Vec<_> = input
        .lines()
        .map(parse_instruction)
        .collect();

    let mut registers: HashMap<String, i32> = instructions.iter()
        .map(|tuple| (tuple.0.to_owned(), 0))
        .collect();

    let mut max = -1;
    for (_, f) in instructions {
        f(&mut registers);
        let iter_max = *registers.values().max().unwrap();
        if iter_max > max {
            max = iter_max;
        }
    }

    println!("part 1: {:?}", registers.values().max().unwrap());
    println!("part 2: {:?}", max);
}

// Return a tuple of the register name + an instruction application fn
fn parse_instruction(s: &str) -> (String, Box<Fn(&mut HashMap<String, i32>) -> ()>) {
    // Haha i'm so sorry this is the worst args parsing code
    let v = utils::words(s).collect::<Vec<_>>();
    let register = v[0].to_owned();
    let multiplier = if v[1] == "inc" { 1 } else { -1 };
    let incr    = multiplier * v[2].parse::<i32>().unwrap();
    let cmp_reg = v[4].to_owned();
    let cmp_str = v[5].to_owned();
    let cmp_val = v[6].parse::<i32>().unwrap();

    (register.to_owned(), Box::new(move |ref mut registers| {
        if ap(registers[&cmp_reg], &cmp_str, cmp_val) {
            *registers.get_mut(&register).unwrap() += incr;
        }
    }))
}

// Apply the cmp action based on the register val and cmp val given.
fn ap(cmpreg: i32, cmp: &str, cmpval: i32) -> bool {
    match cmp {
        ">"  => cmpreg > cmpval,
        ">=" => cmpreg >= cmpval,
        "<"  => cmpreg < cmpval,
        "<=" => cmpreg <= cmpval,
        "==" => cmpreg == cmpval,
        "!=" => cmpreg != cmpval,
        _    => panic!("please"),
    }
}
