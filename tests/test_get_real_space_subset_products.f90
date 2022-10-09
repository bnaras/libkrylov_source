program test_get_real_space_subset_products

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_set_real_space_subset_products, &
                      krylov_get_real_space_subset_products
    use testing, only: near_real_mat
    implicit none

    integer(IK) :: error, index
    real(RK) :: products_1(10_IK, 2_IK), products_2(10_IK, 2_IK)

    products_1 = -1.0_RK

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 10, current dimension 3
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Add complex space with full dimension 10, current dimension 4
    index = krylov_add_space('c', 'h', 'e', 10_IK, 2_IK, 4_IK)
    if (index /= 2_IK) stop 1

    ! Set products on first space
    error = krylov_set_real_space_subset_products(1_IK, 10_IK, 1_IK, 2_IK, products_1)
    if (error /= OK) stop 1

    ! Get products from first space
    error = krylov_get_real_space_subset_products(1_IK, 10_IK, 1_IK, 2_IK, products_2)
    if (error /= OK) stop 1
    if (products_2 /= near_real_mat(products_1)) stop 1

    ! Try to set products on non-existent space
    error = krylov_set_real_space_subset_products(3_IK, 1_IK, 1_IK, 1_IK, products_1)
    if (error /= NO_SUCH_SPACE) stop 1

    ! Try to get products from non-existent space
    error = krylov_get_real_space_subset_products(3_IK, 1_IK, 1_IK, 1_IK, products_2)
    if (error /= NO_SUCH_SPACE) stop 1

    ! Try to set products on complex space
    error = krylov_set_real_space_subset_products(2_IK, 10_IK, 1_IK, 1_IK, products_1)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to get products from complex space
    error = krylov_get_real_space_subset_products(2_IK, 10_IK, 1_IK, 1_IK, products_2)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to set products with wrong full dimension
    error = krylov_set_real_space_subset_products(1_IK, 8_IK, 2_IK, 2_IK, products_1)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to get products with wrong full dimension
    error = krylov_get_real_space_subset_products(1_IK, 8_IK, 2_IK, 2_IK, products_2)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to set products with impossible skip dimension
    error = krylov_set_real_space_subset_products(1_IK, 10_IK, 3_IK, 2_IK, products_1)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to get products with impossible skip dimension
    error = krylov_get_real_space_subset_products(1_IK, 10_IK, 3_IK, 2_IK, products_2)
    if (error /= INVALID_DIMENSION) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_space_subset_products
