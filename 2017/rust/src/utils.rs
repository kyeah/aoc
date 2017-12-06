use std::env;
use std::str::FromStr;
use std::fmt::Debug;

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
