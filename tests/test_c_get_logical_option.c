#include <stdbool.h>
#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error;
  bool_t value;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t key1[] = "logical";
  error = ckrylov_set_logical_option(key1, strlen(key1), true);
  CHECK(error == CKRYLOV_OK);

  value = ckrylov_get_logical_option(key1, strlen(key1));
  CHECK(value);

  char_t key2[] = "missing";
  value = ckrylov_get_logical_option(key2, strlen(key2));
  CHECK(!value);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
