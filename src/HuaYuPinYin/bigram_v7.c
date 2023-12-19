#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "bcd.h"
#include "darts.h"
#include "wrappers.h"
enum { kInitialSize = 2, kRadix = 256 };
static const Bcd kE = {{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02},
                       {0x71, 0x82, 0x81, 0x82, 0x84, 0x59, 0x05}};
static const Bcd kTenThousandLnTen = {
    {0x00, 0x00, 0x00, 0x00, 0x02, 0x30, 0x25},
    {0x85, 0x09, 0x29, 0x94, 0x04, 0x56, 0x84}};
static const Bcd kTenThousandLnGoldenRatio = {
    {0x00, 0x00, 0x00, 0x00, 0x00, 0x48, 0x12},
    {0x11, 0x82, 0x50, 0x59, 0x60, 0x34, 0x47}};
unsigned long BytesToUInt32(const unsigned char *const array) {
  return array[3] << 24 | array[2] << 16 | array[1] << 8 | array[0];
}
void UInt32ToBytes(const unsigned long num, unsigned char *array) {
  *array++ = num & 0xFF;
  *array++ = (num >> 8) & 0xFF;
  *array++ = (num >> 16) & 0xFF;
  *array = (num >> 24) & 0xFF;
}
void StringToBytes(const char *string, unsigned char **bytes,
                   size_t *bytes_length) {
  char *end;
  unsigned char byte;
  size_t bytes_used = 0, bytes_size = kInitialSize;
  *bytes = (unsigned char *)SafeMAlloc(kInitialSize);
  for (; *string; string = end) {
    ++string;
    byte = strtol(string, &end, 10);
    if (bytes_used == bytes_size) {
      bytes_size += bytes_size >> 1;
      *bytes = (unsigned char *)SafeRealloc(*bytes, bytes_size);
    }
    (*bytes)[bytes_used++] = byte;
  }
  *bytes_length = bytes_used;
}
size_t Utf8CharSize(unsigned short ucs2_char) {
  return ucs2_char < 0x80 ? 1 : ucs2_char < 0x800 ? 2 : 3;
}
void WriteUtf8Char(char **utf8, const unsigned short ucs2_char) {
  if (ucs2_char < 0x80) {
    *(*utf8)++ = ucs2_char;
  } else if (ucs2_char < 0x800) {
    *(*utf8)++ = 0xC0 | (ucs2_char >> 6);
    *(*utf8)++ = 0x80 | (ucs2_char & 0x3F);
  } else {
    *(*utf8)++ = 0xE0 | (ucs2_char >> 12);
    *(*utf8)++ = 0x80 | ((ucs2_char >> 6) & 0x3F);
    *(*utf8)++ = 0x80 | (ucs2_char & 0x3F);
  }
}
void Ucs2LeToUtf8(const unsigned char *const ucs_2le, size_t ucs_2le_length,
                  char **utf8, size_t *const utf8_length) {
  const unsigned char triangle[] = {0xB3, 0x25};
  const size_t triangle_length = sizeof(triangle);
  size_t i;
  char *utf8_ptr;
  if (ucs_2le_length == triangle_length &&
      !memcmp(ucs_2le, triangle, triangle_length)) {
    *utf8 = (char *)SafeMAlloc(sizeof("$"));
    memcpy(*utf8, "$", sizeof("$"));
    *utf8_length = 1;
    return;
  }
  *utf8_length = 0;
  for (i = 0; i + 1 < ucs_2le_length; i += 2) {
    unsigned short ucs2_char = ucs_2le[i] | (ucs_2le[i + 1] << 8);
    if (ucs2_char < 0x4E00 || ucs2_char > 0x9FA5) {
      *utf8 = NULL;
      *utf8_length = 0;
      return;
    }
    *utf8_length += Utf8CharSize(ucs2_char);
  }
  *utf8 = (char *)SafeMAlloc(*utf8_length + 1);
  utf8_ptr = *utf8;
  for (i = 0; i + 1 < ucs_2le_length; i += 2) {
    unsigned short ucs2_char = ucs_2le[i] | (ucs_2le[i + 1] << 8);
    WriteUtf8Char(&utf8_ptr, ucs2_char);
  }
  *utf8_ptr = '\0';
}
void ReadWords(FILE *const word_to_index, char **words, size_t *word_lengths) {
  int character;
  while ((character = SafeFGetC(word_to_index)) != EOF) {
    char *word = (char *)SafeMAlloc(kInitialSize);
    size_t word_used = 0, word_size = kInitialSize;
    unsigned char buffer[4];
    unsigned long id;
    unsigned char *bytes;
    size_t bytes_length, utf8_length;
    char *utf8;
    SafeUngetC(character, word_to_index);
    while ((character = SafeFGetC(word_to_index))) {
      if (word_used == word_size) {
        word_size += word_size >> 1;
        word = (char *)SafeRealloc(word, word_size);
      }
      word[word_used++] = character;
    }
    if (word_used == word_size) {
      word_size += word_size >> 1;
      word = (char *)SafeRealloc(word, word_size);
    }
    word[word_used] = '\0';
    StringToBytes(word, &bytes, &bytes_length);
    free(word);
    Ucs2LeToUtf8(bytes, bytes_length, &utf8, &utf8_length);
    free(bytes);
    SafeFRead(buffer, 4, 1, word_to_index);
    id = BytesToUInt32(buffer);
    words[id] = utf8;
    word_lengths[id] = utf8_length;
    SafeFSeek(word_to_index, 8, SEEK_CUR);
  }
}
size_t Utf8Len(const char *s) {
  size_t len = 0;
  for (; *s; ++s) {
    if ((*s & 0xC0) != 0x80) {
      ++len;
    }
  }
  return len;
}
const char *Utf8Index(const char *s, size_t pos) {
  ++pos;
  for (; *s; ++s) {
    if ((*s & 0xC0) != 0x80) {
      --pos;
    }
    if (!pos) {
      return s;
    }
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
  if (!(utf8[0] & 0x80)) {
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
void ToCustomEncoding(const char *const utf8, char **encoded,
                      size_t *const encoded_length) {
  const size_t length = Utf8Len(utf8);
  char *e;
  size_t i;
  *encoded_length = 0;
  for (i = 0; i < length; ++i) {
    size_t start = i, end = i + 1;
    unsigned long u;
    Utf8Slice(utf8, &start, &end);
    u = Utf8ToCodePoint(utf8 + start);
    if ((u >= 0x80 && u < 0x4000) || u >= 0xA000) {
      *encoded = NULL;
      *encoded_length = 0;
      return;
    }
    *encoded_length += u < 0x80 ? 1 : 2;
  }
  *encoded = (char *)SafeMAlloc(*encoded_length + 1);
  e = *encoded;
  for (i = 0; i < length; ++i) {
    size_t start = i, end = i + 1;
    unsigned long u;
    Utf8Slice(utf8, &start, &end);
    u = Utf8ToCodePoint(utf8 + start);
    if (u < 0x80) {
      if (!u) {
        *e++ = (char)0xE0;
      } else {
        *e++ = (char)u;
      }
    } else {
      if (!(u & 0xFF)) {
        *e++ = (char)0xE1;
        *e++ = (char)((u >> 8) + 0x40);
      } else {
        *e++ = (char)((u >> 8) + 0x40);
        *e++ = (char)(u & 0xFF);
      }
    }
  }
  *e = '\0';
}
void LsdRadixSort(char **const keys, size_t *const lengths, long *const values,
                  const size_t n) {
  size_t i, j, max_length, d;
  size_t count[kRadix + 1];
  char **aux_keys;
  size_t *aux_lengths;
  long *aux_values;
  if (!n) {
    return;
  }
  aux_keys = (char **)SafeMAlloc(n * sizeof(char *));
  aux_lengths = (size_t *)SafeMAlloc(n * sizeof(size_t));
  aux_values = (long *)SafeMAlloc(n * sizeof(long));
  max_length = lengths[0];
  for (i = 1; i < n; ++i) {
    if (lengths[i] > max_length) {
      max_length = lengths[i];
    }
  }
  for (d = max_length; d--;) {
    memset(count, 0, sizeof(count));
    for (i = 0; i < n; ++i) {
      ++count[(d < lengths[i] ? (unsigned char)keys[i][d] : 0) + 1];
    }
    for (i = 0; i < kRadix; ++i) {
      count[i + 1] += count[i];
    }
    for (i = 0; i < n; ++i) {
      j = count[d < lengths[i] ? (unsigned char)keys[i][d] : 0]++;
      aux_keys[j] = keys[i];
      aux_lengths[j] = lengths[i];
      aux_values[j] = values[i];
    }
    memcpy(keys, aux_keys, n * sizeof(char *));
    memcpy(lengths, aux_lengths, n * sizeof(size_t));
    memcpy(values, aux_values, n * sizeof(long));
  }
  free(aux_keys);
  free(aux_lengths);
  free(aux_values);
}
int main(void) {
  FILE *const word_to_index = SafeFOpen("word2index.dat", "rb");
  FILE *const trans_matrix = SafeFOpen("transmatrix.dat", "rb");
  FILE *const output_file = SafeFOpen("bigrams.txt", "wb");
  FILE *const grammar_db = SafeFOpen("zh-hans-t-huayu-v7-bgw.gram", "wb");
  unsigned char buffer[4];
  unsigned long id_count, length, indexes_first, ids_first, id, index_offset;
  long frequencies_offset, frequencies_backward_offset;
  char **words;
  char **words_ptr;
  char **words_end;
  size_t *word_lengths;
  size_t *word_lengths_ptr;
  long *frequencies;
  char **bigrams;
  char **bigrams_ptr;
  char **bigrams_end;
  size_t *bigram_lengths;
  size_t arrays_used = 0, arrays_size = kInitialSize;
  darts_t double_array;
  long *trie;
  long *trie_ptr;
  long *trie_end;
  size_t trie_size;
  const char grammar_format[32] = "Rime::Grammar/1.0";
  SafeFSeek(trans_matrix, 24, SEEK_SET);
  SafeFRead(buffer, 4, 1, trans_matrix);
  id_count = BytesToUInt32(buffer);
  words = (char **)SafeCAlloc(id_count, sizeof(char *));
  words_end = words + id_count;
  word_lengths = (size_t *)SafeCAlloc(id_count, sizeof(size_t));
  ReadWords(word_to_index, words, word_lengths);
  fclose(word_to_index);
  SafeFSeek(trans_matrix, 16, SEEK_SET);
  SafeFRead(buffer, 4, 1, trans_matrix);
  length = BytesToUInt32(buffer);
  indexes_first = 28 + length * 4;
  frequencies_offset = (length + id_count) * 4;
  ids_first = 28 + frequencies_offset;
  frequencies_backward_offset = -frequencies_offset - 4;
  bigrams = (char **)SafeMAlloc(kInitialSize * sizeof(char *));
  bigram_lengths = (size_t *)SafeMAlloc(kInitialSize * sizeof(size_t));
  frequencies = (long *)SafeMAlloc(kInitialSize * sizeof(long));
  for (words_ptr = words, word_lengths_ptr = word_lengths, id = 0,
      index_offset = indexes_first;
       words_ptr < words_end;
       ++words_ptr, ++word_lengths_ptr, ++id, index_offset += 4) {
    unsigned long start, stop, i;
    if (!*words_ptr) {
      continue;
    }
    SafeFSeek(trans_matrix, index_offset, SEEK_SET);
    SafeFRead(buffer, 4, 1, trans_matrix);
    start = BytesToUInt32(buffer);
    if (id == id_count - 1) {
      stop = length;
    } else {
      SafeFRead(buffer, 4, 1, trans_matrix);
      stop = BytesToUInt32(buffer);
    }
    SafeFSeek(trans_matrix, ids_first + start * 4, SEEK_SET);
    for (i = start; i < stop; ++i) {
      char *word_1;
      char *word_2;
      char *bigram;
      char *encoded;
      size_t word_1_length, word_2_length, bigram_length, encoded_length;
      unsigned long word_1_id, frequency;
      Bcd log_frequency;
      unsigned char j = 4;
      word_2 = *words_ptr;
      SafeFRead(buffer, 4, 1, trans_matrix);
      word_1_id = BytesToUInt32(buffer);
      word_1 = words[word_1_id];
      word_1_length = word_lengths[word_1_id];
      if (!word_1 || (word_1_length == 1 && *word_1 == '$')) {
        continue;
      }
      SafeFSeek(trans_matrix, frequencies_backward_offset, SEEK_CUR);
      SafeFRead(buffer, 4, 1, trans_matrix);
      frequency = BytesToUInt32(buffer);
      word_2_length = *word_lengths_ptr;
      log_frequency = BcdLog(BcdFromInteger(frequency), kE);
      while (j--) {
        log_frequency = BcdShiftLeft(log_frequency);
      }
      log_frequency = BcdSubtract(log_frequency, kTenThousandLnTen);
      if ((word_2_length == 1 && *word_2 == '$') ||
          (Utf8Len(word_1) == 1 && Utf8Len(word_2) == 1)) {
        log_frequency = BcdSubtract(log_frequency, kTenThousandLnGoldenRatio);
      }
      SafeFSeek(trans_matrix, frequencies_offset, SEEK_CUR);
      bigram_length = word_1_length + word_2_length;
      bigram = (char *)SafeMAlloc(bigram_length + 1);
      memcpy(bigram, word_1, word_1_length);
      memcpy(bigram + word_1_length, word_2, word_2_length + 1);
      SafeFWrite(bigram, bigram_length, 1, output_file);
      SafeFPrintF(output_file, "\t%u\n", frequency);
      ToCustomEncoding(bigram, &encoded, &encoded_length);
      free(bigram);
      if (arrays_used == arrays_size) {
        arrays_size = arrays_size + (arrays_size >> 1);
        bigrams = (char **)SafeRealloc(bigrams, arrays_size * sizeof(char *));
        bigram_lengths =
            (size_t *)SafeRealloc(bigram_lengths, arrays_size * sizeof(size_t));
        frequencies =
            (long *)SafeRealloc(frequencies, arrays_size * sizeof(long));
      }
      bigrams[arrays_used] = encoded;
      bigram_lengths[arrays_used] = encoded_length;
      frequencies[arrays_used] = BcdToInteger(log_frequency);
      ++arrays_used;
    }
  }
  for (words_ptr = words; words_ptr < words_end; ++words_ptr) {
    free(*words_ptr);
  }
  free(words);
  free(word_lengths);
  fclose(trans_matrix);
  fclose(output_file);
  bigrams_end = bigrams + arrays_used;
  LsdRadixSort(bigrams, bigram_lengths, frequencies, arrays_used);
  double_array = darts_new();
  if (darts_build(double_array, arrays_used, (const char *const *)bigrams,
                  bigram_lengths, frequencies, NULL)) {
    SafeFPutS(darts_error(double_array), stderr);
    exit(EXIT_FAILURE);
  }
  for (bigrams_ptr = bigrams; bigrams_ptr < bigrams_end; ++bigrams_ptr) {
    free(*bigrams_ptr);
  }
  free(bigrams);
  free(bigram_lengths);
  free(frequencies);
  SafeFWrite(grammar_format, 32, 1, grammar_db);
  memset(buffer, 0, sizeof(buffer));
  SafeFWrite(buffer, 4, 1, grammar_db);
  trie_size = darts_size(double_array);
  UInt32ToBytes(trie_size, buffer);
  SafeFWrite(buffer, 4, 1, grammar_db);
  UInt32ToBytes(4, buffer);
  SafeFWrite(buffer, 4, 1, grammar_db);
  trie = (long *)darts_array(double_array);
  trie_end = trie + trie_size;
  for (trie_ptr = trie; trie_ptr < trie_end; ++trie_ptr) {
    UInt32ToBytes(*trie_ptr, buffer);
    SafeFWrite(buffer, 4, 1, grammar_db);
  }
  darts_delete(double_array);
  fclose(grammar_db);
  return 0;
}
