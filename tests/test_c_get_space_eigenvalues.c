#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
         equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 100, solution_dim = 2, basis_dim = 3;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  real_t eigenvalues[2], eigenvalues_ref[] = {0.0, 0.0};
  error = ckrylov_get_space_eigenvalues(index, solution_dim, eigenvalues);
  CHECK(error == CKRYLOV_OK);
  CHECK(near_real(eigenvalues, eigenvalues_ref, solution_dim));

  index = 2;
  error = ckrylov_get_space_eigenvalues(index, solution_dim, eigenvalues);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
