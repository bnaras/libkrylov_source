#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
         equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 5, solution_dim = 1, basis_dim = 1;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  real_t vectors_1[] = {1.0, 0.0, 0.0, 0.0, 0.0}, vectors_2[5];
  error = ckrylov_set_real_space_vectors(index, full_dim, basis_dim, vectors_1);
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_get_real_space_vectors(index, full_dim, basis_dim, vectors_2);
  CHECK(error == CKRYLOV_OK);
  CHECK(near_real(vectors_1, vectors_2, full_dim * basis_dim));

  index = 2;
  error = ckrylov_set_real_space_vectors(index, full_dim, basis_dim, vectors_1);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_get_real_space_vectors(index, full_dim, basis_dim, vectors_2);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
