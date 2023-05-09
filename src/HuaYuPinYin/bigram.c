/* darts.h from https://github.com/BYVoid/libdarts/blob/master/src/darts.h,
darts.hh from https://github.com/s-yata/darts-clone/blob/master/include/darts.h
*/
#include <assert.h>
#include <darts.h>
#include <float.h>
#include <iconv.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "wrappers.h"
enum { kMaxWordLength = 8, kRadix = 256, kInitialSize = 2 };
unsigned long BytesToUint32(const unsigned char *const array) {
  return array[3] << 24 | array[2] << 16 | array[1] << 8 | array[0];
}
size_t GbkToUtf8(char *const gbk_str, size_t gbk_bytes, char *const utf8_str,
                 size_t utf8_bytes) {
  char *in_buf = gbk_str;
  char *out_buf = utf8_str;
  const iconv_t cd = iconv_open("UTF-8", "GBK");
  size_t out_bytes_left = utf8_bytes, result_bytes;
  if (cd == (iconv_t)-1) {
    perror("iconv_open");
    exit(EXIT_FAILURE);
  }
  if (iconv(cd, &in_buf, &gbk_bytes, &out_buf, &out_bytes_left) == (size_t)-1) {
    perror("iconv");
    exit(EXIT_FAILURE);
  }
  if (iconv_close(cd) == -1) {
    perror("iconv_close");
    exit(EXIT_FAILURE);
  }
  result_bytes = utf8_bytes - out_bytes_left;
  utf8_str[result_bytes] = '\0';
  return result_bytes;
}
size_t ReadString(FILE *const file, char *const buffer, const size_t bytes) {
  int c;
  char *p = buffer;
  while ((c = SafeFGetC(file)) != EOF && c != '\0' && p < buffer + bytes)
    *p++ = (char)c;
  *p = '\0';
  return p - buffer;
}
void LsdSort(char **keys, size_t *lengths, int *values, const size_t n) {
  size_t i, j;
  size_t count[kRadix + 1];
  char **aux_keys = (char **)SafeMAlloc(n * sizeof(char *));
  size_t *aux_lengths = (size_t *)SafeMAlloc(n * sizeof(size_t));
  int *aux_values = (int *)SafeMAlloc(n * sizeof(int));
  size_t max_length = 0, d;
  for (i = 0; i < n; ++i) {
    if (lengths[i] > max_length) {
      max_length = lengths[i];
    }
  }
  for (d = max_length; d--;) {
    memset(count, 0, sizeof(count));
    for (i = 0; i < n; ++i)
      ++count[(d < lengths[i] ? (unsigned char)keys[i][d] : 0) + 1];
    for (i = 0; i < kRadix; ++i) count[i + 1] += count[i];
    for (i = 0; i < n; ++i) {
      j = count[d < lengths[i] ? (unsigned char)keys[i][d] : 0]++;
      aux_keys[j] = keys[i];
      aux_lengths[j] = lengths[i];
      aux_values[j] = values[i];
    }
    memcpy(keys, aux_keys, n * sizeof(char *));
    memcpy(lengths, aux_lengths, n * sizeof(size_t));
    memcpy(values, aux_values, n * sizeof(int));
  }
  free(aux_keys);
  free(aux_lengths);
  free(aux_values);
}
void Uint32ToBytes(const unsigned long num, unsigned char *array) {
  *array++ = num & 0xFF;
  *array++ = (num >> 8) & 0xFF;
  *array++ = (num >> 16) & 0xFF;
  *array = (num >> 24) & 0xFF;
}
size_t Utf8Len(const char *s) {
  size_t len = 0;
  for (; *s; ++s)
    if ((*s & 0xC0) != 0x80) ++len;
  return len;
}
const char *Utf8Index(const char *s, size_t pos) {
  ++pos;
  for (; *s; ++s) {
    if ((*s & 0xC0) != 0x80) --pos;
    if (pos == 0) return s;
  }
  return NULL;
}
void Utf8Slice(const char *const s, size_t *const start, size_t *const end) {
  const char *p = Utf8Index(s, *start);
  *start = p ? (size_t)(p - s) : (size_t)-1;
  p = Utf8Index(s, *end);
  *end = p ? (size_t)(p - s) : (size_t)-1;
}
unsigned long Utf8ToCodePoint(const char *const utf8) {
  unsigned long code_point = 0;
  if ((utf8[0] & 0x80) == 0) {
    code_point = utf8[0];
  } else if ((utf8[0] & 0xE0) == 0xC0) {
    code_point = (utf8[0] & 0x1F) << 6;
    code_point |= (utf8[1] & 0x3F);
  } else if ((utf8[0] & 0xF0) == 0xE0) {
    code_point = (utf8[0] & 0x0F) << 12;
    code_point |= (utf8[1] & 0x3F) << 6;
    code_point |= (utf8[2] & 0x3F);
  } else if ((utf8[0] & 0xF8) == 0xF0) {
    code_point = (utf8[0] & 0x07) << 18;
    code_point |= (utf8[1] & 0x3F) << 12;
    code_point |= (utf8[2] & 0x3F) << 6;
    code_point |= (utf8[3] & 0x3F);
  }
  return code_point;
}
/* Up to 5 bytes per character. */
size_t ToCustomEncoding(const char *const utf8_str, const size_t utf8_bytes,
                        char *const encoded_str) {
  char buffer[4];
  char *e = encoded_str;
  size_t i;
  const size_t len = Utf8Len(utf8_str);
  for (i = 0; i < len; ++i) {
    size_t start = i, end = i + 1;
    unsigned long u;
    Utf8Slice(utf8_str, &start, &end);
    if (end == (size_t)-1) end = utf8_bytes;
    memcpy(buffer, utf8_str + start, end - start);
    u = Utf8ToCodePoint(buffer);
    if (u < 0x80) {
      if (u == 0) {
        *e++ = (char)0xE0;
      } else {
        *e++ = (char)u;
      }
    } else if (u >= 0x4000 && u < 0xA000) {
      if ((u & 0xFF) == 0) {
        *e++ = (char)0xE1;
        *e++ = (char)((u >> 8) + 0x40);
      } else {
        *e++ = (char)((u >> 8) + 0x40);
        *e++ = (char)(u & 0xFF);
      }
    } else {
      int bits = 32, bytes_to_encode;
      while (bits > 0 && (u & 0xFE000000) == 0) {
        bits -= 7;
        u <<= 7;
      }
      bytes_to_encode = (bits + 6) / 7;
      *e++ = (char)(0xE0 | bytes_to_encode);
      while (bytes_to_encode > 0) {
        --bytes_to_encode;
        *e++ = (char)(((u >> 25) & 0x7F) | 0x80);
        u <<= 7;
      }
    }
  }
  *e = '\0';
  return e - encoded_str;
}
int main(void) {
  FILE *const file_in = SafeFOpen("bigram.dat", "rb");
  FILE *const file_out = SafeFOpen("zh-hans-t-huayu-bgw.gram", "wb");
  FILE *const file_out_text = SafeFOpen("bigram.txt", "wb");
  unsigned char buffer[4];
  unsigned long index_count, item_count, word_list_pos, index_pos, item_pos,
      arrays_used = 0, arrays_size = kInitialSize;
  char **keys;
  char **keys_ptr;
  size_t *lengths;
  int *values;
  darts_t gram_db;
  const char grammar_format[32] = "Rime::Grammar/1.0";
  int *double_array;
  size_t double_array_size;
  int *double_array_end;
  int *double_array_ptr;
  assert(sizeof(int) == 4);
  SafeFSeek(file_in, 36, SEEK_SET);
  SafeFRead(buffer, 4, 1, file_in);
  index_count = BytesToUint32(buffer);
  SafeFSeek(file_in, 52, SEEK_SET);
  SafeFRead(buffer, 4, 1, file_in);
  item_count = BytesToUint32(buffer);
  SafeFSeek(file_in, 60, SEEK_SET);
  SafeFRead(buffer, 4, 1, file_in);
  word_list_pos = BytesToUint32(buffer);
  SafeFSeek(file_in, 64, SEEK_SET);
  SafeFRead(buffer, 4, 1, file_in);
  index_pos = BytesToUint32(buffer);
  SafeFSeek(file_in, 72, SEEK_SET);
  SafeFRead(buffer, 4, 1, file_in);
  item_pos = BytesToUint32(buffer);
  SafeFSeek(file_in, index_pos, SEEK_SET);
  keys = (char **)SafeMAlloc(kInitialSize * sizeof(char *));
  lengths = (size_t *)SafeMAlloc(kInitialSize * sizeof(size_t));
  values = (int *)SafeMAlloc(kInitialSize * sizeof(int));
  while (index_count--) {
    char word[2 * kMaxWordLength + 1], word_u8[4 * kMaxWordLength + 1];
    unsigned long word_pos, item_index, next_item_index, start, i;
    long pos;
    size_t word_gbk_bytes, word_u8_bytes, encoded_key_bytes;
    SafeFRead(buffer, 4, 1, file_in);
    word_pos = BytesToUint32(buffer);
    pos = SafeFTell(file_in);
    SafeFSeek(file_in, word_list_pos + word_pos, SEEK_SET);
    word_gbk_bytes = ReadString(file_in, word, 2 * kMaxWordLength);
    word_u8_bytes =
        GbkToUtf8(word, word_gbk_bytes, word_u8, 4 * kMaxWordLength);
    if (!strcmp(word_u8, "△")) {
      SafeFSeek(file_in, pos + 12, SEEK_SET);
      continue;
    }
    SafeFSeek(file_in, pos + 4, SEEK_SET);
    SafeFRead(buffer, 4, 1, file_in);
    pos = SafeFTell(file_in);
    item_index = BytesToUint32(buffer);
    start = item_pos + 4 * item_index;
    SafeFSeek(file_in, 12, SEEK_CUR);
    SafeFRead(buffer, 4, 1, file_in);
    next_item_index = BytesToUint32(buffer);
    i = index_count ? next_item_index - item_index : item_count - item_index;
    SafeFSeek(file_in, start, SEEK_SET);
    while (i--) {
      char word_2[2 * kMaxWordLength + 1], word_2_u8[4 * kMaxWordLength + 1],
          u8_key[2 * 4 * kMaxWordLength + 1],
          encoded_key[2 * 5 * kMaxWordLength + 1];
      unsigned long word_index, next_word_index, word_2_pos, count;
      long pos_2;
      size_t word_2_gbk_bytes, word_2_u8_bytes;
      double prob;
      int ln_prob;
      SafeFRead(buffer, 4, 1, file_in);
      word_index = (buffer[2] & 3) << 16 | buffer[1] << 8 | buffer[0];
      count = buffer[3] << 6 | buffer[2] >> 2;
      if (i) {
        SafeFRead(buffer, 4, 1, file_in);
        next_word_index = (buffer[2] & 3) << 16 | buffer[1] << 8 | buffer[0];
        if (word_index == next_word_index) {
          count = (buffer[3] << 6 | buffer[2] >> 2) << 14 | count;
        } else {
          SafeFSeek(file_in, -4, SEEK_CUR);
        }
      }
      prob = log(count) * 10000;
      ln_prob = (int)(prob < 0 ? prob - 0.5 : prob + 0.5);
      pos_2 = SafeFTell(file_in);
      SafeFSeek(file_in, index_pos + 16 * word_index, SEEK_SET);
      SafeFRead(buffer, 4, 1, file_in);
      word_2_pos = BytesToUint32(buffer);
      SafeFSeek(file_in, word_list_pos + word_2_pos, SEEK_SET);
      word_2_gbk_bytes = ReadString(file_in, word_2, 2 * kMaxWordLength);
      word_2_u8_bytes =
          GbkToUtf8(word_2, word_2_gbk_bytes, word_2_u8, 4 * kMaxWordLength);
      if (!strcmp(word_2_u8, "△")) {
        strcpy(word_2_u8, "$");
        word_2_u8_bytes = 1;
      }
      SafeFSeek(file_in, pos_2, SEEK_SET);
      strcpy(u8_key, word_u8);
      strcpy(u8_key + word_u8_bytes, word_2_u8);
      SafeFPrintF(file_out_text, "%s,%d\n", u8_key, ln_prob);
      encoded_key_bytes = ToCustomEncoding(
          u8_key, word_u8_bytes + word_2_u8_bytes, encoded_key);
      if (arrays_used == arrays_size) {
        arrays_size = arrays_size + (arrays_size >> 1);
        keys = (char **)SafeRealloc(keys, arrays_size * sizeof(char *));
        lengths = (size_t *)SafeRealloc(lengths, arrays_size * sizeof(size_t));
        values = (int *)SafeRealloc(values, arrays_size * sizeof(int));
      }
      keys[arrays_used] = (char *)SafeMAlloc(encoded_key_bytes + 1);
      strcpy(keys[arrays_used], encoded_key);
      lengths[arrays_used] = encoded_key_bytes;
      values[arrays_used] = ln_prob;
      ++arrays_used;
    }
    SafeFSeek(file_in, pos + 4, SEEK_SET);
  }
  LsdSort(keys, lengths, values, arrays_used);
  gram_db = darts_new();
  if (darts_build(gram_db, arrays_used, (const char *const *)keys, lengths,
                  values, NULL)) {
    fputs(darts_error(gram_db), stderr);
    exit(EXIT_FAILURE);
  }
  SafeFWrite(grammar_format, 32, 1, file_out);
  memset(buffer, 0, sizeof(buffer));
  SafeFWrite(buffer, 4, 1, file_out);
  double_array_size = darts_size(gram_db);
  Uint32ToBytes(double_array_size, buffer);
  SafeFWrite(buffer, 4, 1, file_out);
  Uint32ToBytes(4, buffer);
  SafeFWrite(buffer, 4, 1, file_out);
  double_array = (int *)darts_array(gram_db);
  double_array_end = double_array + double_array_size;
  for (double_array_ptr = double_array; double_array_ptr < double_array_end;
       ++double_array_ptr) {
    Uint32ToBytes(*double_array_ptr, buffer);
    SafeFWrite(buffer, 4, 1, file_out);
  }
  darts_delete(gram_db);
  for (keys_ptr = keys; keys_ptr < keys + arrays_size; ++keys_ptr)
    free(*keys_ptr);
  free(keys);
  free(lengths);
  free(values);
  fclose(file_in);
  fclose(file_out);
  fclose(file_out_text);
  return 0;
}
