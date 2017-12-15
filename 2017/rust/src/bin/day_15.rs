extern crate aoc;
extern crate itertools;

use std::env;

// n.b. Relying on Wrapping<u32> operators does
// not work here, because each overflow has an
// off-by-one error when calculating remainder.
fn generate(prev: u64, factor: u64) -> u64 {
    (prev * factor) % 2147483647
}

// there's probably a cool trick involving bit masks
// or skipping half the values based on the initial
// problem input but this is easier and its 2am
fn generate_picky(prev: u64, factor: u64, mult: u64) -> u64 {
    let mut val = generate(prev, factor);
    while val % mult != 0 {
        val = generate(val, factor);
    }
    val
}

fn binary_match(a: u64, b: u64) -> bool {
    (a & 0xffff) == (b & 0xffff)
}

fn count(base_a: u64, base_b: u64, iters: usize, picky: bool) -> usize {
    let mut a = base_a;
    let mut b = base_b;
    let a_factor = 16807;
    let b_factor = 48271;
    (0..iters)
        .filter(|_| {
            if picky {
                a = generate_picky(a, a_factor, 4);
                b = generate_picky(b, b_factor, 8);
            } else {
                a = generate(a, a_factor);
                b = generate(b, b_factor);
            }
            binary_match(a, b)
        })
        .count()
}

fn main() {
    let a = env::args().nth(1).map(|v| v.parse().unwrap()).unwrap_or(277);
    let b = env::args().nth(2).map(|v| v.parse().unwrap()).unwrap_or(349);
    println!("{}", count(a, b, 40_000_000, false));
    println!("{}", count(a, b, 5_000_000, true));
}
