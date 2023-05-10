/* 先把“固顶字.ini”转成 UTF-8 编码并重命名为“fixed.ini”再运行本程序！ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "wrappers.h"
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
int main(void) {
  char line[64];
  FILE *const file_in = SafeFOpen("fixed.ini", "rb");
  FILE *const file_out = SafeFOpen("custom_phrase.txt", "wb");
  while (SafeFGetS(line, sizeof(line), file_in)) {
    const char *pinyin, *characters;
    size_t len, i;
    line[strcspn(line, "\r\n")] = '\0';
    if (line[0] == '\0' || line[0] == '#') continue;
    pinyin = strtok(line, "=");
    characters = strtok(NULL, "=");
    if (characters == NULL) continue;
    len = Utf8Len(characters);
    for (i = 0; i < len; ++i) {
      size_t start = i, end = i + 1;
      Utf8Slice(characters, &start, &end);
      SafeFPrintF(file_out, "%.*s\t%s\t%lu\n", (int)(end - start),
                  characters + start, pinyin, (unsigned long)(len - i));
    }
  }
  fclose(file_in);
  fclose(file_out);
  return 0;
}
