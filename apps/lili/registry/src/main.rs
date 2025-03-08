use rand::Rng;
use std::collections::HashSet;

// Function to generate a random array
fn random_array_with_numbers(size: usize) -> Vec<u32> {
  let mut rng = rand::thread_rng();
  (0..size).map(|_| rng.gen_range(1..10)).collect()
}

// Using Set for Duplicate Check
fn using_set(arr: &[u32]) -> bool {
  let unique: HashSet<_> = arr.iter().collect();
  unique.len() < arr.len()
}



// Using HashMap for Duplicate Check
fn using_map(arr: &[u32]) -> bool {
  let mut seen = HashSet::new();
  for &num in arr {
    if seen.contains(&num) {
      return true;
    }
    seen.insert(num);
  }
  false
}

fn main() {
  let data = random_array_with_numbers(20);
  let s= using_map(&data);
  let d= using_set(&data);
}
