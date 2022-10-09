#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index;
  real_t value;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
         equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 100, solution_dim = 2, basis_dim = 3;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  char_t key1[] = "integer";
  error = ckrylov_set_space_real_option(index, key1, strlen(key1), 1.0);
  CHECK(error == CKRYLOV_OK);

  value = ckrylov_get_space_real_option(index, key1, strlen(key1));
  CHECK(value == 1.0);

  char_t key2[] = "missing";
  value = ckrylov_get_space_real_option(index, key2, strlen(key2));
  CHECK(value == -REAL_HUGE);

  index = 2;
  value = ckrylov_get_space_real_option(index, key1, strlen(key1));
  CHECK(value == -REAL_HUGE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
