extern crate aoc;
extern crate itertools;

use aoc::utils;

fn main() {
    let input = include_str!("../../res/day_05/input.txt");
    println!("part 1: {:?}", maze_steps(input, |_| 1));
    println!("part 2: {:?}", maze_steps(input, |v| if v >= 3 { -1 } else { 1 }));
}

fn maze_steps<F>(input: &str, step_fn: F) -> usize where F: Fn(i32) -> i32 {
    let mut maze: Vec<i32> = utils::parsed_col(input).collect();
    let mut pos: i32 = 0;
    let mut steps = 0;
    
    while pos >= 0 && pos < maze.len() as i32 {
        let upos = pos as usize;
        pos += maze[upos];
        maze[upos] += step_fn(maze[upos]);
        steps += 1;
    }

    steps
}
