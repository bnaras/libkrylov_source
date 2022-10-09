#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
         equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 3, solution_dim = 1, basis_dim = 1;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  real_t vectors_1[] = {-1.0, 1.0, -2.0};
  error = ckrylov_set_real_space_vectors(index, full_dim, basis_dim, vectors_1);
  CHECK(error == CKRYLOV_OK);

  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 2);

  real_t vectors_2[] = {3.0, -1.0, 0.0};
  error = ckrylov_set_real_space_vectors(index, full_dim, basis_dim, vectors_2);
  CHECK(error == CKRYLOV_OK);

  int_t full_dims[] = {3, 3}, subset_dims[] = {1, 1}, offsets[] = {0, 3},
        num_spaces = 2, total_size = 6;
  real_t vectors[6], vectors_ref[] = {-1.0, 1.0, -2.0, 3.0, -1.0, 0.0};
  error = ckrylov_get_real_block_vectors(num_spaces, total_size, full_dims,
                                         subset_dims, offsets, vectors);
  CHECK(error == CKRYLOV_OK);
  CHECK(near_real(vectors, vectors_ref, total_size));

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
