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
  int_t full_dim = 3, solution_dim = 1, basis_dim = 2;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  int_t skip_dim = 1, subset_dim = 1;
  complex_t vectors_1[] = {I, 0.0, 0.0}, vectors_2[3];
  error = ckrylov_set_complex_space_subset_vectors(index, full_dim, skip_dim,
                                                   subset_dim, vectors_1);
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_get_complex_space_subset_vectors(index, full_dim, skip_dim,
                                                   subset_dim, vectors_2);
  CHECK(error == CKRYLOV_OK);
  CHECK(near_complex(vectors_1, vectors_2, full_dim * subset_dim));

  index = 2;
  error = ckrylov_set_complex_space_subset_vectors(index, full_dim, skip_dim,
                                                   subset_dim, vectors_1);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_get_complex_space_subset_vectors(index, full_dim, skip_dim,
                                                   subset_dim, vectors_2);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
