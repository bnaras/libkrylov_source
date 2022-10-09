#include <assert.h>
#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int_t complex_multiply(const int_t *full_dim, const int_t *subset_dim, const complex_t *vectors,
                       complex_t *products) {
  assert(*full_dim == 4);
  assert(*subset_dim == 1);

  complex_t matrix[] = {5.0, 4.0, 1.0, 1.0, 4.0, 5.0, 1.0, 1.0,
                        1.0, 1.0, 4.0, 2.0, 1.0, 1.0, 2.0, 4.0};
  for (int_t i = 0; i < *full_dim * *subset_dim; ++i) {
    products[i] = 0.0;
  }

  for (int_t i = 0; i < *full_dim; ++i) {
    for (int_t j = 0; j < *full_dim; ++j) {
      products[j] += matrix[j + *full_dim * i] * vectors[i];
    }
  }

  return CKRYLOV_OK;
}

int main() {
  int_t error, index;

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t key1[] = "preconditioner", value1[] = "n";
  error = ckrylov_set_enum_option(key1, strlen(key1), value1, strlen(value1));
  CHECK(error == CKRYLOV_OK);

  char_t key2[] = "orthonormalizer", value2[] = "o";
  error = ckrylov_set_enum_option(key2, strlen(key2), value2, strlen(value2));
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_COMPLEX_KIND, structure[] = CKRYLOV_HERMITIAN_STRUCTURE, equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 4, solution_dim = 1, basis_dim = 1;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  complex_t vectors[] = {1.0, 0.0, 0.0, 0.0};
  error =
      ckrylov_set_complex_space_vectors(index, full_dim, basis_dim, vectors);
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_solve_complex_equation(index, complex_multiply);
  CHECK(error == CKRYLOV_OK);

  real_t eigenvalues[1], eigenvalues_ref[] = {1.0};
  error = ckrylov_get_space_eigenvalues(index, solution_dim, eigenvalues);
  CHECK(error == CKRYLOV_OK);
  CHECK(near_real(eigenvalues, eigenvalues_ref, solution_dim));

  complex_t solutions[4], solutions_ref[] = {sqrt(0.5), -sqrt(0.5), 0.0, 0.0};
  error = ckrylov_get_complex_space_solutions(index, full_dim, solution_dim,
                                              solutions);
  CHECK(error == CKRYLOV_OK);
  CHECK(near_complex_with_phase(solutions, solutions_ref,
                                full_dim * solution_dim, true));

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
