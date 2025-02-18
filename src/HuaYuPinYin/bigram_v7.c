#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "darts.h"
#include "wrappers.h"
enum { kInitialCapacity = 2, kTerminator = '$' };
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
  size_t bytes_capacity = kInitialCapacity;
  *bytes = (unsigned char *)SafeMAlloc(kInitialCapacity);
  *bytes_length = 0;
  for (; *string; string = end) {
    unsigned char byte;
    ++string;
    byte = strtol(string, &end, 10);
    if (*bytes_length == bytes_capacity) {
      bytes_capacity += bytes_capacity >> 1;
      *bytes = (unsigned char *)SafeRealloc(*bytes, bytes_capacity);
    }
    (*bytes)[(*bytes_length)++] = byte;
  }
}
size_t Utf8CharLength(unsigned short ucs_2_char) {
  return ucs_2_char < 0x80 ? 1 : ucs_2_char < 0x800 ? 2 : 3;
}
void WriteUtf8Char(char **utf_8, const unsigned short ucs_2_char) {
  if (ucs_2_char < 0x80) {
    *(*utf_8)++ = ucs_2_char;
  } else if (ucs_2_char < 0x800) {
    *(*utf_8)++ = 0xC0 | (ucs_2_char >> 6);
    *(*utf_8)++ = 0x80 | (ucs_2_char & 0x3F);
  } else {
    *(*utf_8)++ = 0xE0 | (ucs_2_char >> 12);
    *(*utf_8)++ = 0x80 | ((ucs_2_char >> 6) & 0x3F);
    *(*utf_8)++ = 0x80 | (ucs_2_char & 0x3F);
  }
}
void Ucs2LeToUtf8(const unsigned char *const ucs_2_le, size_t ucs_2_le_length,
                  char **utf_8, size_t *const utf_8_length) {
  static const unsigned char kTriangle[] = {0xB3, 0x25};
  size_t i;
  char *utf_8_ptr;
  if (ucs_2_le_length == sizeof(kTriangle) &&
      !memcmp(ucs_2_le, kTriangle, sizeof(kTriangle))) {
    *utf_8 = (char *)SafeMAlloc(2);
    (*utf_8)[0] = kTerminator;
    (*utf_8)[1] = '\0';
    *utf_8_length = 1;
    return;
  }
  *utf_8_length = 0;
  for (i = 0; i + 1 < ucs_2_le_length; i += 2) {
    unsigned short ucs_2_char = ucs_2_le[i] | (ucs_2_le[i + 1] << 8);
    if (ucs_2_char < 0x4E00 || ucs_2_char > 0x9FA5) {
      *utf_8 = NULL;
      *utf_8_length = 0;
      return;
    }
    *utf_8_length += Utf8CharLength(ucs_2_char);
  }
  *utf_8 = (char *)SafeMAlloc(*utf_8_length + 1);
  utf_8_ptr = *utf_8;
  for (i = 0; i + 1 < ucs_2_le_length; i += 2) {
    unsigned short ucs_2_char = ucs_2_le[i] | (ucs_2_le[i + 1] << 8);
    WriteUtf8Char(&utf_8_ptr, ucs_2_char);
  }
  *utf_8_ptr = '\0';
}
void ReadWords(FILE *const word_to_index, char **words, size_t *word_lengths) {
  int character;
  while ((character = SafeFGetC(word_to_index)) != EOF) {
    char *word = (char *)SafeMAlloc(kInitialCapacity);
    size_t word_length = 0;
    size_t word_capacity = kInitialCapacity;
    unsigned char buffer[4];
    unsigned long id;
    unsigned char *bytes;
    size_t bytes_length;
    size_t utf_8_length;
    char *utf_8;
    SafeUngetC(character, word_to_index);
    while ((character = SafeFGetC(word_to_index))) {
      if (word_length == word_capacity) {
        word_capacity += word_capacity >> 1;
        word = (char *)SafeRealloc(word, word_capacity);
      }
      word[word_length++] = character;
    }
    if (word_length == word_capacity) {
      word_capacity += word_capacity >> 1;
      word = (char *)SafeRealloc(word, word_capacity);
    }
    word[word_length] = '\0';
    StringToBytes(word, &bytes, &bytes_length);
    free(word);
    Ucs2LeToUtf8(bytes, bytes_length, &utf_8, &utf_8_length);
    free(bytes);
    SafeFRead(buffer, 4, 1, word_to_index);
    id = BytesToUInt32(buffer);
    words[id] = utf_8;
    word_lengths[id] = utf_8_length;
    SafeFSeek(word_to_index, 8, SEEK_CUR);
  }
}
size_t Utf8Length(const char *s) {
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
unsigned long Utf8ToCodePoint(const char *const utf_8) {
  unsigned long code_point = 0;
  if (!(utf_8[0] & 0x80)) {
    code_point = utf_8[0];
  } else if ((utf_8[0] & 0xE0) == 0xC0) {
    code_point = (utf_8[0] & 0x1F) << 6;
    code_point |= (utf_8[1] & 0x3F);
  } else if ((utf_8[0] & 0xF0) == 0xE0) {
    code_point = (utf_8[0] & 0x0F) << 12;
    code_point |= (utf_8[1] & 0x3F) << 6;
    code_point |= (utf_8[2] & 0x3F);
  } else if ((utf_8[0] & 0xF8) == 0xF0) {
    code_point = (utf_8[0] & 0x07) << 18;
    code_point |= (utf_8[1] & 0x3F) << 12;
    code_point |= (utf_8[2] & 0x3F) << 6;
    code_point |= (utf_8[3] & 0x3F);
  }
  return code_point;
}
void ToCustomEncoding(const char *const utf_8, char **encoded,
                      size_t *const encoded_length) {
  const size_t length = Utf8Length(utf_8);
  char *e;
  size_t i;
  *encoded_length = 0;
  for (i = 0; i < length; ++i) {
    size_t start = i;
    size_t end = i + 1;
    unsigned long u;
    Utf8Slice(utf_8, &start, &end);
    u = Utf8ToCodePoint(utf_8 + start);
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
    size_t start = i;
    size_t end = i + 1;
    unsigned long u;
    Utf8Slice(utf_8, &start, &end);
    u = Utf8ToCodePoint(utf_8 + start);
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
                  const size_t length) {
  enum { kRadix = 256 };
  size_t i;
  size_t j;
  size_t max_length;
  size_t d;
  char **aux_keys;
  size_t *aux_lengths;
  long *aux_values;
  if (!length) {
    return;
  }
  aux_keys = (char **)SafeMAlloc(length * sizeof(char *));
  aux_lengths = (size_t *)SafeMAlloc(length * sizeof(size_t));
  aux_values = (long *)SafeMAlloc(length * sizeof(long));
  max_length = lengths[0];
  for (i = 1; i < length; ++i) {
    if (lengths[i] > max_length) {
      max_length = lengths[i];
    }
  }
  for (d = max_length; d--;) {
    size_t count[kRadix + 1] = {0};
    for (i = 0; i < length; ++i) {
      ++count[(d < lengths[i] ? (unsigned char)keys[i][d] : 0) + 1];
    }
    for (i = 0; i < kRadix; ++i) {
      count[i + 1] += count[i];
    }
    for (i = 0; i < length; ++i) {
      j = count[d < lengths[i] ? (unsigned char)keys[i][d] : 0]++;
      aux_keys[j] = keys[i];
      aux_lengths[j] = lengths[i];
      aux_values[j] = values[i];
    }
    memcpy(keys, aux_keys, length * sizeof(char *));
    memcpy(lengths, aux_lengths, length * sizeof(size_t));
    memcpy(values, aux_values, length * sizeof(long));
  }
  free(aux_keys);
  free(aux_lengths);
  free(aux_values);
}
int main(void) {
  static const char kGrammarFormat[32] = "Rime::Grammar/1.0";
  FILE *const word_to_index = SafeFOpen("word2index.dat", "rb");
  FILE *const trans_matrix = SafeFOpen("transmatrix.dat", "rb");
  FILE *const output_file = SafeFOpen("bigrams.txt", "wb");
  FILE *const grammar_db = SafeFOpen("zh-hans-t-huayu-v7-bgw.gram", "wb");
  unsigned char buffer[4];
  unsigned long id_count;
  unsigned long length;
  unsigned long indexes_start;
  unsigned long ids_start;
  unsigned long id;
  unsigned long index_offset;
  long frequencies_offset;
  long frequencies_backward_offset;
  char **words;
  char **words_ptr;
  char **words_end;
  size_t *word_lengths;
  size_t *word_lengths_ptr;
  char **bigrams;
  char **bigrams_ptr;
  char **bigrams_end;
  size_t *bigram_lengths;
  long *frequencies;
  size_t bigrams_length = 0;
  size_t bigrams_capacity = kInitialCapacity;
  darts_t double_array;
  long *trie;
  long *trie_ptr;
  long *trie_end;
  size_t trie_length;
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
  indexes_start = 28 + length * 4;
  frequencies_offset = (length + id_count) * 4;
  ids_start = 28 + frequencies_offset;
  frequencies_backward_offset = -frequencies_offset - 4;
  bigrams = (char **)SafeMAlloc(kInitialCapacity * sizeof(char *));
  bigram_lengths = (size_t *)SafeMAlloc(kInitialCapacity * sizeof(size_t));
  frequencies = (long *)SafeMAlloc(kInitialCapacity * sizeof(long));
  for (words_ptr = words, word_lengths_ptr = word_lengths, id = 0,
      index_offset = indexes_start;
       words_ptr < words_end;
       ++words_ptr, ++word_lengths_ptr, ++id, index_offset += 4) {
    unsigned long start;
    unsigned long end;
    unsigned long i;
    if (!*words_ptr) {
      continue;
    }
    SafeFSeek(trans_matrix, index_offset, SEEK_SET);
    SafeFRead(buffer, 4, 1, trans_matrix);
    start = BytesToUInt32(buffer);
    if (id == id_count - 1) {
      end = length;
    } else {
      SafeFRead(buffer, 4, 1, trans_matrix);
      end = BytesToUInt32(buffer);
    }
    SafeFSeek(trans_matrix, ids_start + start * 4, SEEK_SET);
    for (i = start; i < end; ++i) {
      char *word_1;
      char *word_2;
      char *bigram;
      char *encoded;
      size_t word_1_length;
      size_t word_2_length;
      size_t bigram_length;
      size_t encoded_length;
      unsigned long word_1_id;
      unsigned long frequency;
      double ln_frequency;
      word_2 = *words_ptr;
      SafeFRead(buffer, 4, 1, trans_matrix);
      word_1_id = BytesToUInt32(buffer);
      word_1 = words[word_1_id];
      word_1_length = word_lengths[word_1_id];
      if (!word_1 || (word_1_length == 1 && *word_1 == kTerminator)) {
        continue;
      }
      SafeFSeek(trans_matrix, frequencies_backward_offset, SEEK_CUR);
      SafeFRead(buffer, 4, 1, trans_matrix);
      frequency = BytesToUInt32(buffer);
      word_2_length = *word_lengths_ptr;
      SafeFPrintF(output_file, "%.*s\t%.*s\t%lu\n", word_1_length, word_1,
                  word_2_length, word_2, frequency);
      /* ln(frequency) - ln(10) */
      ln_frequency = log(frequency) - 2.3025850929940457;
      if ((word_2_length == 1 && *word_2 == kTerminator) ||
          (Utf8Length(word_1) == 1 && Utf8Length(word_2) == 1)) {
        /* ln((sqrt(5) - 1) / 2) */
        ln_frequency -= 0.48121182505960345;
      }
      SafeFSeek(trans_matrix, frequencies_offset, SEEK_CUR);
      bigram_length = word_1_length + word_2_length;
      bigram = (char *)SafeMAlloc(bigram_length + 1);
      memcpy(bigram, word_1, word_1_length);
      memcpy(bigram + word_1_length, word_2, word_2_length + 1);
      ToCustomEncoding(bigram, &encoded, &encoded_length);
      free(bigram);
      if (bigrams_length == bigrams_capacity) {
        bigrams_capacity += bigrams_capacity >> 1;
        bigrams =
            (char **)SafeRealloc(bigrams, bigrams_capacity * sizeof(char *));
        bigram_lengths = (size_t *)SafeRealloc(
            bigram_lengths, bigrams_capacity * sizeof(size_t));
        frequencies =
            (long *)SafeRealloc(frequencies, bigrams_capacity * sizeof(long));
      }
      bigrams[bigrams_length] = encoded;
      bigram_lengths[bigrams_length] = encoded_length;
      /* Round half away from zero */
      frequencies[bigrams_length] = ln_frequency * 10000.0 + 0.5;
      ++bigrams_length;
    }
  }
  for (words_ptr = words; words_ptr < words_end; ++words_ptr) {
    free(*words_ptr);
  }
  free(words);
  free(word_lengths);
  fclose(trans_matrix);
  fclose(output_file);
  LsdRadixSort(bigrams, bigram_lengths, frequencies, bigrams_length);
  double_array = darts_new();
  if (darts_build(double_array, bigrams_length, (const char *const *)bigrams,
                  bigram_lengths, frequencies, NULL)) {
    SafeFPutS(darts_error(double_array), stderr);
    exit(EXIT_FAILURE);
  }
  bigrams_end = bigrams + bigrams_length;
  for (bigrams_ptr = bigrams; bigrams_ptr < bigrams_end; ++bigrams_ptr) {
    free(*bigrams_ptr);
  }
  free(bigrams);
  free(bigram_lengths);
  free(frequencies);
  SafeFWrite(kGrammarFormat, 32, 1, grammar_db);
  memset(buffer, 0, sizeof(buffer));
  SafeFWrite(buffer, 4, 1, grammar_db);
  trie_length = darts_size(double_array);
  UInt32ToBytes(trie_length, buffer);
  SafeFWrite(buffer, 4, 1, grammar_db);
  UInt32ToBytes(4, buffer);
  SafeFWrite(buffer, 4, 1, grammar_db);
  trie = (long *)darts_array(double_array);
  trie_end = trie + trie_length;
  for (trie_ptr = trie; trie_ptr < trie_end; ++trie_ptr) {
    UInt32ToBytes(*trie_ptr, buffer);
    SafeFWrite(buffer, 4, 1, grammar_db);
  }
  darts_delete(double_array);
  fclose(grammar_db);
  return 0;
}
