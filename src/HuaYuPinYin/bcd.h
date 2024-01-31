#ifndef BCD_H_
#define BCD_H_
#include <string.h>

#include "wrappers.h"
void BcdPrint(const unsigned char *const a, const size_t length) {
  const size_t half_length = length / 2;
  size_t i;
  for (i = 0; i < half_length - 1; ++i) {
    SafeFPrintF(stderr, "%02x ", a[i]);
  }
  SafeFPrintF(stderr, "%02x . ", a[i]);
  for (i = half_length; i < length - 1; ++i) {
    SafeFPrintF(stderr, "%02x ", a[i]);
  }
  SafeFPrintF(stderr, "%02x\n", a[i]);
}
unsigned char BcdGetDigit(const unsigned char *const a, const size_t index) {
  const size_t byte_index = index / 2;
  if (index % 2 == 0) {
    return a[byte_index] >> 4;
  } else {
    return a[byte_index] & 0x0F;
  }
}
void BcdSetDigit(unsigned char *const array, const size_t index,
                 const unsigned char value) {
  const size_t byte_index = index / 2;
  if (index % 2 == 0) {
    array[byte_index] = (array[byte_index] & 0x0F) | (value << 4);
  } else {
    array[byte_index] = (array[byte_index] & 0xF0) | value;
  }
}
void BcdFromInteger(unsigned char *const result, const unsigned long a,
                    const size_t length) {
  unsigned long temp = a;
  size_t i;
  memset(result, 0, length);
  for (i = length; temp != 0 && i--;) {
    const unsigned long remaining = temp / 10;
    const unsigned char digit = temp - remaining * 10;
    if (i % 2 == 0) {
      result[i / 2] |= digit << 4;
    } else {
      result[i / 2] |= digit;
    }
    temp = remaining;
  }
}
unsigned long BcdToInteger(const unsigned char *const a, const size_t length) {
  const unsigned long half_length = length / 2;
  unsigned long result = 0;
  size_t i;
  for (i = 0; i < half_length; ++i) {
    result *= 10;
    result += a[i] >> 4;
    result *= 10;
    result += a[i] & 0x0F;
  }
  if ((a[half_length] >> 4) >= 5) {
    result += 1;
  }
  return result;
}
static unsigned char BcdAddByte(const unsigned char a, const unsigned char b,
                                unsigned char *const carry) {
  unsigned char low;
  unsigned char high;
  low = (a & 0x0F) + (b & 0x0F) + *carry;
  *carry = low / 10;
  low -= *carry * 10;
  high = (a >> 4) + (b >> 4) + *carry;
  *carry = high / 10;
  high -= *carry * 10;
  return high << 4 | low;
}
void BcdAdd(unsigned char *const result, const unsigned char *const a,
            const unsigned char *const b, const size_t length) {
  unsigned char carry = 0;
  size_t i;
  for (i = length; i--;) {
    result[i] = BcdAddByte(a[i], b[i], &carry);
  }
}
static unsigned char BcdNinesComplementByte(const unsigned char a) {
  return ((9 - (a >> 4)) << 4) | (9 - (a & 0x0F));
}
static void BcdNinesComplement(unsigned char *const result,
                               const unsigned char *const a,
                               const size_t length) {
  size_t i;
  for (i = 0; i < length; ++i) {
    result[i] = BcdNinesComplementByte(a[i]);
  }
}
void BcdSubtract(unsigned char *const result, const unsigned char *const a,
                 const unsigned char *const b, const size_t length) {
  BcdNinesComplement(result, a, length);
  BcdAdd(result, result, b, length);
  BcdNinesComplement(result, result, length);
}
void BcdMultiply(unsigned char *const result, const unsigned char *const a,
                 const unsigned char *const b, const size_t length) {
  const size_t digit_count = length * 2;
  unsigned char *const products = (unsigned char *)SafeCAlloc(length * 2, 1);
  size_t i;
  for (i = digit_count; i--;) {
    unsigned char carry = 0;
    size_t j;
    for (j = digit_count; j--;) {
      const size_t index = i + j + 1;
      const unsigned char product = BcdGetDigit(products, index) +
                                    BcdGetDigit(a, i) * BcdGetDigit(b, j) +
                                    carry;
      carry = product / 10;
      BcdSetDigit(products, index, product - carry * 10);
    }
    BcdSetDigit(products, i, BcdGetDigit(products, i) + carry);
  }
  memcpy(result, products + length / 2, length);
  if (BcdGetDigit(products, length * 3) >= 5) {
    unsigned char *const rounding = (unsigned char *)SafeCAlloc(length, 1);
    BcdSetDigit(rounding, length * 2 - 1, 1);
    BcdAdd(result, result, rounding, length);
    free(rounding);
  }
  free(products);
}
void BcdMultiplyScaled(unsigned char *const result,
                       const unsigned char *const a,
                       const unsigned char *const b, const size_t length) {
  const size_t digit_count = length * 2;
  unsigned char *const products = (unsigned char *)SafeCAlloc(length * 2, 1);
  size_t i;
  for (i = digit_count; i--;) {
    unsigned char carry = 0;
    size_t j;
    for (j = digit_count; j--;) {
      const size_t index = i + j + 1;
      const unsigned char product = BcdGetDigit(products, index) +
                                    BcdGetDigit(a, i) * BcdGetDigit(b, j) +
                                    carry;
      carry = product / 10;
      BcdSetDigit(products, index, product - carry * 10);
    }
    BcdSetDigit(products, i, BcdGetDigit(products, i) + carry);
  }
  memcpy(result, products, length);
  if (BcdGetDigit(products, length * 2) >= 5) {
    unsigned char *const rounding = (unsigned char *)SafeCAlloc(length, 1);
    BcdSetDigit(rounding, length * 2 - 1, 1);
    BcdAdd(result, result, rounding, length);
    free(rounding);
  }
  free(products);
}
unsigned char BcdLessThan(const unsigned char *const a,
                          const unsigned char *const b, const size_t length) {
  size_t i;
  for (i = 0; i < length; ++i) {
    if (a[i] < b[i]) {
      return 1;
    } else if (a[i] > b[i]) {
      return 0;
    }
  }
  return 0;
}
unsigned char BcdEqual(const unsigned char *const a,
                       const unsigned char *const b, const size_t length) {
  size_t i;
  for (i = 0; i < length; ++i) {
    if (a[i] != b[i]) {
      return 0;
    }
  }
  return 1;
}
void BcdShiftLeft(unsigned char *const result, const unsigned char *const a,
                  const size_t length) {
  unsigned char carry = 0;
  size_t i;
  memmove(result, a, length);
  for (i = length; i--;) {
    const unsigned char high = (result[i] & 0xF0) >> 4;
    const unsigned char low = result[i] & 0x0F;
    result[i] = (low << 4) | carry;
    carry = high;
  }
}
void BcdDivide(unsigned char *const result, const unsigned char *const a,
               const unsigned char *const b, const size_t length) {
  const size_t first_byte = length / 2 + 1;
  const size_t total_length = length + first_byte;
  const size_t last_digit = length * 3 + 1;
  unsigned char *const b_copy = (unsigned char *)SafeCAlloc(total_length, 1);
  unsigned char *const dividend = (unsigned char *)SafeCAlloc(total_length, 1);
  unsigned char *const temp = (unsigned char *)SafeMAlloc(total_length);
  unsigned char *const quotient = (unsigned char *)SafeCAlloc(total_length, 1);
  memcpy(b_copy + first_byte, b, length);
  memcpy(dividend + 1, a, length);
  while (!BcdLessThan(dividend, b_copy, total_length)) {
    unsigned char *const divisor = (unsigned char *)SafeCAlloc(total_length, 1);
    unsigned char *const digit = (unsigned char *)SafeCAlloc(total_length, 1);
    memcpy(divisor + first_byte, b, length);
    BcdSetDigit(digit, last_digit, 1);
    while (BcdLessThan((BcdShiftLeft(temp, divisor, total_length), temp),
                       dividend, total_length)) {
      memcpy(divisor, temp, total_length);
      BcdShiftLeft(digit, digit, total_length);
    }
    BcdSubtract(dividend, dividend, divisor, total_length);
    BcdAdd(quotient, quotient, digit, total_length);
    free(divisor);
    free(digit);
  }
  if (!BcdLessThan((BcdAdd(temp, dividend, dividend, total_length), temp),
                   b_copy, total_length)) {
    unsigned char *const rounding =
        (unsigned char *)SafeCAlloc(total_length, 1);
    BcdSetDigit(rounding, last_digit, 1);
    BcdAdd(quotient, quotient, rounding, total_length);
    free(rounding);
  }
  BcdPrint(quotient, total_length);
  memcpy(result, quotient + first_byte, length);
  BcdPrint(result, length);
  free(b_copy);
  free(dividend);
  free(temp);
  free(quotient);
}
#endif
