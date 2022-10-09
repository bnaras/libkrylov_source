#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error;
  real_t value;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t key1[] = "real";
  error = ckrylov_set_real_option(key1, strlen(key1), 1.0);
  CHECK(error == CKRYLOV_OK);

  value = ckrylov_get_real_option(key1, strlen(key1));
  CHECK(value == 1);

  char_t key2[] = "missing";
  value = ckrylov_get_real_option(key2, strlen(key2));
  CHECK(value == -REAL_HUGE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
