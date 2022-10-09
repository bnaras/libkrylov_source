#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index, length;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_COMPLEX_KIND, structure[] = CKRYLOV_HERMITIAN_STRUCTURE, equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 100, solution_dim = 1, basis_dim = 2;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  error = ckrylov_resize_complex_space_vectors(index, 4);
  CHECK(error == CKRYLOV_OK);

  length = ckrylov_get_space_vector_size(index);
  CHECK(length == 400);

  index = 2;
  error = ckrylov_resize_complex_space_vectors(index, 2);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
