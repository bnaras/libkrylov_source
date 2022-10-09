#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, value_len = 256, length;
  char_t value[value_len];

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t key1[] = "string";
  char_t value1[] = "a";
  error = ckrylov_set_string_option(key1, strlen(key1), value1, strlen(value1));
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_get_string_option(key1, strlen(key1), value, value_len);
  CHECK(error == CKRYLOV_OK);
  CHECK(strncmp(value, value1, strlen(value1)) == 0);

  length = ckrylov_length_string_option(key1, strlen(key1));
  CHECK(length == 1);

  char_t key2[] = "missing";
  error = ckrylov_get_string_option(key2, strlen(key2), value, value_len);
  CHECK(error == CKRYLOV_NO_SUCH_OPTION);

  length = ckrylov_length_string_option(key2, strlen(key2));
  CHECK(length == CKRYLOV_NO_SUCH_OPTION);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
