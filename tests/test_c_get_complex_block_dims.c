#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_COMPLEX_KIND,
         structure[] = CKRYLOV_HERMITIAN_STRUCTURE,
         equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 10, solution_dim = 2, basis_dim = 3;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 2);

  int_t full_dims[2], subset_dims[2], offsets[2], total_size;

  total_size = ckrylov_get_complex_block_total_size();
  CHECK(total_size == 60);

  error = ckrylov_get_complex_block_dims(2, full_dims, subset_dims, offsets);
  CHECK(error == CKRYLOV_OK);
  CHECK(offsets[0] == 0);
  CHECK(offsets[1] == 30);
  CHECK(full_dims[0] == 10);
  CHECK(full_dims[1] == 10);
  CHECK(subset_dims[0] == 3);
  CHECK(subset_dims[1] == 3);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
