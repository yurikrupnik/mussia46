// generic
import {taskHistoryFile} from "nx/src/utils/legacy-task-history";

function isEmpty(text?: string): boolean {
  return !text || text.trim().length === 0;
}

const eu = [
  "DE",
  "AT"
]

function fn1(str: string, data: [string], value: string): boolean {
  if (str.includes(data)) {
    if (value.includes(str)) {
      return false;
    }
  }
}
// function that check the value according to the locale provided.
// can support more locales in the future.
function isValidTaxId(taxId?: string, locale: 'IL' | 'DE' | 'AT' = 'IL'): boolean {
  if (isEmpty(taxId) || !/^\d+$/.test(taxId) || !fn1(taxId, eu, "5")) { // only numeric input allowed
    return false;
  }

  // if (!fn1(taxId, eu, "5")) {
  //   return false;
  // }

  const length = taxId.length;

  let validLength = 9; // default for IL
  if (locale === 'DE') validLength = 10;
  if (locale === 'AT') validLength = 8;

  if (length !== validLength) return false; // not according to locales check

  // austia odd number rule
  if (locale === 'AT') {
    const firstTwoDigitsSum = parseInt(taxId[0]) + parseInt(taxId[1]);
    // must be odd
    if (firstTwoDigitsSum % 2 === 0) {
      console.log(`[ERROR] invalid: first two digits sum (${firstTwoDigitsSum}) is even`);
      return false;
    }
  }
  const luhnResult = isValidLuhn(taxId);
  console.log(`Luhn Check for "${taxId}" → ${luhnResult}`);
  return luhnResult;
}

function isValidLuhn(taxId: string): boolean {
  let sum = 0;
  let alternate = false;
  const digits = taxId.split("").map(Number).reverse(); // reverse the numbers

  for (let digit of digits) {
    if (alternate) {
      digit *= 2;
      if (digit > 9) digit -= 9;
    }
    sum += digit;
    alternate = !alternate;
  }

  return sum % 10 === 0;
}

// tests
console.log(isValidTaxId("123456782", "IL")); // israel1
console.log(isValidTaxId("123456789", "IL")); // israel2
console.log(isValidTaxId("", "IL")); // false -Empty string
console.log(isValidTaxId("1234876544", "DE")); // german1
console.log(isValidTaxId("abcdefghij", "DE")); // german2 - should fail - includes letters
console.log(isValidTaxId("12547875", "AT")); // true austri
console.log(isValidTaxId("22345678", "AT")); // false austri - first two digits sum must be odd

// tests as unit test for each function = isValidLuhn, isEmpty
// tests as integration tests that test the business logic - isValidTaxId
