#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, value;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t key1[] = "integer";
  error = ckrylov_set_integer_option(key1, strlen(key1), 1);
  CHECK(error == CKRYLOV_OK);

  value = ckrylov_get_integer_option(key1, strlen(key1));
  CHECK(value == 1);

  char_t key2[] = "missing";
  value = ckrylov_get_integer_option(key2, strlen(key2));
  CHECK(value == CKRYLOV_NO_SUCH_OPTION);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
