extern crate aoc;
extern crate itertools;

use aoc::day_05;

fn main() {
    let input = include_str!("../../res/day_05/input.txt");

    let mut maze: Vec<i32> = input
        .lines()
        .map(|s| s.parse().unwrap())
        .collect();

    let mut maze_2: Vec<i32> = maze.clone();

    let mut pos: i32 = 0;
    let mut steps = 0;
    
    while pos >= 0 && pos < maze.len() as i32 {
        let upos = pos as usize;
        pos += maze[upos];
        maze[upos] += 1;
        steps += 1;
    }

    println!("part 1: {:?}", steps);

    pos = 0;
    steps = 0;

    while pos >= 0 && pos < maze_2.len() as i32 {
        let upos = pos as usize;
        pos += maze_2[upos];
        maze_2[upos] += (if maze_2[upos] >= 3 { -1 } else { 1 });
        steps += 1;
    }

    println!("part 2: {:?}", steps);
}
