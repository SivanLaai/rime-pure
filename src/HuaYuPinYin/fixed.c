/* 先把“固顶字.ini”转成 UTF-8 编码并重命名为“fixed.ini”再运行本程序！ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
size_t utf8len(const char *s) {
  size_t len = 0;
  for (; *s; ++s)
    if ((*s & 0xC0) != 0x80) ++len;
  return len;
}
const char *utf8index(const char *s, size_t pos) {
  ++pos;
  for (; *s; ++s) {
    if ((*s & 0xC0) != 0x80) --pos;
    if (pos == 0) return s;
  }
  return NULL;
}
void utf8slice(const char *const s, size_t *const start, size_t *const end) {
  const char *p = utf8index(s, *start);
  *start = p ? p - s : SIZE_MAX;
  p = utf8index(s, *end);
  *end = p ? p - s : SIZE_MAX;
}
int main() {
  char line[128];
  FILE *const f_in = fopen("fixed.ini", "rb");
  FILE *const f_out = fopen("custom_phrase.txt", "wb");
  while (fgets(line, sizeof(line), f_in)) {
    line[strcspn(line, "\r\n")] = '\0';
    if (line[0] == '\0' || line[0] == '#') continue;
    const char *const pinyin = strtok(line, "=");
    const char *const characters = strtok(NULL, "=");
    if (characters == NULL) continue;
    const size_t len = utf8len(characters);
    size_t i;
    for (i = 0; i < len; ++i) {
      size_t start = i, end = i + 1;
      utf8slice(characters, &start, &end);
      fprintf(f_out, "%.*s\t%s\t%lu\n", (int)(end - start), characters + start,
              pinyin, (unsigned long)(len - i));
    }
  }
  fclose(f_in);
  fclose(f_out);
  return 0;
}
