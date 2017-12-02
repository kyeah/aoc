pub fn row_diff(row: &str) -> i32 {
    let (min, max) = row
        .split_whitespace()
        .map(|s| s.parse::<i32>().unwrap())
        .fold((<i32>::max_value(), <i32>::min_value()), |(min, max), val| {
            // There are utility fns i can probably use
            // but i'm gonna do this manually
            let nmin = if val < min { val } else { min };
            let nmax = if val > max { val } else { max };
            (nmin, nmax)
        });

    max - min
}
