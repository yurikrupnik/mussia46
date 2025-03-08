// First Non-Repeating Character:
// Given a string, find the first non-repeating character and return its index.


const str = "loveleetcode"

function finds(str) {
  const charCount = new Map();

  for (const char of str) {
    charCount.set(char, (charCount.get(char) || 0) + 1);
  }

  // Find the index of the first non-repeating character
  for (let i = 0; i < str.length; i++) {
    if (charCount.get(str[i]) === 1) {
      return i;
    }
  }

  return -1;
}


const s = finds(str);
console.log(s)
