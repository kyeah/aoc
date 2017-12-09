extern crate aoc;

use aoc::{day_03, utils};
use std::collections::HashMap;

fn add(a: (i32, i32), b: (i32, i32)) -> (i32, i32) {
    (a.0 + b.0, a.1 + b.1)
}

fn main() {
    let input = utils::arg_or_default(include_str!("../../res/day_03/input.txt"));
    println!("{}", input);
    let val: u32 = input.parse().unwrap();
    let dist = day_03::part_1::manhattan_distance(val as i32);
    println!("part 1: {}", dist);

    let mut points = HashMap::new();
    points.insert((0, 0), 1u32);

    let dirs = [
        (1, 0),
        (0, 1),
        (-1, 0),
        (0, -1),
    ];

    let mut point = (0, 0);
    let mut ring_len = 1;
    let mut dir = 0;

    loop {
        // step into ring
        point = add(point, dirs[dir]);
        calc_point(point, &mut points, val).expect("done");

        for x in (0..2*ring_len) {
            if x == 0 || x == ring_len {
                dir = (dir + 1) % dirs.len();
            }
            point = add(point, dirs[dir]);
            calc_point(point, &mut points, val).expect("done");
        }

        ring_len += 1;
    }
}

fn calc_point(point: (i32, i32), points: &mut HashMap<(i32, i32), u32>, val: u32) -> Result<u32, u32> {
    let s: u32 = vec![(1, 0), (0, 1), (-1, 0), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)]
        .iter().map(|p| points.get(&add(point, *p)).map(|a| *a).unwrap_or(0))
        .sum();

    points.insert(point, s);

    if s > val {
        Err(s)
    } else {
        Ok(s)
    }
}
