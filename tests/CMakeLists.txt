link_libraries(krylov)
include_directories(${libkrylov_BINARY_DIR}/src)
link_libraries(${BLAS_LIBRARIES} ${LAPACK_LIBRARIES})

# Module tests
add_executable(test_kinds test_kinds.f90)
add_test(NAME test_kinds COMMAND test_kinds)

add_executable(test_dict test_dict.f90)
add_test(NAME test_dict COMMAND test_dict)

add_executable(test_options test_options.f90)
add_test(NAME test_options COMMAND test_options)

add_executable(test_utils test_utils.f90)
add_test(NAME test_utils COMMAND test_utils)

add_executable(test_lapackwrapper test_lapackwrapper.f90)
add_test(NAME test_lapackwrapper COMMAND test_lapackwrapper)

add_executable(test_testing test_testing.f90)
add_test(NAME test_testing COMMAND test_testing)

# Linalg module tests
add_executable(test_real_ge_subset test_real_ge_subset.f90)
add_test(NAME test_real_ge_subset COMMAND test_real_ge_subset)

add_executable(test_complex_ge_subset test_complex_ge_subset.f90)
add_test(NAME test_complex_ge_subset COMMAND test_complex_ge_subset)

add_executable(test_real_ge_block_orthonormalize
               test_real_ge_block_orthonormalize.f90)
add_test(NAME test_real_ge_block_orthnormalize
         COMMAND test_real_ge_block_orthonormalize)

add_executable(test_complex_ge_block_orthonormalize
               test_complex_ge_block_orthonormalize.f90)
add_test(NAME test_complex_ge_block_orthonormalize
         COMMAND test_complex_ge_block_orthonormalize)

add_executable(test_real_ge_orthogonalize test_real_ge_orthogonalize.f90)
add_test(NAME test_real_ge_orthogonalize COMMAND test_real_ge_orthogonalize)

add_executable(test_complex_ge_orthogonalize test_complex_ge_orthogonalize.f90)
add_test(NAME test_complex_ge_orthogonalize
         COMMAND test_complex_ge_orthogonalize)

add_executable(test_real_sy_eigenvalues test_real_sy_eigenvalues.f90)
add_test(NAME test_real_sy_eigenvalues COMMAND test_real_sy_eigenvalues)

add_executable(test_complex_he_eigenvalues test_complex_he_eigenvalues.f90)
add_test(NAME test_complex_he_eigenvalues COMMAND test_complex_he_eigenvalues)

add_executable(test_real_sy_diagonalize test_real_sy_diagonalize.f90)
add_test(NAME test_real_sy_diagonalize COMMAND test_real_sy_diagonalize)

add_executable(test_complex_he_diagonalize test_complex_he_diagonalize.f90)
add_test(NAME test_complex_he_diagonalize COMMAND test_complex_he_diagonalize)

add_executable(test_real_sy_diag_scale test_real_sy_diag_scale.f90)
add_test(NAME test_real_sy_diag_scale COMMAND test_real_sy_diag_scale)

add_executable(test_complex_he_diag_scale test_complex_he_diag_scale.f90)
add_test(NAME test_complex_he_diag_scale COMMAND test_complex_he_diag_scale)

add_executable(test_real_sy_solve_linear test_real_sy_solve_linear.f90)
add_test(NAME test_real_sy_solve_linear COMMAND test_real_sy_solve_linear)

add_executable(test_complex_he_solve_linear test_complex_he_solve_linear.f90)
add_test(NAME test_complex_he_solve_linear COMMAND test_complex_he_solve_linear)

add_executable(test_real_ge_frobenius_norm test_real_ge_frobenius_norm.f90)
add_test(NAME test_real_ge_frobenius_norm COMMAND test_real_ge_frobenius_norm)

add_executable(test_complex_ge_frobenius_norm
               test_complex_ge_frobenius_norm.f90)
add_test(NAME test_complex_ge_frobenius_norm
         COMMAND test_complex_ge_frobenius_norm)

add_executable(test_real_sy_frobenius_norm test_real_sy_frobenius_norm.f90)
add_test(NAME test_real_sy_frobenius_norm COMMAND test_real_sy_frobenius_norm)

add_executable(test_complex_he_frobenius_norm
               test_complex_he_frobenius_norm.f90)
add_test(NAME test_complex_he_frobenius_norm
         COMMAND test_complex_he_frobenius_norm)

add_executable(test_real_sy_spectral_norm test_real_sy_spectral_norm.f90)
add_test(NAME test_real_sy_spectral_norm COMMAND test_real_sy_spectral_norm)

add_executable(test_complex_he_spectral_norm test_complex_he_spectral_norm.f90)
add_test(NAME test_complex_he_spectral_norm
         COMMAND test_complex_he_spectral_norm)

add_executable(test_real_sy_one_norm test_real_sy_one_norm.f90)
add_test(NAME test_real_sy_one_norm COMMAND test_real_sy_one_norm)

add_executable(test_complex_he_one_norm test_complex_he_one_norm.f90)
add_test(NAME test_complex_he_one_norm COMMAND test_complex_he_one_norm)

add_executable(test_real_sy_rcond_spectral_norm
               test_real_sy_rcond_spectral_norm.f90)
add_test(NAME test_real_sy_rcond_spectral_norm
         COMMAND test_real_sy_rcond_spectral_norm)

add_executable(test_complex_he_rcond_spectral_norm
               test_complex_he_rcond_spectral_norm.f90)
add_test(NAME test_complex_he_rcond_spectral_norm
         COMMAND test_complex_he_rcond_spectral_norm)

add_executable(test_real_sy_rcond_one_norm test_real_sy_rcond_one_norm.f90)
add_test(NAME test_real_sy_rcond_one_norm COMMAND test_real_sy_rcond_one_norm)

add_executable(test_complex_he_rcond_one_norm
               test_complex_he_rcond_one_norm.f90)
add_test(NAME test_complex_he_rcond_one_norm
         COMMAND test_complex_he_rcond_one_norm)

# Global function tests
add_executable(test_add_space test_add_space.f90)
add_test(NAME test_add_space COMMAND test_add_space)

add_executable(test_set_defaults test_set_defaults.f90)
add_test(NAME test_set_defaults COMMAND test_set_defaults)

add_executable(test_get_integer_option test_get_integer_option.f90)
add_test(NAME test_get_integer_option COMMAND test_get_integer_option)

add_executable(test_get_string_option test_get_string_option.f90)
add_test(NAME test_get_string_option COMMAND test_get_string_option)

add_executable(test_get_real_option test_get_real_option.f90)
add_test(NAME test_get_real_option COMMAND test_get_real_option)

add_executable(test_get_logical_option test_get_logical_option.f90)
add_test(NAME test_get_logical_option COMMAND test_get_logical_option)

add_executable(test_get_enum_option test_get_enum_option.f90)
add_test(NAME test_get_enum_option COMMAND test_get_enum_option)

add_executable(test_get_real_block_dims test_get_real_block_dims.f90)
add_test(NAME test_get_real_block_dims COMMAND test_get_real_block_dims)

add_executable(test_get_real_block_vectors test_get_real_block_vectors.f90)
add_test(NAME test_get_real_block_vectors COMMAND test_get_real_block_vectors)

add_executable(test_set_real_block_products test_set_real_block_products.f90)
add_test(NAME test_set_real_block_products COMMAND test_set_real_block_products)

add_executable(test_get_real_block_convergence
               test_get_real_block_convergence.f90)
add_test(NAME test_get_real_block_convergence
         COMMAND test_get_real_block_convergence)

add_executable(test_solve_real_block_equation
               test_solve_real_block_equation.f90)
add_test(NAME test_solve_real_block_equation
         COMMAND test_solve_real_block_equation)

add_executable(test_get_complex_block_dims test_get_complex_block_dims.f90)
add_test(NAME test_get_complex_block_dims COMMAND test_get_complex_block_dims)

add_executable(test_get_complex_block_vectors test_get_complex_block_vectors.f90)
add_test(NAME test_get_complex_block_vectors COMMAND test_get_complex_block_vectors)

add_executable(test_set_complex_block_products test_set_complex_block_products.f90)
add_test(NAME test_set_complex_block_products COMMAND test_set_complex_block_products)

add_executable(test_get_complex_block_convergence
               test_get_complex_block_convergence.f90)
add_test(NAME test_get_complex_block_convergence
         COMMAND test_get_complex_block_convergence)

add_executable(test_solve_complex_block_equation
               test_solve_complex_block_equation.f90)
add_test(NAME test_solve_complex_block_equation
         COMMAND test_solve_complex_block_equation)

# cmake-format: off

# TODO
# add_executable(test_solve_complex_block_equation test_solve_complex_block_equation.f90)
# add_test(NAME test_solve_complex_block_equation COMMAND test_solve_complex_block_equation)

# cmake-format: on

# Global space-specific function tests (using space index)
add_executable(test_get_space_integer_option test_get_space_integer_option.f90)
add_test(NAME test_get_space_integer_option
         COMMAND test_get_space_integer_option)

add_executable(test_get_space_string_option test_get_space_string_option.f90)
add_test(NAME test_get_space_string_option COMMAND test_get_space_string_option)

add_executable(test_get_space_real_option test_get_space_real_option.f90)
add_test(NAME test_get_space_real_option COMMAND test_get_space_real_option)

add_executable(test_get_space_logical_option test_get_space_logical_option.f90)
add_test(NAME test_get_space_logical_option
         COMMAND test_get_space_logical_option)

add_executable(test_get_space_enum_option test_get_space_enum_option.f90)
add_test(NAME test_get_space_enum_option COMMAND test_get_space_enum_option)

add_executable(test_get_space_kind test_get_space_kind.f90)
add_test(NAME test_get_space_kind COMMAND test_get_space_kind)

add_executable(test_get_space_structure test_get_space_structure.f90)
add_test(NAME test_get_space_structure COMMAND test_get_space_structure)

add_executable(test_get_space_equation test_get_space_equation.f90)
add_test(NAME test_get_space_equation COMMAND test_get_space_equation)

add_executable(test_get_space_preconditioner test_get_space_preconditioner.f90)
add_test(NAME test_get_space_preconditioner
         COMMAND test_get_space_preconditioner)

add_executable(test_get_space_orthonormalizer
               test_get_space_orthonormalizer.f90)
add_test(NAME test_get_space_orthonormalizer
         COMMAND test_get_space_orthonormalizer)

add_executable(test_get_space_full_dim test_get_space_full_dim.f90)
add_test(NAME test_get_space_full_dim COMMAND test_get_space_full_dim)

add_executable(test_get_space_solution_dim test_get_space_solution_dim.f90)
add_test(NAME test_get_space_solution_dim COMMAND test_get_space_solution_dim)

add_executable(test_get_space_basis_dim test_get_space_basis_dim.f90)
add_test(NAME test_get_space_basis_dim COMMAND test_get_space_basis_dim)

add_executable(test_get_space_vector_size test_get_space_vector_size.f90)
add_test(NAME test_get_space_vector_size COMMAND test_get_space_vector_size)

add_executable(test_get_space_solution_size test_get_space_solution_size.f90)
add_test(NAME test_get_space_solution_size COMMAND test_get_space_solution_size)

add_executable(test_get_space_eigenvalue_size
               test_get_space_eigenvalue_size.f90)
add_test(NAME test_get_space_eigenvalue_size
         COMMAND test_get_space_eigenvalue_size)

add_executable(test_get_space_rhs_size test_get_space_rhs_size.f90)
add_test(NAME test_get_space_rhs_size COMMAND test_get_space_rhs_size)

add_executable(test_get_space_sylvester_b_size
               test_get_space_sylvester_b_size.f90)
add_test(NAME test_get_space_sylvester_b_size
         COMMAND test_get_space_sylvester_b_size)

add_executable(test_get_space_eigenvalues test_get_space_eigenvalues.f90)
add_test(NAME test_get_space_eigenvalues COMMAND test_get_space_eigenvalues)

add_executable(test_get_space_convergence test_get_space_convergence.f90)
add_test(NAME test_get_space_convergence COMMAND test_get_space_convergence)

add_executable(test_get_real_space_vectors test_get_real_space_vectors.f90)
add_test(NAME test_get_real_space_vectors COMMAND test_get_real_space_vectors)

add_executable(test_set_real_space_vectors_from_diagonal
               test_set_real_space_vectors_from_diagonal.f90)
add_test(NAME test_set_real_space_vectors_from_diagonal
         COMMAND test_set_real_space_vectors_from_diagonal)

add_executable(test_resize_real_space_vectors
               test_resize_real_space_vectors.f90)
add_test(NAME test_resize_real_space_vectors
         COMMAND test_resize_real_space_vectors)

add_executable(test_get_real_space_products test_get_real_space_products.f90)
add_test(NAME test_get_real_space_products COMMAND test_get_real_space_products)

add_executable(test_get_real_space_solutions test_get_real_space_solutions.f90)
add_test(NAME test_get_real_space_solutions
         COMMAND test_get_real_space_solutions)

add_executable(test_resize_real_space_solutions
               test_resize_real_space_solutions.f90)
add_test(NAME test_resize_real_space_solutions
         COMMAND test_resize_real_space_solutions)

add_executable(test_get_real_space_rhs test_get_real_space_rhs.f90)
add_test(NAME test_get_real_space_rhs COMMAND test_get_real_space_rhs)

add_executable(test_get_real_space_sylvester_b
               test_get_real_space_sylvester_b.f90)
add_test(NAME test_get_real_space_sylvester_b
         COMMAND test_get_real_space_sylvester_b)

add_executable(test_get_complex_space_vectors
               test_get_complex_space_vectors.f90)
add_test(NAME test_get_complex_space_vectors
         COMMAND test_get_complex_space_vectors)

add_executable(test_resize_complex_space_vectors
               test_resize_complex_space_vectors.f90)
add_test(NAME test_resize_complex_space_vectors
         COMMAND test_resize_complex_space_vectors)

add_executable(test_set_complex_space_vectors_from_diagonal
         test_set_complex_space_vectors_from_diagonal.f90)
add_test(NAME test_set_complex_space_vectors_from_diagonal
   COMMAND test_set_complex_space_vectors_from_diagonal)

add_executable(test_get_complex_space_products
               test_get_complex_space_products.f90)
add_test(NAME test_get_complex_space_products
         COMMAND test_get_complex_space_products)

add_executable(test_get_complex_space_solutions
               test_get_complex_space_solutions.f90)
add_test(NAME test_get_complex_space_solutions
         COMMAND test_get_complex_space_solutions)

add_executable(test_resize_complex_space_solutions
               test_resize_complex_space_solutions.f90)
add_test(NAME test_resize_complex_space_solutions
         COMMAND test_resize_complex_space_solutions)

add_executable(test_get_complex_space_rhs test_get_complex_space_rhs.f90)
add_test(NAME test_get_complex_space_rhs COMMAND test_get_complex_space_rhs)

add_executable(test_get_complex_space_sylvester_b
               test_get_complex_space_sylvester_b.f90)
add_test(NAME test_get_complex_space_sylvester_b
         COMMAND test_get_complex_space_sylvester_b)

add_executable(test_get_real_space_subset_vectors
               test_get_real_space_subset_vectors.f90)
add_test(NAME test_get_real_space_subset_vectors
         COMMAND test_get_real_space_subset_vectors)

add_executable(test_get_real_space_subset_products
               test_get_real_space_subset_products.f90)
add_test(NAME test_get_real_space_subset_products
         COMMAND test_get_real_space_subset_products)

add_executable(test_set_space_diagonal test_set_space_diagonal.f90)
add_test(NAME test_set_space_diagonal COMMAND test_set_space_diagonal)

add_executable(test_solve_real_equation test_solve_real_equation.f90)
add_test(NAME test_solve_real_equation COMMAND test_solve_real_equation)

add_executable(test_solve_complex_equation test_solve_complex_equation.f90)
add_test(NAME test_solve_complex_equation COMMAND test_solve_complex_equation)

# convergence_t tests
add_executable(test_convergence_get_convergence
               test_convergence_get_convergence.f90)
add_test(NAME test_convergence_get_convergence
         COMMAND test_convergence_get_convergence)

add_executable(test_convergence_get_solution_convergence
               test_convergence_get_solution_convergence.f90)
add_test(NAME test_convergence_get_solution_convergence
         COMMAND test_convergence_get_solution_convergence)

add_executable(test_convergence_get_active test_convergence_get_active.f90)
add_test(NAME test_convergence_get_active COMMAND test_convergence_get_active)

# real_space_t tests
add_executable(test_real_space_prepare_orthonormalizer
               test_real_space_prepare_orthonormalizer.f90)
add_test(NAME test_real_space_prepare_orthonormalizer
         COMMAND test_real_space_prepare_orthonormalizer)

add_executable(test_real_space_expand_equation
               test_real_space_expand_equation.f90)
add_test(NAME test_real_space_expand_equation
         COMMAND test_real_space_expand_equation)

add_executable(test_real_space_solve_projected
               test_real_space_solve_projected.f90)
add_test(NAME test_real_space_solve_projected
         COMMAND test_real_space_solve_projected)

add_executable(test_real_space_make_residuals
               test_real_space_make_residuals.f90)
add_test(NAME test_real_space_make_residuals
         COMMAND test_real_space_make_residuals)

add_executable(test_real_space_transform_solutions
               test_real_space_transform_solutions.f90)
add_test(NAME test_real_space_transform_solutions
         COMMAND test_real_space_transform_solutions)

add_executable(test_real_space_update_convergence
               test_real_space_update_convergence.f90)
add_test(NAME test_real_space_update_convergence
         COMMAND test_real_space_update_convergence)

add_executable(test_real_space_prepare_preconditioner
               test_real_space_prepare_preconditioner.f90)
add_test(NAME test_real_space_prepare_preconditioner
         COMMAND test_real_space_prepare_preconditioner)

add_executable(test_real_space_expand_basis test_real_space_expand_basis.f90)
add_test(NAME test_real_space_expand_basis COMMAND test_real_space_expand_basis)

add_executable(test_real_space_restart test_real_space_restart.f90)
add_test(NAME test_real_space_restart COMMAND test_real_space_restart)

# real_eigenvalue_equation_t tests
add_executable(test_real_eigenvalue_equation_expand_equation
               test_real_eigenvalue_equation_expand_equation.f90)
add_test(NAME test_real_eigenvalue_equation_expand_equation
         COMMAND test_real_eigenvalue_equation_expand_equation)

add_executable(test_real_eigenvalue_equation_solve_projected
               test_real_eigenvalue_equation_solve_projected.f90)
add_test(NAME test_real_eigenvalue_equation_solve_projected
         COMMAND test_real_eigenvalue_equation_solve_projected)

add_executable(test_real_eigenvalue_equation_get_lagrangian
               test_real_eigenvalue_equation_get_lagrangian.f90)
add_test(NAME test_real_eigenvalue_equation_get_lagrangian
         COMMAND test_real_eigenvalue_equation_get_lagrangian)

add_executable(test_real_eigenvalue_equation_make_residuals
               test_real_eigenvalue_equation_make_residuals.f90)
add_test(NAME test_real_eigenvalue_equation_make_residuals
         COMMAND test_real_eigenvalue_equation_make_residuals)

add_executable(test_real_eigenvalue_equation_resize_vectors
               test_real_eigenvalue_equation_resize_vectors.f90)
add_test(NAME test_real_eigenvalue_equation_resize_vectors
         COMMAND test_real_eigenvalue_equation_resize_vectors)

add_executable(test_real_eigenvalue_equation_resize_solutions
               test_real_eigenvalue_equation_resize_solutions.f90)
add_test(NAME test_real_eigenvalue_equation_resize_solutions
         COMMAND test_real_eigenvalue_equation_resize_solutions)

# real_linear_equation_t tests
add_executable(test_real_linear_equation_expand_equation
               test_real_linear_equation_expand_equation.f90)
add_test(NAME test_real_linear_equation_expand_equation
         COMMAND test_real_linear_equation_expand_equation)

add_executable(test_real_linear_equation_solve_projected
               test_real_linear_equation_solve_projected.f90)
add_test(NAME test_real_linear_eqution_solve_projected
         COMMAND test_real_linear_equation_solve_projected)

add_executable(test_real_linear_equation_make_residuals
               test_real_linear_equation_make_residuals.f90)
add_test(NAME test_real_linear_equation_make_residuals
         COMMAND test_real_linear_equation_make_residuals)

add_executable(test_real_linear_equation_get_lagrangian
               test_real_linear_equation_get_lagrangian.f90)
add_test(NAME test_real_linear_equation_get_lagrangian
         COMMAND test_real_linear_equation_get_lagrangian)

# real_shifted_linear_equation_t tests
add_executable(test_real_shifted_linear_equation_expand_equation
               test_real_shifted_linear_equation_expand_equation.f90)
add_test(NAME test_real_shifted_linear_equation_expand_equation
         COMMAND test_real_shifted_linear_equation_expand_equation)

add_executable(test_real_shifted_linear_equation_solve_projected
               test_real_shifted_linear_equation_solve_projected.f90)
add_test(NAME test_real_shifted_linear_eqution_solve_projected
         COMMAND test_real_shifted_linear_equation_solve_projected)

add_executable(test_real_shifted_linear_equation_make_residuals
               test_real_shifted_linear_equation_make_residuals.f90)
add_test(NAME test_real_shifted_linear_equation_make_residuals
         COMMAND test_real_shifted_linear_equation_make_residuals)

add_executable(test_real_shifted_linear_equation_get_lagrangian
               test_real_shifted_linear_equation_get_lagrangian.f90)
add_test(NAME test_real_shifted_linear_equation_get_lagrangian
         COMMAND test_real_shifted_linear_equation_get_lagrangian)

# complex_eigenvalue_equation_t tests
add_executable(test_complex_eigenvalue_equation_expand_equation
               test_complex_eigenvalue_equation_expand_equation.f90)
add_test(NAME test_complex_eigenvalue_equation_expand_equation
         COMMAND test_complex_eigenvalue_equation_expand_equation)

add_executable(test_complex_eigenvalue_equation_solve_projected
               test_complex_eigenvalue_equation_solve_projected.f90)
add_test(NAME test_complex_eigenvalue_equation_solve_projected
         COMMAND test_complex_eigenvalue_equation_solve_projected)

add_executable(test_complex_eigenvalue_equation_get_lagrangian
               test_complex_eigenvalue_equation_get_lagrangian.f90)
add_test(NAME test_complex_eigenvalue_equation_get_lagrangian
         COMMAND test_complex_eigenvalue_equation_get_lagrangian)

add_executable(test_complex_eigenvalue_equation_make_residuals
               test_complex_eigenvalue_equation_make_residuals.f90)
add_test(NAME test_complex_eigenvalue_equation_make_residuals
         COMMAND test_complex_eigenvalue_equation_make_residuals)

add_executable(test_complex_eigenvalue_equation_resize_vectors
               test_complex_eigenvalue_equation_resize_vectors.f90)
add_test(NAME test_complex_eigenvalue_equation_resize_vectors
         COMMAND test_complex_eigenvalue_equation_resize_vectors)

add_executable(test_complex_eigenvalue_equation_resize_solutions
               test_complex_eigenvalue_equation_resize_solutions.f90)
add_test(NAME test_complex_eigenvalue_equation_resize_solutions
         COMMAND test_complex_eigenvalue_equation_resize_solutions)

# complex_linear_equation_t tests
add_executable(test_complex_linear_equation_expand_equation
               test_complex_linear_equation_expand_equation.f90)
add_test(NAME test_complex_linear_equation_expand_equation
         COMMAND test_complex_linear_equation_expand_equation)

add_executable(test_complex_linear_equation_solve_projected
               test_complex_linear_equation_solve_projected.f90)
add_test(NAME test_complex_linear_eqution_solve_projected
         COMMAND test_complex_linear_equation_solve_projected)

add_executable(test_complex_linear_equation_make_residuals
               test_complex_linear_equation_make_residuals.f90)
add_test(NAME test_complex_linear_equation_make_residuals
         COMMAND test_complex_linear_equation_make_residuals)

add_executable(test_complex_linear_equation_get_lagrangian
               test_complex_linear_equation_get_lagrangian.f90)
add_test(NAME test_complex_linear_equation_get_lagrangian
         COMMAND test_complex_linear_equation_get_lagrangian)

# complex_shifted_linear_equation_t tests
add_executable(test_complex_shifted_linear_equation_expand_equation
               test_complex_shifted_linear_equation_expand_equation.f90)
add_test(NAME test_complex_shifted_linear_equation_expand_equation
         COMMAND test_complex_shifted_linear_equation_expand_equation)

add_executable(test_complex_shifted_linear_equation_solve_projected
               test_complex_shifted_linear_equation_solve_projected.f90)
add_test(NAME test_complex_shifted_linear_eqution_solve_projected
         COMMAND test_complex_shifted_linear_equation_solve_projected)

add_executable(test_complex_shifted_linear_equation_make_residuals
               test_complex_shifted_linear_equation_make_residuals.f90)
add_test(NAME test_complex_shifted_linear_equation_make_residuals
         COMMAND test_complex_shifted_linear_equation_make_residuals)

add_executable(test_complex_shifted_linear_equation_get_lagrangian
               test_complex_shifted_linear_equation_get_lagrangian.f90)
add_test(NAME test_complex_shifted_linear_equation_get_lagrangian
         COMMAND test_complex_shifted_linear_equation_get_lagrangian)

# cmake-format: off
 
# TODO
# real_sylvester_equation_t tests
# complex_sylvester_equation_t tests

# cmake-format: on

# real_null_preconditioner_t tests
add_executable(test_real_null_preconditioner_transform_residuals
               test_real_null_preconditioner_transform_residuals.f90)
add_test(NAME test_real_null_preconditioner_transform_residuals
         COMMAND test_real_null_preconditioner_transform_residuals)

# real_cg_preconditioner_t tests
add_executable(test_real_cg_preconditioner_transform_residuals
               test_real_cg_preconditioner_transform_residuals.f90)
add_test(NAME test_real_cg_preconditioner_transform_residuals
         COMMAND test_real_cg_preconditioner_transform_residuals)

# real_davidson_preconditioner_t tests
add_executable(test_real_davidson_preconditioner_transform_residuals
               test_real_davidson_preconditioner_transform_residuals.f90)
add_test(NAME test_real_davidson_preconditioner_transform_residuals
         COMMAND test_real_davidson_preconditioner_transform_residuals)

# real_jd_precontioner_t tests
add_executable(test_real_jd_preconditioner_transform_residuals
               test_real_jd_preconditioner_transform_residuals.f90)
add_test(NAME test_real_jd_preconditioner_transform_residuals
         COMMAND test_real_jd_preconditioner_transform_residuals)

# real_jdall_precontioner_t tests
add_executable(test_real_jdall_preconditioner_transform_residuals
               test_real_jdall_preconditioner_transform_residuals.f90)
add_test(NAME test_real_jdall_preconditioner_transform_residuals
         COMMAND test_real_jdall_preconditioner_transform_residuals)

# complex_null_preconditioner_t tests
add_executable(test_complex_null_preconditioner_transform_residuals
               test_complex_null_preconditioner_transform_residuals.f90)
add_test(NAME test_complex_null_preconditioner_transform_residuals
         COMMAND test_complex_null_preconditioner_transform_residuals)

# complex_cg_preconditioner_t tests
add_executable(test_complex_cg_preconditioner_transform_residuals
               test_complex_cg_preconditioner_transform_residuals.f90)
add_test(NAME test_complex_cg_preconditioner_transform_residuals
         COMMAND test_complex_cg_preconditioner_transform_residuals)

# complex_davidson_preconditioner_t tests
add_executable(test_complex_davidson_preconditioner_transform_residuals
               test_complex_davidson_preconditioner_transform_residuals.f90)
add_test(NAME test_complex_davidson_preconditioner_transform_residuals
         COMMAND test_complex_davidson_preconditioner_transform_residuals)

# complex_jd_preconditioner_t tests
add_executable(test_complex_jd_preconditioner_transform_residuals
               test_complex_jd_preconditioner_transform_residuals.f90)
add_test(NAME test_complex_jd_preconditioner_transform_residuals
         COMMAND test_complex_jd_preconditioner_transform_residuals)

# complex_jdall_preconditioner_t tests
add_executable(test_complex_jdall_preconditioner_transform_residuals
               test_complex_jdall_preconditioner_transform_residuals.f90)
add_test(NAME test_complex_jdall_preconditioner_transform_residuals
         COMMAND test_complex_jdall_preconditioner_transform_residuals)

# real_ortho_orthonormalizer_t tests
add_executable(test_real_ortho_orthonormalizer_prepare_transform
               test_real_ortho_orthonormalizer_prepare_transform.f90)
add_test(NAME test_real_ortho_orthonormalizer_prepare_transform
         COMMAND test_real_ortho_orthonormalizer_prepare_transform)

add_executable(test_real_ortho_orthonormalizer_prepare_vectors
               test_real_ortho_orthonormalizer_prepare_vectors.f90)
add_test(NAME test_real_ortho_orthonormalizer_prepare_vectors
         COMMAND test_real_ortho_orthonormalizer_prepare_vectors)

add_executable(test_real_ortho_orthonormalizer_get_gram_rcond
               test_real_ortho_orthonormalizer_get_gram_rcond.f90)
add_test(NAME test_real_ortho_orthonormalizer_get_gram_rcond
         COMMAND test_real_ortho_orthonormalizer_get_gram_rcond)

add_executable(test_real_ortho_orthonormalizer_transform_rayleigh
               test_real_ortho_orthonormalizer_transform_rayleigh.f90)
add_test(NAME test_real_ortho_orthonormalizer_transform_rayleigh
         COMMAND test_real_ortho_orthonormalizer_transform_rayleigh)

add_executable(test_real_ortho_orthonormalizer_transform_basis_rhs
               test_real_ortho_orthonormalizer_transform_basis_rhs.f90)
add_test(NAME test_real_ortho_orthonormalizer_transform_basis_rhs
         COMMAND test_real_ortho_orthonormalizer_transform_basis_rhs)

# real_nks_orthonormalizer_t tests
add_executable(test_real_nks_orthonormalizer_prepare_vectors
               test_real_nks_orthonormalizer_prepare_vectors.f90)
add_test(NAME test_real_nks_orthonormalizer_prepare_vectors
         COMMAND test_real_nks_orthonormalizer_prepare_vectors)

add_executable(test_real_nks_orthonormalizer_prepare_transform
               test_real_nks_orthonormalizer_prepare_transform.f90)
add_test(NAME test_real_nks_orthonormalizer_prepare_transform
         COMMAND test_real_nks_orthonormalizer_prepare_transform)

add_executable(test_real_nks_orthonormalizer_get_gram_rcond
               test_real_nks_orthonormalizer_get_gram_rcond.f90)
add_test(NAME test_real_nks_orthonormalizer_get_gram_rcond
         COMMAND test_real_nks_orthonormalizer_get_gram_rcond)

add_executable(test_real_nks_orthonormalizer_transform_rayleigh
               test_real_nks_orthonormalizer_transform_rayleigh.f90)
add_test(NAME test_real_nks_orthonormalizer_transform_rayleigh
         COMMAND test_real_nks_orthonormalizer_transform_rayleigh)

add_executable(test_real_nks_orthonormalizer_transform_basis_rhs
               test_real_nks_orthonormalizer_transform_basis_rhs.f90)
add_test(NAME test_real_nks_orthonormalizer_transform_basis_rhs
         COMMAND test_real_nks_orthonormalizer_transform_basis_rhs)

# real_semi_orthonormalizer_t tests
add_executable(test_real_semi_orthonormalizer_prepare_vectors
               test_real_semi_orthonormalizer_prepare_vectors.f90)
add_test(NAME test_real_semi_orthonormalizer_prepare_vectors
         COMMAND test_real_semi_orthonormalizer_prepare_vectors)

add_executable(test_real_semi_orthonormalizer_prepare_transform
               test_real_semi_orthonormalizer_prepare_transform.f90)
add_test(NAME test_real_semi_orthonormalizer_prepare_transform
         COMMAND test_real_semi_orthonormalizer_prepare_transform)

add_executable(test_real_semi_orthonormalizer_get_gram_rcond
               test_real_semi_orthonormalizer_get_gram_rcond.f90)
add_test(NAME test_real_semi_orthonormalizer_get_gram_rcond
         COMMAND test_real_semi_orthonormalizer_get_gram_rcond)

add_executable(test_real_semi_orthonormalizer_transform_rayleigh
               test_real_semi_orthonormalizer_transform_rayleigh.f90)
add_test(NAME test_real_semi_orthonormalizer_transform_rayleigh
         COMMAND test_real_semi_orthonormalizer_transform_rayleigh)

add_executable(test_real_semi_orthonormalizer_transform_basis_rhs
               test_real_semi_orthonormalizer_transform_basis_rhs.f90)
add_test(NAME test_real_semi_orthonormalizer_transform_basis_rhs
         COMMAND test_real_semi_orthonormalizer_transform_basis_rhs)

# complex_ortho_orthonormalizer_t tests
add_executable(test_complex_ortho_orthonormalizer_prepare_transform
               test_complex_ortho_orthonormalizer_prepare_transform.f90)
add_test(NAME test_complex_ortho_orthonormalizer_prepare_transform
         COMMAND test_complex_ortho_orthonormalizer_prepare_transform)

add_executable(test_complex_ortho_orthonormalizer_prepare_vectors
               test_complex_ortho_orthonormalizer_prepare_vectors.f90)
add_test(NAME test_complex_ortho_orthonormalizer_prepare_vectors
         COMMAND test_complex_ortho_orthonormalizer_prepare_vectors)

add_executable(test_complex_ortho_orthonormalizer_get_gram_rcond
               test_complex_ortho_orthonormalizer_get_gram_rcond.f90)
add_test(NAME test_complex_ortho_orthonormalizer_get_gram_rcond
         COMMAND test_complex_ortho_orthonormalizer_get_gram_rcond)

add_executable(test_complex_ortho_orthonormalizer_transform_rayleigh
               test_complex_ortho_orthonormalizer_transform_rayleigh.f90)
add_test(NAME test_complex_ortho_orthonormalizer_transform_rayleigh
         COMMAND test_complex_ortho_orthonormalizer_transform_rayleigh)

add_executable(test_complex_ortho_orthonormalizer_transform_basis_rhs
               test_complex_ortho_orthonormalizer_transform_basis_rhs.f90)
add_test(NAME test_complex_ortho_orthonormalizer_transform_basis_rhs
         COMMAND test_complex_ortho_orthonormalizer_transform_basis_rhs)

# complex_nks_orthonormalizer_t tests
add_executable(test_complex_nks_orthonormalizer_prepare_vectors
               test_complex_nks_orthonormalizer_prepare_vectors.f90)
add_test(NAME test_complex_nks_orthonormalizer_prepare_vectors
         COMMAND test_complex_nks_orthonormalizer_prepare_vectors)

add_executable(test_complex_nks_orthonormalizer_prepare_transform
               test_complex_nks_orthonormalizer_prepare_transform.f90)
add_test(NAME test_complex_nks_orthonormalizer_prepare_transform
         COMMAND test_complex_nks_orthonormalizer_prepare_transform)

add_executable(test_complex_nks_orthonormalizer_get_gram_rcond
               test_complex_nks_orthonormalizer_get_gram_rcond.f90)
add_test(NAME test_complex_nks_orthonormalizer_get_gram_rcond
         COMMAND test_complex_nks_orthonormalizer_get_gram_rcond)

add_executable(test_complex_nks_orthonormalizer_transform_rayleigh
               test_complex_nks_orthonormalizer_transform_rayleigh.f90)
add_test(NAME test_complex_nks_orthonormalizer_transform_rayleigh
         COMMAND test_complex_nks_orthonormalizer_transform_rayleigh)

add_executable(test_complex_nks_orthonormalizer_transform_basis_rhs
               test_complex_nks_orthonormalizer_transform_basis_rhs.f90)
add_test(NAME test_complex_nks_orthonormalizer_transform_basis_rhs
         COMMAND test_complex_nks_orthonormalizer_transform_basis_rhs)

# complex_semi_orthonormalizer_t tests
add_executable(test_complex_semi_orthonormalizer_prepare_vectors
test_complex_semi_orthonormalizer_prepare_vectors.f90)
add_test(NAME test_complex_semi_orthonormalizer_prepare_vectors
COMMAND test_complex_semi_orthonormalizer_prepare_vectors)

add_executable(test_complex_semi_orthonormalizer_prepare_transform
test_complex_semi_orthonormalizer_prepare_transform.f90)
add_test(NAME test_complex_semi_orthonormalizer_prepare_transform
COMMAND test_complex_semi_orthonormalizer_prepare_transform)

add_executable(test_complex_semi_orthonormalizer_get_gram_rcond
test_complex_semi_orthonormalizer_get_gram_rcond.f90)
add_test(NAME test_complex_semi_orthonormalizer_get_gram_rcond
COMMAND test_complex_semi_orthonormalizer_get_gram_rcond)

add_executable(test_complex_semi_orthonormalizer_transform_rayleigh
test_complex_semi_orthonormalizer_transform_rayleigh.f90)
add_test(NAME test_complex_semi_orthonormalizer_transform_rayleigh
COMMAND test_complex_semi_orthonormalizer_transform_rayleigh)

add_executable(test_complex_semi_orthonormalizer_transform_basis_rhs
test_complex_semi_orthonormalizer_transform_basis_rhs.f90)
add_test(NAME test_complex_semi_orthonormalizer_transform_basis_rhs
COMMAND test_complex_semi_orthonormalizer_transform_basis_rhs)

# complex_semi_orthonormalizer_t

# Use generic version of c/zdotc functions because the Accelerate version is
# broken. See
# http://mirror.informatimago.com/next/developer.apple.com/hardware/ve/errata.html
if(APPLE AND "${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
  target_compile_definitions(krylov PUBLIC USE_GENERIC_DOTC)
endif()
