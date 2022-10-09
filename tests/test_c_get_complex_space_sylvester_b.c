#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_COMPLEX_KIND,
         structure[] = CKRYLOV_HERMITIAN_STRUCTURE,
         equation[] = CKRYLOV_SYLVESTER_EQUATIION;
  int_t full_dim = 5, solution_dim = 2, basis_dim = 3;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  complex_t sylvester_b_1[] = {I, I, I, I}, sylvester_b_2[4];
  error =
      ckrylov_set_complex_space_sylvester_b(index, solution_dim, sylvester_b_1);
  CHECK(error == CKRYLOV_OK);

  error =
      ckrylov_get_complex_space_sylvester_b(index, solution_dim, sylvester_b_2);
  CHECK(error == CKRYLOV_OK);
  CHECK(
      near_complex(sylvester_b_1, sylvester_b_2, solution_dim * solution_dim));

  index = 2;
  error =
      ckrylov_set_complex_space_sylvester_b(index, solution_dim, sylvester_b_1);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error =
      ckrylov_get_complex_space_sylvester_b(index, solution_dim, sylvester_b_2);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
