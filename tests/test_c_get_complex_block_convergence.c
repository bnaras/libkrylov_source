#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index, status;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_COMPLEX_KIND,
         structure[] = CKRYLOV_HERMITIAN_STRUCTURE,
         equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 3, solution_dim = 1, basis_dim = 1;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 2);

  status = ckrylov_get_complex_block_convergence();
  CHECK(status == CKRYLOV_NOT_CONVERGED);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
