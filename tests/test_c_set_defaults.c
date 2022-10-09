#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, value1, value_len = 256;
  char_t value[value_len];

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t key1[] = "preconditioner";
  error = ckrylov_get_enum_option(key1, strlen(key1), value, value_len);
  CHECK(error == CKRYLOV_OK);
  CHECK(strncmp(value, "n", 1) == 0);

  char_t key2[] = "orthonormalizer";
  error = ckrylov_get_enum_option(key2, strlen(key2), value, value_len);
  CHECK(error == CKRYLOV_OK);
  CHECK(strncmp(value, "o", 1) == 0);

  char_t key3[] = "max_iterations";
  value1 = ckrylov_get_integer_option(key3, strlen(key3));
  CHECK(value1 == 50);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
