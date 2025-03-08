
const arr = [1, 2, 1, 4, 5, 6, 3];

function usingSort(arr) {
  const sorted = arr.sort();
  return sorted[sorted.length - 1];
}

function usingMap(arr) {
  let num = 0;
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] > num) {
      num = arr[i]
    }
  }
  return num
}

function usingMapMap(arr) {
  let num = 0;
  // const set = new Map()
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] > num) {
      num = arr[i]
    }
  }
  return num
}

function usingReduce(arr) {
  return arr.reduce((max, num) => {
    return num > max ? num : max
  }, arr[0])
}
function usingMathMax(arr) {
  return Math.max(...arr);
}
function usingMathMaxApply(arr) {
  return Math.max.apply(null, arr);
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
Deno.bench("usingMapSet", () => {
  usingMapSet(arr);
});
