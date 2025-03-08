// Find Missing Number:
// Given an array containing n distinct numbers from 0 to n, find the missing number in O(n) time.

const arr = [3, 1, 0];

function missingNumber(arr) {
  const n = arr.length;
  const expectedSum = (n * (n + 1)) / 2;
  const actualSum = arr.reduce((acc, num) => acc + num, 0);
  return expectedSum - actualSum;
}

console.log(missingNumber(arr));
