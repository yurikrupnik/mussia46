use std::collections::HashSet;
use rand::Rng;
use rand::{SeedableRng};
use rand::rngs::StdRng;
use rayon::prelude::*;
use dashmap::DashSet;

pub mod app;
pub mod errors;
pub mod handlers;
pub mod shutdown;

// pub fn random_array_with_numbers(size: usize) -> Vec<u32> {
//   let mut rng = rand::thread_rng();
//   (0..size).map(|_| rng.gen_range(1..10)).collect()
// }

pub fn random_array_with_numbers(size: usize) -> Vec<u32> {
  let mut rng = StdRng::seed_from_u64(42); // Fixed seed for repeatability
  (0..size).map(|_| rng.gen_range(1..=10)).collect()
  // (0..size)
  //   .into_par_iter() // Use Rayon’s parallel iterator
  //   .map(|_| rng.gen_range(1..=10)) // Parallel number generation
  //   .collect()
}

// Using HashMap for Duplicate Check
pub fn using_map(arr: &[u32]) -> bool {
  let mut seen = HashSet::new();
  for &num in arr {
    if seen.contains(&num) {
      return true;
    }
    seen.insert(num);
  }
  false
}

// Using Set for Duplicate Check
pub fn using_set(arr: &[u32]) -> bool {
  let unique: HashSet<_> = arr.iter().collect();
  unique.len() < arr.len()
}

pub fn using_set_optimized(arr: &[u32]) -> bool {
  let mut seen = HashSet::with_capacity(arr.len()); // Preallocate space
  for &num in arr {
    if !seen.insert(num) { // `.insert()` returns false if num is already in the set
      return true;
    }
  }
  false
}


pub fn using_map_parallel(arr: &[u32]) -> bool {
  let seen = DashSet::new();

  arr.par_iter().any(|&num| {
    !seen.insert(num) // Lock-free, thread-safe insertion
  })
}

pub fn using_set_optimized_parallel(arr: &[u32]) -> bool {
  let seen = DashSet::new(); // Lock-free, concurrent HashSet

  arr.par_iter().any(|&num| {
    !seen.insert(num) // Directly insert without locking
  })
}
