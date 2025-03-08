// Longest Substring Without Repeating Characters:
// Given a string, find the length of the longest substring without repeating characters.

function lengthOfLongestSubstring(s) {
  let charSet = new Set();
  let left = 0;
  let maxLength = 0;

  for (let right = 0; right < s.length; right++) {
    while (charSet.has(s[right])) {
      charSet.delete(s[left]);
      left++;
    }
    charSet.add(s[right]);
    maxLength = Math.max(maxLength, right - left + 1);
  }

  return maxLength;
}

function lengthOfLongestSubstringMap(s) {
  let charMap = new Map();
  let maxLength = 0;
  let left = 0;

  for (let right = 0; right < s.length; right++) {
    if (charMap.has(s[right]) && charMap.get(s[right]) >= left) {
      left = charMap.get(s[right]) + 1;
    }
    charMap.set(s[right], right);
    maxLength = Math.max(maxLength, right - left + 1);
  }

  return maxLength;
}

const s = "abcabcbb";
const ss = "pwwkew";

Deno.bench("lengthOfLongestSubstringMap", () => {
  lengthOfLongestSubstringMap(ss);
  lengthOfLongestSubstringMap(s);
});
Deno.bench("lengthOfLongestSubstring", () => {
   lengthOfLongestSubstring(ss);
   lengthOfLongestSubstring(s);
});
