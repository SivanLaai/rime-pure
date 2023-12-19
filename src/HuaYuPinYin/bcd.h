#ifndef BCD_H_
#define BCD_H_
#include <stdio.h>
#include <string.h>

#include "wrappers.h"
enum { kSignificantBytes = 7, kSignificantDigits = kSignificantBytes * 2 };
typedef struct {
  unsigned char integer[kSignificantBytes];
  unsigned char decimal[kSignificantBytes];
} Bcd;
void BcdPrint(const Bcd a) {
  size_t i;
  for (i = 0; i < kSignificantBytes - 1; ++i) {
    SafeFPrintF(stderr, "%02x ", a.integer[i]);
  }
  SafeFPrintF(stderr, "%02x . ", a.integer[i]);
  for (i = 0; i < kSignificantBytes - 1; ++i) {
    SafeFPrintF(stderr, "%02x ", a.decimal[i]);
  }
  SafeFPrintF(stderr, "%02x\n", a.decimal[i]);
}
unsigned char BcdGetDigit(const unsigned char *const array,
                          const size_t index) {
  const size_t byte_index = index / 2;
  if (index % 2 == 0) {
    return array[byte_index] >> 4;
  } else {
    return array[byte_index] & 0x0F;
  }
}
unsigned char BcdStructureGetDigit(const Bcd a, const size_t index) {
  return index < kSignificantDigits
             ? BcdGetDigit(a.integer, index)
             : BcdGetDigit(a.decimal, index - kSignificantDigits);
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
void BcdStructureSetDigit(Bcd *const a, const size_t index,
                          const unsigned char value) {
  if (index < kSignificantDigits) {
    BcdSetDigit(a->integer, index, value);
  } else {
    BcdSetDigit(a->decimal, index - kSignificantDigits, value);
  }
}
Bcd BcdFromInteger(unsigned long a) {
  Bcd decimal = {{0x00}, {0x00}};
  size_t i;
  for (i = kSignificantDigits; a != 0 && i--; a /= 10) {
    unsigned char digit = a % 10;
    if (i % 2 == 0) {
      decimal.integer[i / 2] |= digit << 4;
    } else {
      decimal.integer[i / 2] |= digit;
    }
  }
  return decimal;
}
unsigned long BcdToInteger(const Bcd a) {
  unsigned long result = 0;
  size_t i;
  for (i = 0; i < kSignificantBytes; ++i) {
    result *= 10;
    result += a.integer[i] >> 4;
    result *= 10;
    result += a.integer[i] & 0x0F;
  }
  if ((a.decimal[0] >> 4) >= 5) {
    result += 1;
  }
  return result;
}
static unsigned char BcdAddByte(const unsigned char a, const unsigned char b,
                                unsigned char *const carry) {
  unsigned char low, high;
  low = (a & 0x0F) + (b & 0x0F) + *carry;
  *carry = low / 10;
  low %= 10;
  high = (a >> 4) + (b >> 4) + *carry;
  *carry = high / 10;
  high %= 10;
  return high << 4 | low;
}
Bcd BcdAdd(const Bcd a, const Bcd b) {
  Bcd sum;
  unsigned char carry = 0;
  size_t i;
  for (i = kSignificantBytes; i--;) {
    sum.decimal[i] = BcdAddByte(a.decimal[i], b.decimal[i], &carry);
  }
  for (i = kSignificantBytes; i--;) {
    sum.integer[i] = BcdAddByte(a.integer[i], b.integer[i], &carry);
  }
  return sum;
}
static unsigned char BcdNinesComplementByte(const unsigned char a) {
  return ((9 - (a >> 4)) << 4) | (9 - (a & 0x0F));
}
static Bcd BcdNinesComplement(const Bcd a) {
  Bcd complement;
  size_t i;
  for (i = 0; i < kSignificantBytes; ++i) {
    complement.integer[i] = BcdNinesComplementByte(a.integer[i]);
    complement.decimal[i] = BcdNinesComplementByte(a.decimal[i]);
  }
  return complement;
}
Bcd BcdSubtract(const Bcd a, const Bcd b) {
  return BcdNinesComplement(BcdAdd(BcdNinesComplement(a), b));
}
Bcd BcdMultiply(const Bcd a, const Bcd b) {
  unsigned char products[kSignificantBytes * 4] = {0};
  size_t i, j;
  Bcd result;
  for (i = kSignificantDigits * 2; i--;) {
    unsigned char carry = 0;
    for (j = kSignificantDigits * 2; j--;) {
      size_t index = i + j + 1;
      unsigned char product =
          BcdGetDigit(products, index) +
          BcdStructureGetDigit(a, i) * BcdStructureGetDigit(b, j) + carry;
      carry = product / 10;
      BcdSetDigit(products, index, product - carry * 10);
    }
    BcdSetDigit(products, i, BcdGetDigit(products, i) + carry);
  }
  memcpy(result.integer, products + kSignificantBytes, kSignificantBytes);
  memcpy(result.decimal, products + kSignificantBytes * 2, kSignificantBytes);
  if (BcdGetDigit(products, kSignificantDigits * 3) >= 5) {
    Bcd rounding = {{0x00}, {0x00}};
    BcdSetDigit(rounding.decimal, kSignificantDigits - 1, 1);
    result = BcdAdd(result, rounding);
  }
  return result;
}
unsigned char BcdLessThan(const Bcd a, const Bcd b) {
  size_t i;
  for (i = 0; i < kSignificantBytes; ++i) {
    if (a.integer[i] < b.integer[i]) {
      return 1;
    } else if (a.integer[i] > b.integer[i]) {
      return 0;
    }
  }
  for (i = 0; i < kSignificantBytes; ++i) {
    if (a.decimal[i] < b.decimal[i]) {
      return 1;
    } else if (a.decimal[i] > b.decimal[i]) {
      return 0;
    }
  }
  return 0;
}
unsigned char BcdEqual(const Bcd a, const Bcd b) {
  size_t i;
  for (i = 0; i < kSignificantBytes; ++i) {
    if (a.integer[i] != b.integer[i]) {
      return 0;
    }
  }
  for (i = 0; i < kSignificantBytes; ++i) {
    if (a.decimal[i] != b.decimal[i]) {
      return 0;
    }
  }
  return 1;
}
Bcd BcdShiftLeft(const Bcd a) {
  Bcd result = a;
  unsigned char carry = 0;
  size_t i;
  for (i = kSignificantBytes; i--;) {
    unsigned char high = (result.decimal[i] & 0xF0) >> 4;
    unsigned char low = result.decimal[i] & 0x0F;
    result.decimal[i] = (low << 4) | carry;
    carry = high;
  }
  for (i = kSignificantBytes; i--;) {
    unsigned char high = (result.integer[i] & 0xF0) >> 4;
    unsigned char low = result.integer[i] & 0x0F;
    result.integer[i] = (low << 4) | carry;
    carry = high;
  }
  return result;
}
Bcd BcdDivide(const Bcd a, const Bcd b) {
  Bcd dividend = a;
  Bcd quotient = {{0x00}, {0x00}};
  size_t i;
  Bcd two = {{0x00}, {0x00}};
  BcdSetDigit(two.integer, kSignificantDigits - 1, 2);
  while (!BcdLessThan(dividend, b)) {
    Bcd divisor = b;
    Bcd temp;
    Bcd digit = {{0x00}, {0x00}};
    BcdSetDigit(digit.integer, kSignificantDigits - 1, 1);
    while (BcdLessThan(temp = BcdShiftLeft(divisor), dividend)) {
      divisor = temp;
      digit = BcdShiftLeft(digit);
    }
    dividend = BcdSubtract(dividend, divisor);
    quotient = BcdAdd(quotient, digit);
  }
  for (i = 0; i < kSignificantDigits; ++i) {
    Bcd digit = {{0x00}, {0x00}};
    BcdSetDigit(digit.decimal, i, 1);
    dividend = BcdShiftLeft(dividend);
    while (!BcdLessThan(dividend, b)) {
      Bcd divisor = b;
      Bcd temp;
      while (BcdLessThan(temp = BcdShiftLeft(divisor), dividend)) {
        divisor = temp;
        digit = BcdShiftLeft(digit);
      }
      dividend = BcdSubtract(dividend, divisor);
      quotient = BcdAdd(quotient, digit);
    }
  }
  if (!BcdLessThan(BcdMultiply(dividend, two), b)) {
    Bcd rounding = {{0x00}, {0x00}};
    BcdSetDigit(rounding.decimal, kSignificantDigits - 1, 1);
    quotient = BcdAdd(quotient, rounding);
  }
  return quotient;
}
Bcd BcdLog(const Bcd x, const Bcd base) {
  const Bcd half = {{0x00}, {0x50}};
  Bcd temp = x;
  Bcd y = {{0x00}, {0x00}};
  Bcd b = half;
  Bcd one = {{0x00}, {0x00}};
  Bcd tol = {{0x00}, {0x00}};
  Bcd reciprocal_base;
  BcdSetDigit(one.integer, kSignificantDigits - 1, 1);
  BcdSetDigit(tol.decimal, kSignificantDigits - 1, 1);
  reciprocal_base = BcdDivide(one, base);
  while (!BcdLessThan(temp, base)) {
    temp = BcdMultiply(temp, reciprocal_base);
    y = BcdAdd(y, one);
  }
  while (BcdLessThan(tol, b)) {
    temp = BcdMultiply(temp, temp);
    if (!BcdLessThan(temp, base)) {
      temp = BcdMultiply(temp, reciprocal_base);
      y = BcdAdd(y, b);
    }
    b = BcdMultiply(b, half);
  }
  return y;
}
#endif
