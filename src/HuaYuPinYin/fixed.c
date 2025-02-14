/* 先把“固顶字.ini”转成 UTF-8 编码并重命名为“fixed.ini”再运行本程序！ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "wrappers.h"
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
void GetLine(char **line, size_t *const line_length, FILE *const file) {
  enum { kInitialCapacity = 2 };
  size_t size = kInitialCapacity;
  *line = (char *)SafeMAlloc(kInitialCapacity);
  *line_length = 0;
  while (1) {
    int c;
    c = SafeFGetC(file);
    if (c == '\n' || c == EOF) {
      break;
    }
    if (c == '\r') {
      c = SafeFGetC(file);
      if (c != '\n') {
        SafeUngetC(c, file);
      }
      break;
    }
    if (*line_length == size) {
      size += size >> 1;
      *line = (char *)SafeRealloc(*line, size);
    }
    (*line)[(*line_length)++] = c;
  }
  if (*line_length == size) {
    size += size >> 1;
    *line = (char *)SafeRealloc(*line, size);
  }
  (*line)[*line_length] = '\0';
}
int main(void) {
  FILE *const file_in = SafeFOpen("fixed.ini", "rb");
  FILE *const file_out = SafeFOpen("custom_phrase.txt", "wb");
  char *line;
  size_t line_length;
  while (GetLine(&line, &line_length, file_in), line_length || !feof(file_in)) {
    const char *pinyin;
    const char *characters;
    size_t characters_length;
    size_t i;
    if (line[0] == '\0' || line[0] == '#') {
      free(line);
      continue;
    }
    pinyin = strtok(line, "=");
    characters = strtok(NULL, "=");
    if (!characters) {
      free(line);
      continue;
    }
    characters_length = Utf8Length(characters);
    for (i = 0; i < characters_length; ++i) {
      size_t start = i;
      size_t end = i + 1;
      Utf8Slice(characters, &start, &end);
      SafeFPrintF(file_out, "%.*s\t%s\t%lu\n", (int)(end - start),
                  characters + start, pinyin,
                  (unsigned long)(characters_length - i));
    }
    free(line);
  }
  free(line);
  fclose(file_in);
  fclose(file_out);
  return 0;
}
