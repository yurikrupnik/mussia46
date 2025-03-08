// Find Duplicates: Given an array of integers, find and return all duplicate elements in the array.

const arr = [1, 2, 3, 4, 5, 3, 5];

function findDuplicatesSome(nums) {
  return [...new Set(nums.filter((num, index, arr) =>
    arr.some((val, i) => val === num && i !== index)
  ))];
}

function findDuplicatesFilter(nums) {
  return nums.filter((num, index) => nums.indexOf(num) !== index)
}

function findDuplicatesFilterSet(nums) {
  return [...new Set(nums.filter((num, index) => nums.indexOf(num) !== index))];
}

function findDuplicatesReduce(nums) {
  let countMap = nums.reduce((acc, num) => {
    acc[num] = (acc[num] || 0) + 1;
    return acc;
  }, {});

  return Object.keys(countMap)
    .filter(num => countMap[num] > 1)
    .map(Number);
}

function duplicatesSet(arr) {
  let seen = new Set();
  let duplicates = new Set();
  for (let i = 0; i < arr.length; i++) {
    if (seen.has(arr[i])) {
      duplicates.add(arr[i])
    } else {
      seen.add(arr[i])
    }
  }
  return Array.from(duplicates);
}

function duplicatesMap(arr) {
  let seen = new Map();
  let duplicates = new Map();
  for (let i = 0; i < arr.length; i++) {
    if (seen.has(arr[i])) {
      duplicates.set(arr[i], i)
    } else {
      seen.set(arr[i], i)
    }
  }
  return Array.from(duplicates.keys());
}

function duplicatesObject(arr) {
  let seen = {};
  let duplicates = {};
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] in seen) {
      duplicates[arr[i]] = i
    } else {
      seen[arr[i]] = i
    }
  }
  return Object.keys(duplicates);
}

Deno.bench("findDuplicatesFilter", () => {
  findDuplicatesFilter(arr);
});
Deno.bench("findDuplicatesFilterSet", () => {
  findDuplicatesFilterSet(arr);
});
Deno.bench("findDuplicatesReduce", () => {
  findDuplicatesReduce(arr);
});
Deno.bench("duplicatesSet", () => {
  const s = duplicatesSet(arr);
});
Deno.bench("findDuplicatesSome", () => {
  const s = findDuplicatesSome(arr);
  // console.log(s)
});
Deno.bench("duplicatesMap", () => {
  const s = duplicatesMap(arr);
});
Deno.bench("duplicatesObject", () => {
  const s = duplicatesObject(arr);
});
