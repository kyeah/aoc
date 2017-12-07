extern crate aoc;
extern crate itertools;

use aoc::utils;
use itertools::Itertools;
use std::collections::HashMap;

fn main() {
    let input = include_str!("../../res/day_07/input.txt");

    let mut nodes = input
        .lines()
        .map(|line| parse_node(&line))
        .collect::<HashMap<_,_>>();

    for (name, node) in nodes.clone().iter() {
        for child_name in &node.children {
            println!("{}", child_name);
            nodes.get_mut(child_name).unwrap().parent = Some(name.to_owned());
        }
    }

    let head_name = nodes.values().find(|n| n.parent.is_none()).map(|n| n.name.to_owned()).expect("lol");
    println!("part 1: {:?}", &head_name);

    calculate_weight_sum_helper(&mut nodes, &head_name).expect("rip");
}

fn calculate_weight_sum_helper<'a>(nodes: &mut HashMap<String, Node>, node: &str) -> Result<usize, String> {
    let child_names = nodes[node].children.clone();
    let child_sums = child_names.iter()
        .map(|child| (child, calculate_weight_sum_helper(nodes, child).expect("rip")))
        .collect::<HashMap<_,_>>();

    if child_sums.values().unique().count() > 1 {
        println!("part 2: {:?}", child_sums);
        return Err("bye".to_owned());
    }

    Ok(nodes[node].weight + child_sums.values().sum::<usize>())
}

fn parse_node(s: &str) -> (String, Node) {
    let mut parts = s.split("->");

    let mut node_parts = parts.next()
        .map(|s| s.split_whitespace())
        .expect("no row input");

    let children = parts.next()
        .map(|s| s.split_whitespace().map(|s| s.replace(",", "").to_owned()).collect())
        .unwrap_or_else(|| Vec::new());

    let name = node_parts.next().expect("no name provided");
    let weight = node_parts
        .next().expect("no weight provided")
        .replace("(", "")
        .replace(")", "")
        .parse().expect("not a number");

    (name.to_owned(), Node::new(name.to_owned(), weight, children))
}

#[derive(Clone, Debug)]
struct Node {
    name: String,
    weight: usize,
    parent: Option<String>,
    children: Vec<String>,
}

impl Node {
    fn new(name: String, weight: usize, children: Vec<String>) -> Self {
        Node {
            name: name,
            weight: weight,
            parent: None,
            children: children,
        }
    }
}
