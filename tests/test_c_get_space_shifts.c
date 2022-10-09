#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
         equation[] = CKRYLOV_SHIFTED_LINEAR_EQUATION;
  int_t full_dim = 10, solution_dim = 2, basis_dim = 2;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  real_t shifts_1[] = {1.0, 1.0}, shifts_2[2];
  error = ckrylov_set_space_shifts(index, solution_dim, shifts_1);
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_get_space_shifts(index, solution_dim, shifts_2);
  CHECK(error == CKRYLOV_OK);
  CHECK(near_real(shifts_1, shifts_2, solution_dim));

  index = 2;
  error = ckrylov_set_space_shifts(index, solution_dim, shifts_1);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_get_space_shifts(index, solution_dim, shifts_2);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
