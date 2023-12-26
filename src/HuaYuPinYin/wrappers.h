#ifndef WRAPPERS_H_
#define WRAPPERS_H_
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
int SafePrintF(const char *format, ...) {
  int result;
  va_list args;
  va_start(args, format);
  result = vfprintf(stdout, format, args);
  va_end(args);
  if (result < 0) {
    perror("printf");
    exit(EXIT_FAILURE);
  }
  return result;
}
void *SafeMAlloc(size_t size) {
  const void *const result = malloc(size);
  if (result == NULL) {
    perror("malloc");
    exit(EXIT_FAILURE);
  }
  return (void *)result;
}
void *SafeCAlloc(size_t num, size_t size) {
  const void *const result = calloc(num, size);
  if (result == NULL) {
    perror("calloc");
    exit(EXIT_FAILURE);
  }
  return (void *)result;
}
void *SafeRealloc(void *ptr, size_t new_size) {
  const void *const result = realloc(ptr, new_size);
  if (result == NULL) {
    perror("realloc");
    exit(EXIT_FAILURE);
  }
  return (void *)result;
}
FILE *SafeFOpen(const char *filename, const char *mode) {
  const FILE *const file = fopen(filename, mode);
  if (file == NULL) {
    perror("fopen");
    exit(EXIT_FAILURE);
  }
  return (FILE *)file;
}
int SafeFGetC(FILE *stream) {
  const int c = fgetc(stream);
  if (ferror(stream)) {
    perror("fgetc");
    exit(EXIT_FAILURE);
  }
  return c;
}
int SafeUngetC(int c, FILE *stream) {
  const int result = ungetc(c, stream);
  if (result == EOF) {
    perror("ungetc");
    exit(EXIT_FAILURE);
  }
  return result;
}
int SafeFPutC(int c, FILE *stream) {
  if (fputc(c, stream) == EOF) {
    perror("fputc");
    exit(EXIT_FAILURE);
  }
  return c;
}
char *SafeFGetS(char *str, int count, FILE *stream) {
  const char *const result = fgets(str, count, stream);
  if (result == NULL && ferror(stream)) {
    perror("fgets");
    exit(EXIT_FAILURE);
  }
  return (char *)result;
}
int SafeFPutS(const char *str, FILE *stream) {
  if (fputs(str, stream) == EOF) {
    perror("fputs");
    exit(EXIT_FAILURE);
  }
  return 0;
}
int SafeFPrintF(FILE *stream, const char *format, ...) {
  int result;
  va_list args;
  va_start(args, format);
  result = vfprintf(stream, format, args);
  va_end(args);
  if (result < 0) {
    perror("fprintf");
    exit(EXIT_FAILURE);
  }
  return result;
}
size_t SafeFRead(void *ptr, size_t size, size_t nmemb, FILE *stream) {
  const size_t elements_read = fread(ptr, size, nmemb, stream);
  if (elements_read != nmemb) {
    perror("fread");
    exit(EXIT_FAILURE);
  }
  return elements_read;
}
size_t SafeFWrite(const void *ptr, size_t size, size_t nmemb, FILE *stream) {
  const size_t elements_written = fwrite(ptr, size, nmemb, stream);
  if (elements_written != nmemb) {
    perror("fwrite");
    exit(EXIT_FAILURE);
  }
  return elements_written;
}
int SafeFSeek(FILE *stream, long offset, int whence) {
  if (fseek(stream, offset, whence)) {
    perror("fseek");
    exit(EXIT_FAILURE);
  }
  return 0;
}
long SafeFTell(FILE *stream) {
  const long pos = ftell(stream);
  if (pos == -1) {
    perror("ftell");
    exit(EXIT_FAILURE);
  }
  return pos;
}
#endif
