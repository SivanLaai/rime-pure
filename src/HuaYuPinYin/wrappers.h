#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
void *SafeMAlloc(size_t size) {
  void *result = malloc(size);
  if (result == NULL) {
    perror("malloc");
    exit(EXIT_FAILURE);
  }
  return result;
}
void *SafeCAlloc(size_t num, size_t size) {
  void *result = calloc(num, size);
  if (result == NULL) {
    perror("calloc");
    exit(EXIT_FAILURE);
  }
  return result;
}
void *SafeRealloc(void *ptr, size_t new_size) {
  void *result = realloc(ptr, new_size);
  if (result == NULL) {
    perror("realloc");
    exit(EXIT_FAILURE);
  }
  return result;
}
FILE *SafeFOpen(const char *filename, const char *mode) {
  FILE *file = fopen(filename, mode);
  if (file == NULL) {
    perror("fopen");
    exit(EXIT_FAILURE);
  }
  return file;
}
int SafeFGetC(FILE *stream) {
  int c = fgetc(stream);
  if (ferror(stream)) {
    perror("fgetc");
    exit(EXIT_FAILURE);
  }
  return c;
}
int SafeFPutC(int c, FILE *stream) {
  if (fputc(c, stream) == EOF) {
    perror("fputc");
    exit(EXIT_FAILURE);
  }
  return c;
}
char *SafeFGetS(char *str, int count, FILE *stream) {
  char *result = fgets(str, count, stream);
  if (result == NULL && ferror(stream)) {
    perror("fgets");
    exit(EXIT_FAILURE);
  }
  return result;
}
int SafeFPutS(const char *str, FILE *stream) {
  if (fputs(str, stream) == EOF) {
    perror("fputs");
    exit(EXIT_FAILURE);
  }
  return 0;
}
int SafeFPrintF(FILE *stream, const char *format, ...) {
  va_list args;
  int result;
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
  size_t elements_read = fread(ptr, size, nmemb, stream);
  if (elements_read != nmemb) {
    perror("fread");
    exit(EXIT_FAILURE);
  }
  return elements_read;
}
size_t SafeFWrite(const void *ptr, size_t size, size_t nmemb, FILE *stream) {
  size_t elements_written = fwrite(ptr, size, nmemb, stream);
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
  long pos = ftell(stream);
  if (pos == -1) {
    perror("ftell");
    exit(EXIT_FAILURE);
  }
  return pos;
}
