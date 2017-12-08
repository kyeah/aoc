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

    let mut registers: HashMap<String, i32> = instructions
        .iter()
        .map(|tuple| (tuple.0.to_owned(), 0))
        .collect();

    let mut global_max = -1;
    for (_, f) in instructions {
        f(&mut registers);
        global_max = max(global_max, register_max(&registers));
    }

    println!("part 1: {:?}", register_max(&registers));
    println!("part 2: {:?}", global_max);
}

fn register_max(registers: &HashMap<String, i32>) -> i32 {
    *registers.values().max().unwrap()
}

fn max(a: i32, b: i32) -> i32 {
    if a > b { a } else { b }
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
            utils::add(registers, &register, incr);
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
