program test_set_real_block_products

    use kinds, only: IK, RK
    use errors, only: OK
    use testing, only: near_real_mat
    use krylov, only: krylov_initialize, krylov_finalize, krylov_add_space, &
                      krylov_set_real_block_products, spaces, real_space_t
    implicit none

    integer(IK) :: error, index, full_dims(2_IK), subset_dims(2_IK), offsets(2_IK)
    real(RK) :: products(5_IK), products_1(3_IK, 1_IK), products_2(2_IK, 1_IK)

    products = (/1.0_RK, 2.0_RK, -1.0_RK, 3.0_RK, -2.0_RK/)
    products_1 = reshape((/1.0_RK, 2.0_RK, -1.0_RK/), (/3_IK, 1_IK/))
    products_2 = reshape((/3.0_RK, -2.0_RK/), (/2_IK, 1_IK/))

    error = krylov_initialize()
    if (error /= OK) stop 1

    ! Add real space with full dimension 3, current dimension 1
    index = krylov_add_space('r', 's', 'e', 3_IK, 1_IK, 1_IK)
    if (index /= 1_IK) stop 1
    spaces(index)%space_p%new_dim = 1_IK
    full_dims(index) = 3_IK
    subset_dims(index) = 1_IK
    offsets(index) = 0_IK

    ! Add second real space with full dimension 2, current dimension 1
    index = krylov_add_space('r', 's', 'e', 2_IK, 1_IK, 1_IK)
    if (index /= 2_IK) stop 1
    spaces(index)%space_p%new_dim = 1_IK
    full_dims(index) = 2_IK
    subset_dims(index) = 1_IK
    offsets(index) = 3_IK

    error = krylov_set_real_block_products(2_IK, 5_IK, full_dims, subset_dims, &
                                           offsets, products)
    if (error /= OK) stop 1

    select type (space => spaces(1_IK)%space_p)
    type is (real_space_t)
        if (space%equation%products /= near_real_mat(products_1)) stop 1
    end select

    select type (space => spaces(2_IK)%space_p)
    type is (real_space_t)
        if (space%equation%products /= near_real_mat(products_2)) stop 1
    end select

    error = krylov_finalize()
    if (error /= OK) stop 1

end program test_set_real_block_products
