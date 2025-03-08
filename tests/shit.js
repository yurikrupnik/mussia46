// let str = "hello world";
//
// setTimeout(() => {
//   console.log("aris");
// }, 0, "time out callback"); // Short timeout
//
//
// for (var i = 0; i < 1000; i++) {
//   log(i);
// }
//
// function log(v) {
//   console.log(v);
// }

const arr = randomArrayWithNumbers(1000);

function randomArrayWithNumbers(size) {
  return Array.from({ length: size }, () => Math.floor(Math.random() * 10));
}


function usingSet(arr) {
  return new Set(arr).size < arr.length;
}

function usingMap(arr) {
  const seen = {};
  // for (const num of arr) {
  for (let i = 0; i < arr.length; i++) {
  // for (const i in arr) {
    const num = arr[i];
    if (seen[num]) return true; // Duplicate found
    seen[num] = true;
  }
  return false;
}

function usingMapSet(arr) {
  let set = new Set();
  for (let i = 0; i < arr.length; i++) {
    const num = arr[i];
    if (set.has(num)) return true; // Duplicate found
    set.add(num)
  }
  return false;
}

function usingMapMap(arr) {
  let map = new Map();
  for (let i = 0; i < arr.length; i++) {
    const num = arr[i];
    if (map.has(num)) return true; // Duplicate found
    map.set(num, i)
  }
  return false;
}


function usingSort(arr) {
  let sortedArr = arr.sort();
  for (let i = 0; i < sortedArr.length - 1; i++) {
    if (sortedArr[i] === sortedArr[i + 1]) {
      return true; // Duplicate found
    }
  }
  return false;
}

function usingSome(arr) {
  return arr.some((num, i) => arr.indexOf(num) !== i);
}

Deno.bench("usingSort", () => {
  usingSort(arr);
});

Deno.bench("usingSet", () => {
  usingSet(arr);
});

Deno.bench("usingSome", () => {
  usingSome(arr);
});
Deno.bench("usingMap", () => {
  usingMap(arr);
});

Deno.bench("usingMapSet", () => {
  usingMapSet(arr);
});
Deno.bench("usingMapMap", () => {
  usingMapMap(arr);
});
