#include <assert.h>
#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int_t real_block_multiply(const int_t *num_spaces, const int_t *total_size,
                          const int_t *full_dims, const int_t *subset_dims,
                          const int_t *offsets, const real_t *vectors,
                          real_t *products) {
  assert(*num_spaces == 2);
  assert(*total_size == 4);

  real_t matrix_1[] = {0.0, 1.0, 1.0, 0.0};
  real_t matrix_2[] = {1.0, 1.0, 1.0, 1.0};

  for (int_t i = 0; i < *total_size; ++i) {
    products[i] = 0.0;
  }

  int_t offset_1 = offsets[0], subset_dim_1 = subset_dims[0],
        full_dim_1 = full_dims[0];
  for (int_t i = 0; i < subset_dim_1; ++i) {
    for (int_t j = 0; j < full_dim_1; ++j) {
      for (int_t k = 0; k < full_dim_1; ++k) {
        products[k + subset_dim_1 * i + offset_1] +=
            matrix_1[k + full_dim_1 * j] *
            vectors[j + full_dim_1 * i + offset_1];
      }
    }
  }

  int_t offset_2 = offsets[1], subset_dim_2 = subset_dims[1],
        full_dim_2 = full_dims[1];
  for (int_t i = 0; i < subset_dim_2; ++i) {
    for (int_t j = 0; j < full_dim_2; ++j) {
      for (int_t k = 0; k < full_dim_2; ++k) {
        products[k + subset_dim_2 * i + offset_2] +=
            matrix_2[k + full_dim_2 * j] *
            vectors[j + full_dim_2 * i + offset_2];
      }
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

  char_t kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
         equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 2, solution_dim = 1, basis_dim = 1;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  real_t vectors_1[] = {1.0, 0.0};
  error = ckrylov_set_real_space_vectors(index, full_dim, basis_dim, vectors_1);
  CHECK(error == CKRYLOV_OK);

  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 2);

  real_t vectors_2[] = {1.0, 0.0};
  error = ckrylov_set_real_space_vectors(index, full_dim, basis_dim, vectors_2);
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_solve_real_block_equation(real_block_multiply);
  CHECK(error == CKRYLOV_OK);

  real_t eigenvalues_1[1], eigenvalues_ref_1[] = {-1.0};
  error = ckrylov_get_space_eigenvalues(1, solution_dim, eigenvalues_1);
  CHECK(near_real(eigenvalues_1, eigenvalues_ref_1, solution_dim));

  real_t solutions_1[2], solutions_ref_1[] = {sqrt(0.5), -sqrt(0.5)};
  error =
      ckrylov_get_real_space_solutions(1, full_dim, solution_dim, solutions_1);
  CHECK(near_real_with_phase(solutions_1, solutions_ref_1,
                             full_dim * solution_dim, true));

  real_t eigenvalues_2[1], eigenvalues_ref_2[] = {0.0};
  error = ckrylov_get_space_eigenvalues(2, solution_dim, eigenvalues_2);
  CHECK(near_real(eigenvalues_2, eigenvalues_ref_2, solution_dim));

  real_t solutions_2[2], solutions_ref_2[] = {sqrt(0.5), -sqrt(0.5)};
  error =
      ckrylov_get_real_space_solutions(2, full_dim, solution_dim, solutions_2);
  CHECK(near_real_with_phase(solutions_2, solutions_ref_2,
                             full_dim * solution_dim, true));

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
