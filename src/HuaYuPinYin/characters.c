#include <assert.h>
#include <stdio.h>

#include "wrappers.h"
const char *const initials[] = {"",  "b",  "c", "ch", "d", "f", "g", "h",
                                "j", "k",  "l", "m",  "n", "p", "q", "r",
                                "s", "sh", "t", "w",  "x", "y", "z", "zh"};
const char *const finals[] = {"",     "a",   "ai",  "an", "ang", "ao",   "e",
                              "ei",   "en",  "eng", "er", "i",   "ia",   "ian",
                              "iang", "iao", "ie",  "in", "ing", "iong", "iu",
                              "o",    "ong", "ou",  "u",  "ua",  "uai",  "uan",
                              "uang", "ue",  "ui",  "un", "uo",  "v"};
size_t Utf32ToUtf8(unsigned char *utf8, const unsigned long utf32) {
  if (utf32 <= 0x7F) {
    *utf8 = utf32;
    return 1;
  }
  if (utf32 <= 0x7FF) {
    *utf8++ = 0xC0 | (utf32 >> 6);
    *utf8 = 0x80 | (utf32 & 0x3F);
    return 2;
  }
  if (utf32 <= 0xFFFF) {
    *utf8++ = 0xE0 | (utf32 >> 12);
    *utf8++ = 0x80 | ((utf32 >> 6) & 0x3F);
    *utf8 = 0x80 | (utf32 & 0x3F);
    return 3;
  }
  if (utf32 <= 0x10FFFF) {
    *utf8++ = 0xF0 | (utf32 >> 18);
    *utf8++ = 0x80 | ((utf32 >> 12) & 0x3F);
    *utf8++ = 0x80 | ((utf32 >> 6) & 0x3F);
    *utf8 = 0x80 | (utf32 & 0x3F);
    return 4;
  }
  return 0;
}
unsigned long BytesToUInt32(const unsigned char *const bytes) {
  return bytes[3] << 24 | bytes[2] << 16 | bytes[1] << 8 | bytes[0];
}
int main(void) {
  FILE *const file_in = SafeFOpen("hzpy.dat", "rb");
  FILE *const file_out = SafeFOpen("clover.base.dict.yaml", "wb");
  FILE *const file_out_tone = SafeFOpen("clover_terra.base.dict.yaml", "wb");
  unsigned char buffer[4];
  unsigned long count;
  SafeFSeek(file_in, 16, SEEK_SET);
  SafeFRead(buffer, 4, 1, file_in);
  count = BytesToUInt32(buffer);
  printf("Character count: %lu\n", (unsigned long)count);
  while (count--) {
    unsigned long utf32_character, frequency;
    unsigned char character[5];
    size_t utf8_length;
    unsigned char initial, final, tone, i;
    SafeFRead(buffer, 4, 1, file_in);
    utf32_character = BytesToUInt32(buffer);
    utf8_length = Utf32ToUtf8(character, utf32_character);
    assert(utf8_length);
    character[utf8_length] = '\0';
    SafeFSeek(file_in, 2, SEEK_CUR);
    SafeFRead(buffer, 2, 1, file_in);
    initial = buffer[0] & 0x1F;
    assert(initial <= 23);
    final = (buffer[1] & 0x07) << 3 | buffer[0] >> 5;
    assert(1 <= final && final <= 33);
    tone = buffer[1] >> 3;
    SafeFRead(buffer, 4, 1, file_in);
    frequency = BytesToUInt32(buffer);
    SafeFRead(buffer, 1, 1, file_in);
    /* 是繁体且不是简体，降低字频 */
    if (*buffer & 2 && !(*buffer & 1)) frequency >>= 10;
    SafeFPrintF(file_out, "%s\t%s%s\t%lu\n", character, initials[initial],
                finals[final], frequency);
    for (i = 1; i <= 5; i++, tone >>= 1) {
      if (tone & 1) {
        SafeFPrintF(file_out_tone, "%s\t%s%s%u\t%lu\n", character,
                    initials[initial], finals[final], i, frequency);
      }
    }
    SafeFSeek(file_in, 3, SEEK_CUR);
  }
  fclose(file_in);
  fclose(file_out);
  fclose(file_out_tone);
  return 0;
}
