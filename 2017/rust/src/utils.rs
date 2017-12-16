use std::env;
use std::str::FromStr;
use std::fmt::Debug;
use std::ops::{Add,Sub};
use std::collections::HashMap;
use std::hash::Hash;

use itertools::Itertools;

pub fn arg_or_default(default: &str) -> String {
    env::args()
        .nth(1)
        .unwrap_or(default.lines().next().unwrap().to_owned())
}

pub fn args_or_default(default: &str) -> Vec<String> {
    let args: Vec<_> = env::args().skip(1).collect();
    if args.len() > 0 {
        args
    } else {
        words(default).map(|s| s.to_owned()).collect()
    }
}

pub fn words<'a>(s: &'a str) -> Box<Iterator<Item=&str> + 'a> {
    Box::new(s.trim().split_whitespace())
}

pub fn split<'a>(s: &'a str, delim: &'a str) -> Box<Iterator<Item=&'a str> + 'a> {
    Box::new(s.trim().split(delim))
}

pub fn digits<'a>(s: &'a str) -> Box<Iterator<Item=u32> + 'a> {
    Box::new(s.chars().map(|c| c.to_digit(10).unwrap()))
}

pub fn parsed_row<'a, T>(s: &'a str) -> Box<Iterator<Item=T> + 'a>
    where T: FromStr,
          <T as FromStr>::Err: Debug {
    Box::new(words(s).map(|s| s.parse::<T>().unwrap()))
}

pub fn parsed_col<'a, T>(s: &'a str) -> Box<Iterator<Item=T> + 'a>
    where T: FromStr,
          <T as FromStr>::Err: Debug {
    Box::new(s.lines().map(|s| s.parse::<T>().unwrap()))
}

pub fn add<'a, K,V>(map: &mut HashMap<K,V>, k: &K, v: V)
    where K : Eq + Hash,
          V: Add<Output=V> + Clone
{
    let x = map[&k].clone();
    *map.get_mut(&k).unwrap() = x + v;
}

pub fn sub<'a, K,V>(map: &mut HashMap<K,V>, k: &K, v: V)
    where K : Eq + Hash,
          V: Sub<Output=V> + Clone
{
    let x = map[&k].clone();
    *map.get_mut(&k).unwrap() = x - v;
}

pub fn reverse(vals: &mut Vec<usize>, pos: usize, length: usize) {
    for i in 0..(length / 2) {
        let start_pos = (pos + i) % vals.len();
        let end_pos   = (pos + length - 1 - i) % vals.len();
        let start_val = vals[start_pos];
        let end_val   = vals[end_pos];

        vals[start_pos] = end_val;
        vals[end_pos] = start_val;
    }
}

pub fn knot_hash(input: &str) -> String {
    let ascii_lengths: Vec<usize> =
        [input.as_bytes(), &[17, 31, 73, 47, 23]]
          .concat()
          .iter()
          .map(|v| *v as usize)
          .collect();

    let vals = run_knot_rounds(64, &ascii_lengths);
    let bytes = vals.chunks(16)
        .map(|arr| {
            let mut i = arr.iter();
            let first = i.next().unwrap();
            i.fold(*first, |a, b| a ^ b) as u8
        });

    format!("{:02x}", bytes.format(""))
}

pub fn run_knot_rounds(n: usize, lengths: &Vec<usize>) -> Vec<usize> {
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
