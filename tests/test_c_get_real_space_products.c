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

  real_t products[5], products_ref[] = {0.0, 0.0, 0.0, 0.0, 0.0};
  error = ckrylov_get_real_space_products(index, full_dim, basis_dim, products);
  CHECK(error == CKRYLOV_OK);
  CHECK(near_real(products, products_ref, full_dim * basis_dim));

  index = 2;
  error = ckrylov_get_real_space_products(index, full_dim, basis_dim, products);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
