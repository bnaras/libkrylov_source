#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index, length;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
         equation[] = CKRYLOV_SYLVESTER_EQUATIION;
  int_t full_dim = 100, solution_dim = 2, basis_dim = 3;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  length = ckrylov_get_space_sylvester_b_size(index);
  CHECK(length == 4);

  index = 2;
  length = ckrylov_get_space_sylvester_b_size(index);
  CHECK(length == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
