#include <assert.h>
#include <stdint.h>
#include <stdio.h>
const char *const initials[] = {"",  "b",  "c", "ch", "d", "f", "g", "h",
                                "j", "k",  "l", "m",  "n", "p", "q", "r",
                                "s", "sh", "t", "w",  "x", "y", "z", "zh"};
const char *const finals[] = {"",     "a",   "ai",  "an", "ang", "ao",   "e",
                              "ei",   "en",  "eng", "er", "i",   "ia",   "ian",
                              "iang", "iao", "ie",  "in", "ing", "iong", "iu",
                              "o",    "ong", "ou",  "u",  "ua",  "uai",  "uan",
                              "uang", "ue",  "ui",  "un", "uo",  "v"};
size_t utf32_to_utf8(uint8_t *const utf8, const uint32_t utf32) {
  if (utf32 <= 0x7F) {
    utf8[0] = utf32;
    return 1;
  }
  if (utf32 <= 0x7FF) {
    utf8[0] = 0xC0 | (utf32 >> 6);
    utf8[1] = 0x80 | (utf32 & 0x3F);
    return 2;
  }
  if (utf32 <= 0xFFFF) {
    utf8[0] = 0xE0 | (utf32 >> 12);
    utf8[1] = 0x80 | ((utf32 >> 6) & 0x3F);
    utf8[2] = 0x80 | (utf32 & 0x3F);
    return 3;
  }
  if (utf32 <= 0x10FFFF) {
    utf8[0] = 0xF0 | (utf32 >> 18);
    utf8[1] = 0x80 | ((utf32 >> 12) & 0x3F);
    utf8[2] = 0x80 | ((utf32 >> 6) & 0x3F);
    utf8[3] = 0x80 | (utf32 & 0x3F);
    return 4;
  }
  return 0;
}
uint16_t bytes_to_uint16(const unsigned char *const bytes) {
  return bytes[1] << 8 | bytes[0];
}
uint32_t bytes_to_uint32(const unsigned char *const bytes) {
  return bytes[3] << 24 | bytes[2] << 16 | bytes[1] << 8 | bytes[0];
}
int main() {
  FILE *const file_in = fopen("hzpy.dat", "rb");
  FILE *const file_out = fopen("clover.base.dict.yaml", "wb");
  FILE *const file_out_tone = fopen("clover_terra.base.dict.yaml", "wb");
  if (file_in == NULL || file_out == NULL || file_out_tone == NULL) {
    perror("fopen");
    fclose(file_in);
    fclose(file_out);
    fclose(file_out_tone);
    return 1;
  }
  fseek(file_in, 16, SEEK_SET);
  uint8_t buffer[4];
  fread(buffer, 4, 1, file_in);
  uint32_t count = bytes_to_uint32(buffer);
  printf("Character count: %lu\n", (unsigned long)count);
  while (count--) {
    fread(buffer, 4, 1, file_in);
    const uint32_t u32character = bytes_to_uint32(buffer);
    unsigned char character[5] = {0};
    assert(utf32_to_utf8(character, u32character));
    fseek(file_in, 2, SEEK_CUR);
    fread(buffer, 2, 1, file_in);
    const uint8_t initial = buffer[0] & 0x1F;
    assert(0 <= initial && initial <= 23);
    const uint8_t final = (buffer[1] & 0x07) << 3 | buffer[0] >> 5;
    assert(1 <= final && final <= 33);
    uint8_t tone = buffer[1] >> 3;
    fread(buffer, 4, 1, file_in);
    uint32_t frequency = bytes_to_uint32(buffer);
    fread(buffer, 1, 1, file_in);
    /* 是繁体且不是简体，降低字频 */
    if (*buffer & 2 && !(*buffer & 1)) frequency >>= 10;
    fprintf(file_out, "%s\t%s%s\t%lu\n", character, initials[initial],
            finals[final], (unsigned long)frequency);
    uint8_t i;
    for (i = 1; i <= 5; i++, tone >>= 1)
      if (tone & 1)
        fprintf(file_out_tone, "%s\t%s%s%u\t%lu\n", character,
                initials[initial], finals[final], i, (unsigned long)frequency);
    fseek(file_in, 3, SEEK_CUR);
  }
  fclose(file_in);
  fclose(file_out);
  fclose(file_out_tone);
  return 0;
}
