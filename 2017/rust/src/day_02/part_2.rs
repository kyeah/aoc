pub fn row_div(row: &str) -> i32 {
    let vals: Vec<i32> = row
        .split_whitespace()
        .map(|s| s.parse().unwrap())
        .collect();

    for (i, el1) in vals.iter().enumerate() {
        for el2 in vals[i+1..vals.len()].iter() {
            if el1 > el2 && el1 % el2 == 0 {
                return el1 / el2
            } else if el2 > el1 && el2 % el1 == 0 {
                return el2 / el1
            } 
        }
    }

    panic!("invalid input: no evenly-divisible pair.")
}
