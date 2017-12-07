extern crate aoc;
extern crate itertools;

use itertools::Itertools;
use std::collections::HashMap;

fn main() {
    let input = include_str!("../../res/day_07/input.txt");

    let nodes = input
        .lines()
        .map(parse_node)
        .collect::<HashMap<_,_>>();

    let leaves = nodes.values()
        .flat_map(|n| &n.children)
        .unique()
        .collect::<Vec<_>>();

    let head_name = nodes.keys()
        .find(|n| !leaves.contains(&n))
        .expect("lol")
        .clone();

    println!("part 1: {:?}", &head_name);
    weight_sum(&nodes, &head_name).expect("my job here is donezo");
}

fn weight_sum(nodes: &HashMap<String, Node>, node_name: &str) -> Result<usize, String> {
    let node = &nodes[node_name];

    let child_sums = node.children.iter()
        .map(|child| (child, weight_sum(nodes, child).expect("my job here is donezo")))
        .collect::<HashMap<_,_>>();

    if child_sums.values().unique().count() > 1 {
        println!("part 2: {:?}", child_sums);
        println!("yeah that's right do some manual work");
        return Err("bye".to_owned());
    }

    Ok(node.weight + child_sums.values().sum::<usize>())
}

fn parse_node(s: &str) -> (String, Node) {
    let mut parts = s.split("->");

    let mut node_parts = parts.next()
        .map(|s| s.split_whitespace())
        .expect("no row input");

    let children = parts.next()
        .map(|s| s.split(",").map(|word| word.trim().to_owned()).collect())
        .unwrap_or_else(|| Vec::new());

    let name = node_parts.next().expect("no name provided");
    let weight = node_parts
        .next()
        .expect("no weight provided")
        .replace("(", "")
        .replace(")", "")
        .parse()
        .expect("not a number");

    (name.to_owned(), Node::new(name.to_owned(), weight, children))
}

#[derive(Clone, Debug)]
struct Node {
    name: String,
    weight: usize,
    children: Vec<String>,
}

impl Node {
    fn new(name: String, weight: usize, children: Vec<String>) -> Self {
        Node {
            name: name,
            weight: weight,
            children: children,
        }
    }
}
