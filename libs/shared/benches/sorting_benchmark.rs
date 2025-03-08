use criterion::{
  black_box,
  criterion_group,
  criterion_main,
  Criterion
};

use shared::{using_map, using_set, using_set_optimized};
use shared::{random_array_with_numbers, using_set_optimized_parallel, using_map_parallel};



fn benchmark_functions(c: &mut Criterion) {
  // Generate test data once for all benchmarks
  let arr = black_box(random_array_with_numbers(1000)); // 10,000 random numbers

  // Benchmark using_set
  c.bench_function("using_set", |b| b.iter(|| using_set(&arr)));

  // Benchmark using_map
  c.bench_function("using_map", |b| b.iter(|| using_map(&arr)));

  // Benchmark using_set_optimized
  c.bench_function("using_set_optimized", |b| b.iter(|| using_set_optimized(&arr)));
  c.bench_function("using_map_parallel", |b| b.iter(|| using_map_parallel(&arr)));
  c.bench_function("using_set_optimized_parallel", |b| b.iter(|| using_set_optimized_parallel(&arr)));
}
// fn benchmark_using_set(c: &mut Criterion) {
//   let arr = black_box(vec![1, 2, 3, 4, 5, 6, 4]);
//   c.bench_function("using_set", |b| b.iter(|| using_set(&arr)));
// }
// fn benchmark_using_map(c: &mut Criterion) {
//   let arr = black_box(vec![1, 2, 3, 4, 5, 6, 4]);
//   c.bench_function("using_map", |b| b.iter(|| using_map(&arr)));
// }
//
// fn benchmark_using_set_optimized(c: &mut Criterion) {
//   let arr = black_box(vec![1, 2, 3, 4, 5, 6, 4]);
//   c.bench_function("using_set_optimized", |b| b.iter(|| using_set_optimized(&arr)));
// }

// Register the benchmarks
criterion_group!(benches, benchmark_functions);
criterion_main!(benches);
