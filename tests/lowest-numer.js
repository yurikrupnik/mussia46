
const arr = [11, 2, 1, 4, 5, 6, 3];

function usingSort(arr) {
  const sorted = arr.sort();
  return sorted[0];
}

function usingMap(arr) {
  let num = arr[0];
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] < num) {
      num = arr[i]
    }
  }
  return num
}

function usingReduce(arr) {
  return arr.reduce((max, num) => {
    return num < max ? num : max
  }, arr[0])
}
function usingMathMax(arr) {
  return Math.min(...arr);
}
function usingMathMaxApply(arr) {
  return Math.min.apply(null, arr);
}

Deno.bench("usingSort", () => {
  usingSort(arr);
});
Deno.bench("usingMap", () => {
  usingMap(arr);
});
Deno.bench("usingReduce", () => {
  usingReduce(arr);
});
Deno.bench("usingMathMax", () => {
  usingMathMax(arr);
});
Deno.bench("usingMathMaxApply", () => {
  usingMathMaxApply(arr);
});
