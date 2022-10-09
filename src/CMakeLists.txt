if(NOT INTEGER_KIND)
  set(INTEGER_KIND "INT64")
endif()
if(NOT REAL_KIND)
  set(REAL_KIND "REAL64")
endif()
if(NOT COMPLEX_KIND)
  set(COMPLEX_KIND "COMPLEX64")
endif()
if(NOT CHARACTER_KIND)
  set(CHARACTER_KIND "CHARACTER_DEFAULT")
endif()
if(NOT LOGICAL_KIND)
  set(LOGICAL_KIND "LOGICAL_DEFAULT")
endif()
if (NOT LOG_LEVEL)
  set(LOG_LEVEL "ERROR")
endif()

add_library(
  krylov

  # Modules
  krylov.f90
  kinds.f90
  versions.f90
  errors.f90
  dict.f90
  options.f90
  utils.f90
  linalg.f90
  blaswrapper.f90
  lapackwrapper.f90
  control.f90
  equations.f90
  solvers.f90
  preconditioners.f90
  orthonormalizers.f90
  testing.f90
  logging.f90
  cutils.f90

  # Global functions
  krylov_initialize.f90
  krylov_finalize.f90
  krylov_get_version.f90
  krylov_get_compiled_datetime.f90
  krylov_get_current_datetime.f90
  krylov_header.f90
  krylov_footer.f90
  krylov_set_defaults.f90
  krylov_get_integer_option.f90
  krylov_set_integer_option.f90
  krylov_get_string_option.f90
  krylov_set_string_option.f90
  krylov_length_string_option.f90
  krylov_get_real_option.f90
  krylov_set_real_option.f90
  krylov_get_logical_option.f90
  krylov_set_logical_option.f90
  krylov_get_enum_option.f90
  krylov_set_enum_option.f90
  krylov_length_enum_option.f90
  krylov_define_enum_option.f90
  krylov_validate_enum_option.f90
  krylov_add_space.f90
  krylov_get_num_spaces.f90
  krylov_get_real_block_total_size.f90
  krylov_get_real_block_dims.f90
  krylov_get_real_block_vectors.f90
  krylov_set_real_block_products.f90
  krylov_get_real_block_convergence.f90
  krylov_solve_real_block_equation.f90
  krylov_get_complex_block_total_size.f90
  krylov_get_complex_block_dims.f90
  krylov_get_complex_block_vectors.f90
  krylov_set_complex_block_products.f90
  krylov_get_complex_block_convergence.f90
  krylov_solve_complex_block_equation.f90

  # Global space-specific functions (using space index)
  krylov_get_space_integer_option.f90
  krylov_set_space_integer_option.f90
  krylov_get_space_string_option.f90
  krylov_set_space_string_option.f90
  krylov_length_space_string_option.f90
  krylov_get_space_real_option.f90
  krylov_set_space_real_option.f90
  krylov_get_space_logical_option.f90
  krylov_set_space_logical_option.f90
  krylov_get_space_enum_option.f90
  krylov_set_space_enum_option.f90
  krylov_length_space_enum_option.f90
  krylov_define_space_enum_option.f90
  krylov_validate_space_enum_option.f90
  krylov_get_space_kind.f90
  krylov_get_space_structure.f90
  krylov_get_space_equation.f90
  krylov_get_space_preconditioner.f90
  krylov_set_space_preconditioner.f90
  krylov_get_space_orthonormalizer.f90
  krylov_set_space_orthonormalizer.f90
  krylov_get_space_full_dim.f90
  krylov_get_space_solution_dim.f90
  krylov_get_space_basis_dim.f90
  krylov_get_space_vector_size.f90
  krylov_get_space_solution_size.f90
  krylov_get_space_eigenvalue_size.f90
  krylov_get_space_rhs_size.f90
  krylov_get_space_sylvester_b_size.f90
  krylov_get_space_num_iterations.f90
  krylov_get_space_iteration_basis_dim.f90
  krylov_get_space_iteration_gram_rcond.f90
  krylov_get_space_iteration_expectation_vals.f90
  krylov_get_space_iteration_lagrangian.f90
  krylov_get_space_iteration_residual_norms.f90
  krylov_get_space_iteration_max_residual_norm.f90
  krylov_get_space_last_basis_dim.f90
  krylov_get_space_last_expectation_vals.f90
  krylov_get_space_last_lagrangian.f90
  krylov_get_space_last_residual_norms.f90
  krylov_get_space_last_max_residual_norm.f90
  krylov_get_space_last_gram_rcond.f90
  krylov_get_space_convergence.f90
  krylov_get_space_eigenvalues.f90
  krylov_set_space_diagonal.f90
  krylov_get_space_shifts.f90
  krylov_set_space_shifts.f90
  krylov_get_real_space_vectors.f90
  krylov_set_real_space_vectors.f90
  krylov_set_real_space_vectors_from_diagonal.f90
  krylov_resize_real_space_vectors.f90
  krylov_get_real_space_products.f90
  krylov_get_real_space_solutions.f90
  krylov_resize_real_space_solutions.f90
  krylov_get_real_space_rhs.f90
  krylov_set_real_space_rhs.f90
  krylov_get_real_space_sylvester_b.f90
  krylov_set_real_space_sylvester_b.f90
  krylov_get_complex_space_vectors.f90
  krylov_set_complex_space_vectors.f90
  krylov_set_complex_space_vectors_from_diagonal.f90
  krylov_resize_complex_space_vectors.f90
  krylov_get_complex_space_products.f90
  krylov_get_complex_space_solutions.f90
  krylov_resize_complex_space_solutions.f90
  krylov_get_complex_space_rhs.f90
  krylov_set_complex_space_rhs.f90
  krylov_get_complex_space_sylvester_b.f90
  krylov_set_complex_space_sylvester_b.f90
  krylov_get_real_space_subset_vectors.f90
  krylov_set_real_space_subset_vectors.f90
  krylov_get_real_space_subset_products.f90
  krylov_set_real_space_subset_products.f90
  krylov_get_complex_space_subset_vectors.f90
  krylov_set_complex_space_subset_vectors.f90
  krylov_get_complex_space_subset_products.f90
  krylov_set_complex_space_subset_products.f90
  krylov_solve_real_equation.f90
  krylov_solve_complex_equation.f90

  # iteration_t methods
  krylov_iteration_initialize.f90
  krylov_iteration_get_basis_dim.f90
  krylov_iteration_get_solution_dim.f90
  krylov_iteration_get_gram_rcond.f90
  krylov_iteration_get_expectation_vals.f90
  krylov_iteration_set_expectation_vals.f90
  krylov_iteration_get_lagrangian.f90
  krylov_iteration_get_residual_norms.f90
  krylov_iteration_set_residual_norms.f90
  krylov_iteration_get_max_residual_norm.f90

  # convergence_t methods
  krylov_convergence_initialize.f90
  krylov_convergence_add_iteration.f90
  krylov_convergence_get_num_iterations.f90
  krylov_convergence_get_iteration_basis_dim.f90
  krylov_convergence_get_iteration_gram_rcond.f90
  krylov_convergence_get_iteration_expectation_vals.f90
  krylov_convergence_get_iteration_lagrangian.f90
  krylov_convergence_get_iteration_residual_norms.f90
  krylov_convergence_get_iteration_max_residual_norm.f90
  krylov_convergence_get_last_basis_dim.f90
  krylov_convergence_get_last_gram_rcond.f90
  krylov_convergence_get_last_expectation_vals.f90
  krylov_convergence_get_last_lagrangian.f90
  krylov_convergence_get_last_residual_norms.f90
  krylov_convergence_get_last_max_residual_norm.f90
  krylov_convergence_get_solution_convergence.f90
  krylov_convergence_get_convergence.f90
  krylov_convergence_get_active_dim.f90
  krylov_convergence_get_active.f90

  # real_space_t methods
  krylov_real_space_initialize.f90
  krylov_real_space_set_equation.f90
  krylov_real_space_set_preconditioner.f90
  krylov_real_space_set_orthonormalizer.f90
  krylov_real_space_prepare_orthonormalizer.f90
  krylov_real_space_expand_equation.f90
  krylov_real_space_solve_projected.f90
  krylov_real_space_make_residuals.f90
  krylov_real_space_transform_solutions.f90
  krylov_real_space_update_convergence.f90
  krylov_real_space_prepare_preconditioner.f90
  krylov_real_space_expand_basis.f90
  krylov_real_space_restart.f90

  # complex_space_t methods
  krylov_complex_space_initialize.f90
  krylov_complex_space_set_equation.f90
  krylov_complex_space_set_preconditioner.f90
  krylov_complex_space_set_orthonormalizer.f90
  krylov_complex_space_prepare_orthonormalizer.f90
  krylov_complex_space_expand_equation.f90
  krylov_complex_space_solve_projected.f90
  krylov_complex_space_make_residuals.f90
  krylov_complex_space_transform_solutions.f90
  krylov_complex_space_update_convergence.f90
  krylov_complex_space_prepare_preconditioner.f90
  krylov_complex_space_expand_basis.f90
  krylov_complex_space_restart.f90

  # real_eigenvalue_equation_t methods
  krylov_real_eigenvalue_equation_initialize.f90
  krylov_real_eigenvalue_equation_expand_equation.f90
  krylov_real_eigenvalue_equation_solve_projected.f90
  krylov_real_eigenvalue_equation_get_expectation_vals.f90
  krylov_real_eigenvalue_equation_get_lagrangian.f90
  krylov_real_eigenvalue_equation_make_residuals.f90
  krylov_real_eigenvalue_equation_resize_vectors.f90
  krylov_real_eigenvalue_equation_resize_solutions.f90

  # real_linear_equation_t methods
  krylov_real_linear_equation_initialize.f90
  krylov_real_linear_equation_expand_equation.f90
  krylov_real_linear_equation_solve_projected.f90
  krylov_real_linear_equation_get_expectation_vals.f90
  krylov_real_linear_equation_get_lagrangian.f90
  krylov_real_linear_equation_make_residuals.f90
  krylov_real_linear_equation_resize_vectors.f90
  krylov_real_linear_equation_resize_solutions.f90

  # real_shifted_linear_equation_t methods
  krylov_real_shifted_linear_equation_initialize.f90
  krylov_real_shifted_linear_equation_expand_equation.f90
  krylov_real_shifted_linear_equation_solve_projected.f90
  krylov_real_shifted_linear_equation_get_expectation_vals.f90
  krylov_real_shifted_linear_equation_get_lagrangian.f90
  krylov_real_shifted_linear_equation_make_residuals.f90
  krylov_real_shifted_linear_equation_resize_vectors.f90
  krylov_real_shifted_linear_equation_resize_solutions.f90

  # real_sylvester_equation_t methods
  krylov_real_sylvester_equation_initialize.f90
  krylov_real_sylvester_equation_expand_equation.f90
  krylov_real_sylvester_equation_solve_projected.f90
  krylov_real_sylvester_equation_get_expectation_vals.f90
  krylov_real_sylvester_equation_get_lagrangian.f90
  krylov_real_sylvester_equation_make_residuals.f90
  krylov_real_sylvester_equation_resize_vectors.f90
  krylov_real_sylvester_equation_resize_solutions.f90

  # complex_eigenvalue_equation_t methods
  krylov_complex_eigenvalue_equation_initialize.f90
  krylov_complex_eigenvalue_equation_expand_equation.f90
  krylov_complex_eigenvalue_equation_solve_projected.f90
  krylov_complex_eigenvalue_equation_get_expectation_vals.f90
  krylov_complex_eigenvalue_equation_get_lagrangian.f90
  krylov_complex_eigenvalue_equation_make_residuals.f90
  krylov_complex_eigenvalue_equation_resize_vectors.f90
  krylov_complex_eigenvalue_equation_resize_solutions.f90

  # complex_linear_equation_t methods
  krylov_complex_linear_equation_initialize.f90
  krylov_complex_linear_equation_expand_equation.f90
  krylov_complex_linear_equation_solve_projected.f90
  krylov_complex_linear_equation_get_expectation_vals.f90
  krylov_complex_linear_equation_get_lagrangian.f90
  krylov_complex_linear_equation_make_residuals.f90
  krylov_complex_linear_equation_resize_vectors.f90
  krylov_complex_linear_equation_resize_solutions.f90

  # complex_shifted_linear_equation_t methods
  krylov_complex_shifted_linear_equation_initialize.f90
  krylov_complex_shifted_linear_equation_expand_equation.f90
  krylov_complex_shifted_linear_equation_solve_projected.f90
  krylov_complex_shifted_linear_equation_get_expectation_vals.f90
  krylov_complex_shifted_linear_equation_get_lagrangian.f90
  krylov_complex_shifted_linear_equation_make_residuals.f90
  krylov_complex_shifted_linear_equation_resize_vectors.f90
  krylov_complex_shifted_linear_equation_resize_solutions.f90

  # complex_sylvester_equation_t methods
  krylov_complex_sylvester_equation_initialize.f90
  krylov_complex_sylvester_equation_expand_equation.f90
  krylov_complex_sylvester_equation_solve_projected.f90
  krylov_complex_sylvester_equation_get_expectation_vals.f90
  krylov_complex_sylvester_equation_get_lagrangian.f90
  krylov_complex_sylvester_equation_make_residuals.f90
  krylov_complex_sylvester_equation_resize_vectors.f90
  krylov_complex_sylvester_equation_resize_solutions.f90

  # real_null_preconditioner_t methods
  krylov_real_null_preconditioner_initialize.f90
  krylov_real_null_preconditioner_get_status.f90
  krylov_real_null_preconditioner_transform_residuals.f90

  # real_cg_preconditioner_t methods
  krylov_real_cg_preconditioner_initialize.f90
  krylov_real_cg_preconditioner_set_diagonal.f90
  krylov_real_cg_preconditioner_get_status.f90
  krylov_real_cg_preconditioner_transform_residuals.f90

  # real_davidson_preconditioner_t methods
  krylov_real_davidson_preconditioner_initialize.f90
  krylov_real_davidson_preconditioner_set_diagonal.f90
  krylov_real_davidson_preconditioner_set_eigenvalues.f90
  krylov_real_davidson_preconditioner_set_shifts.f90
  krylov_real_davidson_preconditioner_get_status.f90
  krylov_real_davidson_preconditioner_transform_residuals.f90

  # real_jd_preconditioner_t methods
  krylov_real_jd_preconditioner_initialize.f90
  krylov_real_jd_preconditioner_set_diagonal.f90
  krylov_real_jd_preconditioner_set_eigenvalues.f90
  krylov_real_jd_preconditioner_set_shifts.f90
  krylov_real_jd_preconditioner_set_solutions.f90
  krylov_real_jd_preconditioner_get_status.f90
  krylov_real_jd_preconditioner_transform_residuals.f90

  # real_jdall_preconditioner_t methods
  krylov_real_jdall_preconditioner_initialize.f90
  krylov_real_jdall_preconditioner_set_diagonal.f90
  krylov_real_jdall_preconditioner_set_eigenvalues.f90
  krylov_real_jdall_preconditioner_set_shifts.f90
  krylov_real_jdall_preconditioner_set_solutions.f90
  krylov_real_jdall_preconditioner_get_status.f90
  krylov_real_jdall_preconditioner_transform_residuals.f90

  # complex_null_preconditioner_t methods
  krylov_complex_null_preconditioner_initialize.f90
  krylov_complex_null_preconditioner_get_status.f90
  krylov_complex_null_preconditioner_transform_residuals.f90

  # complex_cg_preconditioner_t methods
  krylov_complex_cg_preconditioner_initialize.f90
  krylov_complex_cg_preconditioner_set_diagonal.f90
  krylov_complex_cg_preconditioner_get_status.f90
  krylov_complex_cg_preconditioner_transform_residuals.f90

  # complex_davidson_preconditioner_t methods
  krylov_complex_davidson_preconditioner_initialize.f90
  krylov_complex_davidson_preconditioner_set_diagonal.f90
  krylov_complex_davidson_preconditioner_set_eigenvalues.f90
  krylov_complex_davidson_preconditioner_set_shifts.f90
  krylov_complex_davidson_preconditioner_get_status.f90
  krylov_complex_davidson_preconditioner_transform_residuals.f90

  # complex_jd_preconditioner_t methods
  krylov_complex_jd_preconditioner_initialize.f90
  krylov_complex_jd_preconditioner_set_diagonal.f90
  krylov_complex_jd_preconditioner_set_eigenvalues.f90
  krylov_complex_jd_preconditioner_set_shifts.f90
  krylov_complex_jd_preconditioner_set_solutions.f90
  krylov_complex_jd_preconditioner_get_status.f90
  krylov_complex_jd_preconditioner_transform_residuals.f90

  # complex_jdall_preconditioner_t methods
  krylov_complex_jdall_preconditioner_initialize.f90
  krylov_complex_jdall_preconditioner_set_diagonal.f90
  krylov_complex_jdall_preconditioner_set_eigenvalues.f90
  krylov_complex_jdall_preconditioner_set_shifts.f90
  krylov_complex_jdall_preconditioner_set_solutions.f90
  krylov_complex_jdall_preconditioner_get_status.f90
  krylov_complex_jdall_preconditioner_transform_residuals.f90

  # real_nks_orthonormalizer_t methods
  krylov_real_nks_orthonormalizer_initialize.f90
  krylov_real_nks_orthonormalizer_prepare_vectors.f90
  krylov_real_nks_orthonormalizer_prepare_transform.f90
  krylov_real_nks_orthonormalizer_transform_rayleigh.f90
  krylov_real_nks_orthonormalizer_transform_basis_rhs.f90
  krylov_real_nks_orthonormalizer_restore_basis_solutions.f90
  krylov_real_nks_orthonormalizer_get_gram_rcond.f90

  # real_semi_orthonormalizer_t methods
  krylov_real_semi_orthonormalizer_initialize.f90
  krylov_real_semi_orthonormalizer_prepare_vectors.f90
  krylov_real_semi_orthonormalizer_prepare_transform.f90
  krylov_real_semi_orthonormalizer_transform_rayleigh.f90
  krylov_real_semi_orthonormalizer_transform_basis_rhs.f90
  krylov_real_semi_orthonormalizer_restore_basis_solutions.f90
  krylov_real_semi_orthonormalizer_get_gram_rcond.f90

  # real_ortho_orthonormalizer_t methods
  krylov_real_ortho_orthonormalizer_initialize.f90
  krylov_real_ortho_orthonormalizer_prepare_vectors.f90
  krylov_real_ortho_orthonormalizer_prepare_transform.f90
  krylov_real_ortho_orthonormalizer_transform_rayleigh.f90
  krylov_real_ortho_orthonormalizer_transform_basis_rhs.f90
  krylov_real_ortho_orthonormalizer_restore_basis_solutions.f90
  krylov_real_ortho_orthonormalizer_get_gram_rcond.f90

  # complex_nks_orthonormalizer_t methods
  krylov_complex_nks_orthonormalizer_initialize.f90
  krylov_complex_nks_orthonormalizer_prepare_vectors.f90
  krylov_complex_nks_orthonormalizer_prepare_transform.f90
  krylov_complex_nks_orthonormalizer_transform_rayleigh.f90
  krylov_complex_nks_orthonormalizer_transform_basis_rhs.f90
  krylov_complex_nks_orthonormalizer_restore_basis_solutions.f90
  krylov_complex_nks_orthonormalizer_get_gram_rcond.f90

  # complex_semi_orthonormalizer_t methods
  krylov_complex_semi_orthonormalizer_initialize.f90
  krylov_complex_semi_orthonormalizer_prepare_vectors.f90
  krylov_complex_semi_orthonormalizer_prepare_transform.f90
  krylov_complex_semi_orthonormalizer_transform_rayleigh.f90
  krylov_complex_semi_orthonormalizer_transform_basis_rhs.f90
  krylov_complex_semi_orthonormalizer_restore_basis_solutions.f90
  krylov_complex_semi_orthonormalizer_get_gram_rcond.f90

  # complex_ortho_orthonormalizer_t methods
  krylov_complex_ortho_orthonormalizer_initialize.f90
  krylov_complex_ortho_orthonormalizer_prepare_vectors.f90
  krylov_complex_ortho_orthonormalizer_prepare_transform.f90
  krylov_complex_ortho_orthonormalizer_transform_rayleigh.f90
  krylov_complex_ortho_orthonormalizer_transform_basis_rhs.f90
  krylov_complex_ortho_orthonormalizer_restore_basis_solutions.f90
  krylov_complex_ortho_orthonormalizer_get_gram_rcond.f90
  # C wrappers
  ckrylovwrapper.f90)

# On macOS, the module variables (common symbols, showing up as C in nm) are not
# correctly included in the table of contents of the library. See
# https://stackoverflow.com/questions/19398742/os-x-linker-unable-to-find-symbols-from-a-c-file-which-only-contains-variables
# The general solution is to run `ranlib -c` on the library to add the common
# symbols (C) to the table of contents.
if(APPLE)
  add_custom_command(
    TARGET krylov
    POST_BUILD
    COMMAND ${CMAKE_RANLIB} -c $<TARGET_FILE:krylov>)
endif()

string(TIMESTAMP LIBKRYLOV_COMPILED_DT "%Y-%m-%d %H:%M:%S")

target_compile_definitions(
  krylov
  PUBLIC USE_${INTEGER_KIND} USE_${REAL_KIND} USE_${COMPLEX_KIND}
         USE_${CHARACTER_KIND} USE_${LOGICAL_KIND} LOG_LEVEL_${LOG_LEVEL}
         LIBKRYLOV_VERSION=\"${libkrylov_VERSION}\"
         LIBKRYLOV_COMPILED_DT=\"${LIBKRYLOV_COMPILED_DT}\")
target_include_directories(krylov PRIVATE ${krylov_SOURCE_DIR})
target_link_libraries(krylov PRIVATE ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES})
set_target_properties(krylov PROPERTIES PUBLIC_HEADER "ckrylov.h;ctypes.h")

if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.18.0")
  set_property(SOURCE kinds.f90 PROPERTY Fortran_PREPROCESS ON)
  set_property(SOURCE versions.f90 PROPERTY Fortran_PREPROCESS ON)
  set_property(SOURCE logging.f90 PROPERTY Fortran_PREPROCESS ON)
  set_property(SOURCE blaswrapper.f90 PROPERTY Fortran_PREPROCESS ON)
  set_property(SOURCE lapackwrapper.f90 PROPERTY Fortran_PREPROCESS ON)
else()
  if("${CMAKE_Fortran_COMPILER_ID}" MATCHES "Intel")
    target_compile_options(krylov PUBLIC -fpp)
  elseif("${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
    target_compile_options(krylov PUBLIC -cpp)
  endif()
endif()

# Use generic version of c/zdotc functions because the Accelerate version is
# broken. See
# http://mirror.informatimago.com/next/developer.apple.com/hardware/ve/errata.html
if(APPLE AND "${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
  target_compile_definitions(krylov PUBLIC USE_GENERIC_DOTC)
endif()

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

install(TARGETS krylov EXPORT ${PROJECT_NAME})

install(
  EXPORT ${PROJECT_NAME}
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/krylov
  FILE krylov-config.cmake)

write_basic_package_version_file(${CMAKE_BINARY_DIR}/krylov-config-version.cmake
                                 COMPATIBILITY SameMajorVersion)

install(FILES "${CMAKE_BINARY_DIR}/krylov-config-version.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/krylov)
