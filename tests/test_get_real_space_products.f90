program test_get_real_space_products

    use kinds, only: IK, RK
    use errors, only: OK, NO_SUCH_SPACE, INCOMPATIBLE_SPACE, INVALID_DIMENSION
    use testing, only: near_real_mat
    use krylov, only: spaces, real_space_t, krylov_initialize, krylov_finalize, &
                      krylov_add_space, krylov_get_real_space_products
    implicit none

    integer(IK) :: error, index
    real(RK) :: products_1(10_IK, 3_IK), products_2(10_IK, 3_IK), products_3(5_IK, 2_IK), &
     products_4(4_IK, 2_IK)

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 10, current dimension 3
    index = krylov_add_space('r', 's', 'e', 10_IK, 2_IK, 3_IK)
    if (index /= 1_IK) stop 1

    ! Add second real space with full dimension 5, current dimension 2
    index = krylov_add_space('r', 's', 'e', 5_IK, 1_IK, 2_IK)
    if (index /= 2_IK) stop 1

    ! Add complex space with full dimension 4, current dimension 2
    index = krylov_add_space('c', 'h', 'e', 4_IK, 1_IK, 2_IK)
    if (index /= 3_IK) stop 1

    ! Get products on first space (1.0)
    products_1 = 1.0_RK
    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        space%equation%products = products_1
    end select
    products_2 = 0.0_RK
    error = krylov_get_real_space_products(1_IK, 10_IK, 3_IK, products_2)
    if (error /= OK) stop 1
    if (products_1 /= near_real_mat(products_2)) stop 1

    ! Try to get products from first space with wrong dimensions
    error = krylov_get_real_space_products(1_IK, 8_IK, 2_IK, products_3)
    if (error /= INVALID_DIMENSION) stop 1

    ! Try to get products from complex space
    error = krylov_get_real_space_products(3_IK, 4_IK, 2_IK, products_4)
    if (error /= INCOMPATIBLE_SPACE) stop 1

    ! Try to get products from non-existent space
    error = krylov_get_real_space_products(4_IK, 5_IK, 1_IK, products_4)
    if (error /= NO_SUCH_SPACE) stop 1

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_get_real_space_products
