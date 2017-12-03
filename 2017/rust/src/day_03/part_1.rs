pub fn manhattan_distance(val: i32) -> i32 {
    (1..<i32>::max_value())
        .find(|&base| base.pow(2) >= val)
        .map(|base| penalty(base, val))
        .expect("lol")
}

// Calculate penalty by traversing the squared corner.
//
// e.g. 
// 17
// 18
// 19
// 20
// 21 22 23 24 25
//
// start at 25 and work your way to 17.
fn penalty(base: i32, val: i32) -> i32 {
    // The minimum distance on this corner.
    let min = ((base + (base % 2)) / 2) - 1;
    // The maximum distance on this corner.
    let max = base - 1;

    // begin at the end of the corner and decrement.
    let mut decr = true;
    let mut penalty = max;

    for _ in 0..(base.pow(2) - val) {
        decr = (!decr && penalty == max) || (decr && penalty != min);
        penalty += if decr { -1 } else { 1 };
    }

    penalty
}
