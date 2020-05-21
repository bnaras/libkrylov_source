!--------------------------------------------------------------------
!--------------------------------------------------------------------
module libkrylovsolver
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This module defines a krylov subspace solver for
!< a hermitian or symmetric eigenvalue problem
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Varaibles
!--------------------------------------------------------------------
! single, double and integer kind parameters
  use basekinds
! parameters for precision based on real(kind_float)
  use floatformat
! type(base) of the problem 
! with elementary functions
  use basetypes
! with BLAS/LAPack calls
  use blastypes
! get interface
  use libkrylovinterface
!--------------------------------------------------------------------
! Implicit none
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------


!--------------------------------------------------------------------
! Define control string to stop or kill solver
!--------------------------------------------------------------------

! character string of file name, which if exists will stop solver 
! and proceed to end of solver steps
  character(len=14), parameter :: stop_file_string = 'stop.libkrylov'

! character string of file name, which if exists will kill solver
! and return to solver call. Literal kill. Use with caution.
  character(len=14), parameter :: kill_file_string = 'kill.libkrylov'

!--------------------------------------------------------------------


!--------------------------------------------------------------------
contains
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_normalize(n1,n2,vectors,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! subroutine for normalizing vectors
!! this does nothing
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!    rows of vectors, nbasis
    integer(kind_integer), intent(in) :: n1
!!    columns of vectors
    integer(kind_integer), intent(in) :: n2
!--------------------------------------------------------------------
! Input/Output Parameters
!--------------------------------------------------------------------
!!  vectors
    type(base), intent(inout) :: vectors(n1,n2)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
    type(base) :: norm_sq_base
    real(kind_float) :: norm_real
    integer(kind_integer) :: j
!--------------------------------------------------------------------

    do j = 1, n2
      call gdot(n1,vectors(1:n1,j),1,vectors(1:n1,j), &
  &       1,norm_sq_base,ierr)
      if (ierr.ne.0) return
      norm_real = norm_sq_base
      norm_real = sqrt(norm_real)
! normalize
      vectors(1:n1,j) = vectors(1:n1,j)/norm_real
    end do

!--------------------------------------------------------------------
  end subroutine krylov_normalize
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_orthogonalize(n1,n2,vectors,n3,iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!! subroutine for orthogonalizing vectors
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!!    rows of vectors, nbasis
    integer(kind_integer), intent(in) :: n1
!!    columns of vectors, must be less than n1 on input
    integer(kind_integer), intent(in) :: n2
!--------------------------------------------------------------------
! Input/Output Parameters
!--------------------------------------------------------------------
!!    columns of vectors, on output
    integer(kind_integer), intent(inout) :: n3
!!  vectors
    type(base), intent(inout) :: vectors(n1,n2)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
    type(base), allocatable :: tau(:)
    type(base), allocatable :: magnitude(:)
    real(kind_float) :: test_val
    integer(kind_integer) :: j,k,l
!--------------------------------------------------------------------

!! allocate tau
    allocate(tau(n2))
    allocate(magnitude(n2))

!! do QR decomposition
    call ggeqrf(n1,n2,vectors,n1,tau,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*geqrf linear algebra error!', ierr
        print *, 'vectors cannot be QR decomposed'
      end if
      ierr = -30
      return ! return to solver loop
    end if

!! THIS DOES NOT WORK
!! save sum of R, leaving out small values
    magnitude = real(0,kind=kind_float)
    do l = 1, n2
      do j = l, n2
        test_val = vectors(l,j)
        if (test_val.gt.eps) then
          magnitude(l) = magnitude(l) + vectors(l,j)
        end if
      end do
    end do

!! generate q
    call gungqr(n1,n2,n2,vectors,n1,tau,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*ungqr/*orgqr linear algebra error!', ierr
        print *, 'Q of QR cannot be obtained'
      end if
      ierr = -30
      return ! return to solver loop
    end if

!! remove zero magnitude vectors, determine n3
    n3 = 0
    do l = 1, n2
      test_val = magnitude(l)
      if (test_val.gt.eps) then
        n3 = n3 + 1
        vectors(1:n1,n3) = vectors(1:n1,l)*magnitude(l)
      end if   
    end do

    deallocate(tau)
    deallocate(magnitude)

!--------------------------------------------------------------------
  end subroutine krylov_orthogonalize
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_unique(nsubspace,nrhs,&
  &     proj_rhs,iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine checks that the vectors in proj_rhs 
!< are not linearly dependent
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nsubspace
    integer(kind_integer), intent(in) :: nrhs
    type(base), intent(in) :: proj_rhs(nsubspace,nrhs)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
!! integer for loops
    integer(kind_integer) :: j, k = 0
    type(base), allocatable :: inner_product(:,:)
    real(kind_float) :: real_temp1, real_temp2, test_value
    logical :: problem = .false.
!--------------------------------------------------------------------

    allocate(inner_product(nrhs,nrhs))

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)

    call ggemm('c','n',nrhs,nrhs,nsubspace,one_kb,&
  &       proj_rhs,nsubspace,&
  &       proj_rhs,nsubspace,&
  &       zero_kb,&
  &       inner_product,&
  &       nrhs)

    if (iverb.ge.5) then
      print *, ''
      print *, 'printing out norms squared and inner products'
      print *, ' of initial projected rhs' 
      print *, '                   1  rhs norm squared: ',&
  &     inner_product(1,1)
    end if
    do j = 2, nrhs
        if (iverb.ge.5) then
          print *, j,' rhs norm squared: ',inner_product(j,j)
        end if
      do k = 1, j-1
        if (iverb.ge.5) then
          print *, j,' and',k,' rhs inner product: ',inner_product(j,k)
        end if
        real_temp1 = inner_product(j,k)*inner_product(k,j)
        real_temp2 = inner_product(j,j)*inner_product(k,k)
        test_value = sqrt(sqrt(real_temp1))-sqrt(sqrt(real_temp2))
        if (abs(test_value).lt.eps) then
          if (iverb.ge.0) then
            print *, 'rhs',j,' and',k,' project'
            print *, ' onto subspace vectors that' 
            print *, '  share the same direction!'
            print *, '   (or one of them is a zero vector)'
            if (iverb.ge.2) then
              print *, 'test value:', test_value
            end if
          end if
          problem = .true.
        end if
      end do
    end do

    if (problem) then
      ierr = -50
    end if

    deallocate(inner_product)

!--------------------------------------------------------------------
  end subroutine krylov_unique
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_rayleigh(nbasis,nsubspace,&
  &     approx_spectra,mvproduct,&
  &     basis_vectors,rayleigh,iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the first construction of the 
!< rayleigh matrix.
!< THIS WOULD BE A GOOD PLACE TO INCLUDE SYMMETRIZATION
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace ! first subspace!
    real(kind_float), intent(in) :: approx_spectra(nbasis)
    type(base), intent(in) :: mvproduct(nbasis,nsubspace)
    type(base), intent(in) :: basis_vectors(nbasis,nsubspace)
!--------------------------------------------------------------------
! Output Variables
!--------------------------------------------------------------------
    type(base), intent(inout) :: rayleigh(nsubspace,nsubspace)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
!! integer for loops
    integer(kind_integer) :: j, k = 0
!--------------------------------------------------------------------


!! determine rayleigh
!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! first ggemm to get basis,new-basis block 
    call ggemm('c','n',nsubspace,nsubspace,nbasis,one_kb,&
  &   basis_vectors(1:nbasis,1:nsubspace),nbasis,&
  &   mvproduct(1:nbasis,1:nsubspace),nbasis,&
  &   zero_kb,&
  &   rayleigh(1:nsubspace,1:nsubspace),&
  &   nsubspace)
!! elementwise copying to symmetrize
    do k = 1, nsubspace 
      do j = 1, (k-1) 
        rayleigh(j,k) = &
  &       (rayleigh(j,k) + conjg(rayleigh(k,j)))&
          /(real(2,kind=kind_float))
        rayleigh(k,j) = conjg(rayleigh(j,k))
      end do
      rayleigh(k,k) = &
  &       (rayleigh(k,k) + conjg(rayleigh(k,k)))&
          /(real(2,kind=kind_float))
    end do

!--------------------------------------------------------------------
  end subroutine krylov_rayleigh
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_extend(nbasis,nsubspace,&
  &     nresiduals,prev_nsubspace,residuals,&
  &     basis_vectors,overlap,diag_overlap,iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the extend step of a krylov solve,
!< extending the subspace for the next iteration,
!< using preconditioned residuals.
!< the overlap matrix and diagonal of said matrix are also extended.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace ! new subspace!
    integer(kind_integer), intent(in) :: nresiduals
    integer(kind_integer), intent(in) :: prev_nsubspace
    type(base), intent(in) :: residuals(nbasis,nresiduals)
!--------------------------------------------------------------------
! Variables Extended
!--------------------------------------------------------------------
    type(base), intent(inout) :: basis_vectors(nbasis,nsubspace)
    type(base), intent(inout) :: overlap(nsubspace,nsubspace)
    real(kind_float), intent(inout) :: diag_overlap(nsubspace)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
!! integer for loops
    integer(kind_integer) :: j, k = 0
!--------------------------------------------------------------------

!! add preconditioned residuals to basis vector
    basis_vectors(1:nbasis,(prev_nsubspace+1):nsubspace) =&
  &    residuals(1:nbasis,1:nresiduals)

!! determine overlap
!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! first ggemm to get new-basis,new-basis block 
    call ggemm('c','n',nresiduals,nresiduals,nbasis,one_kb,&
  &   basis_vectors(1:nbasis,(prev_nsubspace+1):(nsubspace)),nbasis,&
  &   basis_vectors(1:nbasis,(prev_nsubspace+1):(nsubspace)),nbasis,&
  &   zero_kb,&
  &   overlap((prev_nsubspace+1):(nsubspace),&
  &    (prev_nsubspace+1):(nsubspace)),&
  &   nresiduals)
!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! second ggemm to get old-basis,new-basis block
    call ggemm('c','n',prev_nsubspace,nresiduals,nbasis,&
  &   one_kb,basis_vectors(1:nbasis,1:prev_nsubspace),&
  &   nbasis,basis_vectors(1:nbasis,(prev_nsubspace+1):(nsubspace)),&
  &   nbasis,zero_kb,&
  &   overlap(1:(prev_nsubspace),(prev_nsubspace+1):(nsubspace)),&
  &   prev_nsubspace)
!! elementwise copying to get new-basis,old-basis block
    do k = (prev_nsubspace+1), nsubspace ! columns -> rows
      do j = 1, prev_nsubspace ! rows -> columns
        overlap(k,j) = conjg(overlap(j,k))
      end do
    end do

!! determine new diagonal of overlap
    do j = (prev_nsubspace+1), nsubspace
      diag_overlap(j) = overlap(j,j)
      if (diag_overlap(j).lt.real(0,kind=kind_float)) then
        if (iverb.ge.0) then
          print *, 'diagonal of overlap matrix not positive, failed'
          print *, 'exit extend step'
        end if
        ierr = -30
        return ! return to solver loop
      end if
    end do

    if (iverb.ge.2) then
      print *, 'Diagonals of the new overlap matrix:'
      do j = 1 , nsubspace
        print *, 'S of ',j,': ',diag_overlap(j)
      end do
    end if

!--------------------------------------------------------------------
  end subroutine krylov_extend
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_expand(nbasis,nsubspace,&
  &     nresiduals,prev_nsubspace,approx_spectra,mvproduct,&
  &     basis_vectors,rayleigh,iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the expand step of a krylov solve,
!< expanding the rayleigh matrix with new matrix vector products.
!< THIS WOULD BE A GOOD PLACE TO INCLUDE SYMMETRIZATION
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace ! new subspace!
    integer(kind_integer), intent(in) :: nresiduals
    integer(kind_integer), intent(in) :: prev_nsubspace
    real(kind_float), intent(in) :: approx_spectra(nbasis)
    type(base), intent(in) :: mvproduct(nbasis,nsubspace)
    type(base), intent(in) :: basis_vectors(nbasis,nsubspace)
!--------------------------------------------------------------------
! Variables Expanded
!--------------------------------------------------------------------
    type(base), intent(inout) :: rayleigh(nsubspace,nsubspace)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
!! integer for loops
    integer(kind_integer) :: j, k = 0
!--------------------------------------------------------------------


!! determine new parts of rayleigh
!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! first ggemm to get basis,new-basis block 
    call ggemm('c','n',nsubspace,nresiduals,nbasis,one_kb,&
  &   basis_vectors(1:nbasis,1:nsubspace),nbasis,&
  &   mvproduct(1:nbasis,(prev_nsubspace+1):(nsubspace)),nbasis,&
  &   zero_kb,&
  &   rayleigh(1:nsubspace,&
  &    (prev_nsubspace+1):(nsubspace)),&
  &   nsubspace)
!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! second ggemm to get new-basis,old-basis block
    call ggemm('c','n',nresiduals,prev_nsubspace,nbasis,&
  &   one_kb,basis_vectors(1:nbasis,(prev_nsubspace+1):(nsubspace)),&
  &   nbasis,mvproduct(1:nbasis,1:prev_nsubspace),&
  &   nbasis,zero_kb,&
  &   rayleigh((prev_nsubspace+1):(nsubspace),1:prev_nsubspace),&
  &   nresiduals)
!! elementwise copying to symmetrize
    do k = (prev_nsubspace+1), nsubspace 
      do j = 1, (k-1) 
        rayleigh(j,k) = &
  &       (rayleigh(j,k) + conjg(rayleigh(k,j)))&
          /(real(2,kind=kind_float))
        rayleigh(k,j) = conjg(rayleigh(j,k))
      end do
      rayleigh(k,k) = &
  &       (rayleigh(k,k) + conjg(rayleigh(k,k)))&
          /(real(2,kind=kind_float))
    end do


!--------------------------------------------------------------------
  end subroutine krylov_expand
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_project(nbasis,nsubspace,nroots,&
  &     diag_overlap,&
  &     basis_vectors,&
  &     cholesky,&
  &     residuals,&
  &     iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine projects residuals out of the subspace.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace
    integer(kind_integer), intent(in) :: nroots
    real(kind_float), intent(in) :: diag_overlap(nsubspace)
    type(base), intent(in) :: basis_vectors(nbasis,nsubspace)
    type(base), intent(in) :: cholesky(nsubspace,nsubspace)
!--------------------------------------------------------------------
! Output Variables
!--------------------------------------------------------------------
    type(base), intent(inout) :: residuals(nbasis,nroots)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: minus_one_kb
    type(base) :: zero_kb
    real(kind_float), allocatable :: d_o_sqrt(:)
    type(base), allocatable :: projector(:,:)
    type(base), allocatable :: scaled_basis(:,:)
    type(base), allocatable :: dllv(:,:)
    type(base), allocatable :: residuals_sv(:,:)
!! integer for loops
    integer(kind_integer) :: j, k = 0
!--------------------------------------------------------------------

!! stop this madness if nbasis > 10001
    if (nbasis.ge.10001) then
      if (iverb.ge.0) then
        print *, 'projecting vectors in the full space'
        print *, ' requires construction of '
        print *, nbasis,' by',nbasis
        print *, '  matrix, which is too large!'
        print *, '    projection failed'
      end if
      ierr = -1
      return
    end if

    allocate(d_o_sqrt(nsubspace))
    allocate(scaled_basis(nsubspace,nbasis))
    allocate(dllv(nsubspace,nbasis))
    allocate(projector(nbasis,nbasis))
    allocate(residuals_sv(nbasis,nroots))

!! create d_o_sqrt
    d_o_sqrt = sqrt(diag_overlap)

!! create scaled basis vectors
    do k = 1, nsubspace
      scaled_basis(k,1:nbasis) = &
  &     basis_vectors(1:nbasis,k)/d_o_sqrt(k)
    end do

    dllv = scaled_basis

    call gpotrs('l',nsubspace,nbasis,cholesky,nsubspace, &
  &       dllv,nsubspace,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*potrs linear algebra error!', ierr
        print *, 'cholesky decomposition matrix could be unstable'
      end if
      ierr = -30
      return ! return to solver loop
    end if

!! build projector
    projector = real(0,kind=kind_float)
    do j = 1, nbasis
      projector(j,j) = real(1,kind=kind_float)
    end do 
!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)  
    minus_one_kb = real(-1,kind=kind_float)
!! calculation of projector
    call ggemm('c','n',nbasis,nbasis,nsubspace,minus_one_kb,&
  &      scaled_basis,nsubspace,&
  &      dllv,nsubspace,&
  &      one_kb,&
  &      projector,&
  &      nbasis)
!! elementwise copying to symmetrize
    do k = 1, nbasis 
      do j = 1, (k-1) 
        projector(j,k) = &
  &       (projector(j,k) + conjg(projector(k,j)))&
          /(real(2,kind=kind_float))
        projector(k,j) = conjg(projector(j,k))
      end do
      projector(k,k) = &
  &       (projector(k,k) + conjg(projector(k,k)))&
          /(real(2,kind=kind_float))
    end do
!! save residuals due to ggemm structure
    residuals_sv = residuals
!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! Projecting residuals
    call ggemm('n','n',nbasis,nroots,nbasis,one_kb,&
  &      projector(1:nbasis,1:nbasis),nbasis,&
  &      residuals_sv(1:nbasis,1:nroots),nbasis,&
  &      zero_kb,&
  &      residuals(1:nbasis,1:nroots),&
  &      nbasis)

    deallocate(d_o_sqrt)
    deallocate(scaled_basis)
    deallocate(dllv)
    deallocate(projector)
    deallocate(residuals_sv)

!--------------------------------------------------------------------
  end subroutine krylov_project
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_cholesky(nsubspace,overlap,diag_overlap,&
  &   cholesky,iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the cholesky decompostion
!< after scaling the overlap matrix
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nsubspace ! new subspace!
    type(base), intent(in) :: overlap(nsubspace,nsubspace)
    real(kind_float), intent(in) :: diag_overlap(nsubspace)
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
    type(base), intent(inout) :: cholesky(nsubspace,nsubspace)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! integer for loops
    integer(kind_integer) :: j, k = 0
!! sqrt of diagonal
    real(kind_float), allocatable :: d_o_sqrt(:)
!! norms from cholesky
    real(kind_float) :: onorm
    real(kind_float) :: rcond
!--------------------------------------------------------------------

    allocate(d_o_sqrt(nsubspace))

!! assign d_o_sqrt
    d_o_sqrt = sqrt(diag_overlap)
!! assign scaled overlap to cholesky for decomposing
    do k = 1, nsubspace
      cholesky(k,k) = overlap(k,k)/diag_overlap(k)
    end do
    do k = 1, nsubspace
      do j = 1, (k-1)
        cholesky(j,k) = overlap(j,k)/(d_o_sqrt(j)*d_o_sqrt(k))
      end do
      do j = (k+1), nsubspace
        cholesky(j,k) = overlap(j,k)/(d_o_sqrt(j)*d_o_sqrt(k))
      end do
    end do

!! cholesky decomposition
!! lower triangular is more precise due to above multiplication
    call gpotrf('l',nsubspace,cholesky,nsubspace,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*potrf linear algebra error!', ierr
        print *, 'new scaled overlap matrix could be unstable'
      end if
      ierr = -30
      return ! return to solver loop
    end if 
!!! May be the cholesky matrix can be printed. 

!! Condition number calculation and check
!! one norm calculation on onorm
    call glanhe('1','l',nsubspace,cholesky,nsubspace,onorm,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*lanhe/*lansy linear algebra error!', ierr
        print *, 'this error should be impossible with BLAS'
        print *, 'new scaled overlap matrix is unstable'
      end if
      ierr = -25
      return ! return to solver loop
    end if 
    if (iverb.ge.2) then
      print *, 'one norm of new scaled overlap matrix: ',onorm
    end if
!! reciprocal of condition number on rcond
    call gpocon('l',nsubspace,cholesky,nsubspace,onorm,rcond,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*pocon linear algebra error!', ierr
        print *, 'new scaled overlap matrix could be unstable'
      end if
      ierr = -30
      return ! return to solver loop
    end if 
    if (iverb.ge.2) then
      print *, 'Reciprocal of scaled overlap matrix'
      print *, ' condition number: ',rcond
    end if
!! check condition number
    if (log10(rcond).lt.(logeps)) then
      if (iverb.ge.0) then
        print *, 'WARNING: new scaled overlap is ill-conditioned'
      end if
      return ! return to solver loop
    end if

    deallocate(d_o_sqrt)

!--------------------------------------------------------------------
  end subroutine krylov_cholesky
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine krylov_check(nsubspace,overlap,diag_overlap,iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine checks the stability of the subspace
!< by finding eigenvalues of the scaled overlap matrix
!< and doing a cholesky decomposition
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nsubspace ! new subspace!
    type(base), intent(in) :: overlap(nsubspace,nsubspace)
    real(kind_float), intent(in) :: diag_overlap(nsubspace)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! integer for loops
    integer(kind_integer) :: j, k = 0
!! decomposition new of overlap
    type(base), allocatable :: ortho_overlap(:,:)
    type(base), allocatable :: cholesky(:,:)
!! sqrt of diagonal
    real(kind_float), allocatable :: d_o_sqrt(:)
!! roots of overlap matrix
    real(kind_float), allocatable :: overlap_roots(:)
    real(kind_float) :: onorm
    real(kind_float) :: rcond
!--------------------------------------------------------------------

    allocate(ortho_overlap(nsubspace,nsubspace))
    allocate(cholesky(nsubspace,nsubspace))
    allocate(d_o_sqrt(nsubspace))
    allocate(overlap_roots(nsubspace))

!! assign d_o_sqrt
    d_o_sqrt = sqrt(diag_overlap)
!! assign scaled overlap to ortho_overlap for solving
    do k = 1, nsubspace
      do j = 1, nsubspace
        if (j.eq.k) then
          ortho_overlap(j,j) = overlap(j,j)/diag_overlap(j)
          cholesky(j,j) = overlap(j,j)/diag_overlap(j)
        else
          ortho_overlap(j,k) = overlap(j,k)/(d_o_sqrt(j)*d_o_sqrt(k))
          cholesky(j,k) = overlap(j,k)/(d_o_sqrt(j)*d_o_sqrt(k))
        end if
      end do
    end do
!    print *, 'significant overlap'
!    do k = 1, nsubspace
!      do j = 1, nsubspace
!        onorm = overlap(j,k)
!        if (onorm.gt.(real(10.0,kind=kind_float)**(-8))) then
!          print *, j,k,overlap(j,k)
!        end if
!      end do
!    end do
!! Check condition of overlap matrix by diagonalizing
    call gheev('v','l',nsubspace,ortho_overlap,nsubspace,&
    &     overlap_roots,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'new overlap matrix cannot be solved after scaling.'
        print *, '*heev ierr value = ', ierr
      end if
      ierr = -25
      return ! return to solver loop
    end if
!! Print overlap matrix roots and check for small/negative values
    if (iverb.ge.3) then
      print *, 'eigenvalues of new scaled overlap matrix'
    end if
    do j = 1, nsubspace
      if (iverb.ge.3) then
        print *, 'eigenvalue ',j,' ',overlap_roots(j)
      end if
      if (overlap_roots(j).le.eps) then
        if (iverb.ge.0) then
          print *, 'new scaled overlap matrix is linearly dependent!'
          print *, 'eigenvalue ',j,' is less than machine precision.'
        end if
        ierr = -30
      end if
    end do

!! cholesky decomposition
!! lower triangular is more precise due to above multiplication
    call gpotrf('l',nsubspace,cholesky,nsubspace,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*potrf linear algebra error!', ierr
        print *, 'new scaled overlap matrix could be unstable'
      end if
      ierr = -30
      return ! return to solver loop
    end if 
!!! May be the cholesky matrix can be printed. 

!! Condition number calculation and check
!! one norm calculation on onorm
    call glanhe('1','l',nsubspace,cholesky,nsubspace,onorm,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*lanhe/*lansy linear algebra error!', ierr
        print *, 'this error should be impossible with BLAS'
        print *, 'new scaled overlap matrix is unstable'
      end if
      ierr = -25
      return ! return to solver loop
    end if 
    if (iverb.ge.2) then
      print *, 'one norm of new scaled overlap matrix: ',onorm
    end if
!! reciprocal of condition number on rcond
    call gpocon('l',nsubspace,cholesky,nsubspace,onorm,rcond,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*pocon linear algebra error!', ierr
        print *, 'new scaled overlap matrix could be unstable'
      end if
      ierr = -30
      return ! return to solver loop
    end if 
    if (iverb.ge.2) then
      print *, 'Reciprocal of scaled overlap matrix'
      print *, ' condition number: ',rcond
    end if
!! check condition number
!    if (log10(rcond).lt.(logeps)) then
!      if (iverb.ge.0) then
!        print *, 'new scaled overlap is ill-conditioned'
!      end if
!      ierr = -30
!      return ! return to solver loop
!    end if

    deallocate(ortho_overlap)
    deallocate(d_o_sqrt)
    deallocate(overlap_roots)

!--------------------------------------------------------------------
  end subroutine krylov_check
!--------------------------------------------------------------------

!--------------------------------------------------------------------
  subroutine array_read_rstrt_size(fname,val1,val2,iverb,ierr)
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine reads in the dimensions of 
!< an array from rstrt file, to prepare for restart
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input/Output Parameters
!--------------------------------------------------------------------
!! name of file to be read
    character(len=32), intent(in) :: fname
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! size of obj
    integer(kind_integer), intent(inout) :: val1, val2
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! file unit
    integer(kind_integer) :: funit = 0
!! local array to test that file contents are all there
    type(base), allocatable :: test_array(:,:)
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'No free file units!'
      end if
      ierr = -9
      return
    end if

!! no file existance check - the file already exists for this
!! routine to be called.

!! open file
    open(unit=funit,file=fname,form='unformatted',&
  & action='read',iostat=ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'file cannot be opened!'
      end if
      close(unit=funit,iostat=ierr,status='keep') ! force close with iostat
      ierr = -7
      return
    end if

!! read first line which contains sizes
    read(unit=funit,iostat=ierr) val1,val2
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'file size cannot be read!'
      end if
      close(unit=funit,iostat=ierr,status='keep') ! force close with iostat
      ierr = -7
      return
    end if

    allocate(test_array(val1,val2))
!! test reading of values
    read(unit=funit,iostat=ierr) test_array
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'file contents corrupted!'
      end if
      close(unit=funit,iostat=ierr,status='keep') ! force close with iostat
      deallocate(test_array)
      ierr = -7
      return
    end if

    close(unit=funit,iostat=ierr,status='keep') ! last value of ierr
    if (ierr.ne.0) ierr = -7
    deallocate(test_array)


!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine array_read_rstrt_size
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine array_read_rstrt(fname,n1,n2,obj,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine reads in an array from rstrt file to type(base)
!< with already allocated dimensions 
! This subroutine is overkill, consider cutting down
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! name of file
    character(len=32), intent(in) :: fname
!! rows of obj1
    integer(kind_integer), intent(in) :: n1
!! columns of obj1
    integer(kind_integer), intent(in) :: n2
!--------------------------------------------------------------------
! Output Parameters
!--------------------------------------------------------------------
!! obj to be filled
    type(base), intent(out) :: obj(n1,n2)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! dummy indexes
    integer(kind_integer) :: k1 = 0
    integer(kind_integer) :: k2 = 0
!! file unit
    integer(kind_integer) :: funit = 0
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'No free file units!'
      end if
      ierr = -9
      return
    end if

!! no file existance check - the file already exists for this
!! routine to be called.

!! open file
    open(unit=funit,file=fname,form='unformatted',&
  &   action='read',iostat=ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'file cannot be opened!'
      end if
      close(unit=funit,iostat=ierr,status='keep') ! force close with iostat
      ierr = -7
      return
    end if

!! read first line which contains sizes
    read(unit=funit,iostat=ierr) k1,k2
!! Check size of file here
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'file does not have dimensions set!'
      end if
      close(unit=funit,iostat=ierr,status='keep') ! force close with iostat
      ierr = -7
      return
    end if
    if (k1.ne.n1) then
      if (iverb.ge.0) then
        print *, 'output array does not have matching rows'
      end if
      close(unit=funit,iostat=ierr,status='keep') ! force close with iostat
      ierr = -7
      return
    end if
    if (k2.ne.n2) then
      if (iverb.ge.0) then
        print *, 'output array does not have matching rows'
      end if
      close(unit=funit,iostat=ierr,status='keep') ! force close with iostat
      ierr = -7
      return
    end if

!! reading of values
    read(unit=funit,iostat=ierr) obj
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'file contents corrupted!'
      end if
      close(unit=funit,iostat=ierr,status='keep')
      ierr = -7
      return
    end if

    close(unit=funit,iostat=ierr,status='keep')
    if (ierr.ne.0) ierr = -7

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine array_read_rstrt
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine array_print_rstrt(fname,n1,n2,obj,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine prints in a type(base) array to rstrt file
!< with already allocated dimensions 
! This subroutine is overkill, consider cutting down
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! name of file
    character(len=32), intent(in) :: fname
!! rows of obj1
    integer(kind_integer), intent(in) :: n1
!! columns of obj1
    integer(kind_integer), intent(in) :: n2
!! obj to be printed
    type(base), intent(in) :: obj(n1,n2)
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! dummy indexes
    integer(kind_integer) :: k1 = 0
    integer(kind_integer) :: k2 = 0
!! file unit
    integer(kind_integer) :: funit = 0
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'No free file units!'
      end if
      ierr = -9
      return
    end if

!! no file existance check - the file already exists for this
!! routine to be called.

!! open file
    open(unit=funit,file=fname,form='unformatted',&
  &   action='write',status='replace',iostat=ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'file cannot be opened with replace status!'
      end if
      close(unit=funit,iostat=ierr,status='delete') ! force close with iostat
      ierr = -7
      return
    end if

!! read first line which contains sizes
    write(unit=funit,iostat=ierr) n1,n2
!! Check size of file here
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'unable to write dimensions to file!'
      end if
      close(unit=funit,iostat=ierr,status='delete') ! force close with iostat
      ierr = -7
      return
    end if

!! writing of values
    write(unit=funit,iostat=ierr) obj
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'unable to print contents to file!'
      end if
      close(unit=funit,iostat=ierr,status='delete') !force close with iostat
      ierr = -7
      return
    end if

    close(unit=funit,iostat=ierr,status='keep')
    if (ierr.ne.0) ierr = -7



!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine array_print_rstrt
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine array_del_rstrt(fname,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This routine deletes file 'fname' from the current directory
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
!--------------------------------------------------------------------
!
    implicit none
!
!--------------------------------------------------------------------
! Input Parameters
!--------------------------------------------------------------------
!! name of file
    character(len=32), intent(in) :: fname
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb
    integer(kind_integer), intent(inout) :: ierr
!--------------------------------------------------------------------
!  Local Variables
!--------------------------------------------------------------------
!! file unit
    integer(kind_integer) :: funit = 0
!--------------------------------------------------------------------

!!  find free unit numbers for files
    call find_free_file_unit(funit,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'No free file units!'
      end if
      ierr = -9
      return
    end if

!! no file existance check - not needed

!! open file
    open(unit=funit,file=fname,form='unformatted',&
  &   status='replace',iostat=ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'file cannot be opened with replace status!'
      end if
      close(unit=funit,iostat=ierr,status='delete') ! force close with iostat
      ierr = -7
      return
    end if

!! delete file
    close(unit=funit,iostat=ierr,status='delete')
    if (ierr.ne.0) ierr = -7



!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine array_del_rstrt
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine krylov_a_ritz(nbasis,nsubspace,nroots,&
  &     rayleigh,&
  &     cholesky,&
  &     overlap,diag_overlap,&
  &     roots,lagrangian,solutions,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the ritz step of a krylov solve,
!< producing guess/approximate solutions of the eigenvalue problem
!< in the subspace basis
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace
    integer(kind_integer), intent(in) :: nroots
    type(base), intent(in) :: rayleigh(nsubspace,nsubspace)
    type(base), intent(in) :: cholesky(nsubspace,nsubspace)
    type(base), intent(in) :: overlap(nsubspace,nsubspace)
    real(kind_float), intent(in) :: diag_overlap(nsubspace)
!--------------------------------------------------------------------
! Output Variables
!--------------------------------------------------------------------
    real(kind_float), intent(inout) :: roots(nroots)
    type(base), intent(inout) :: lagrangian(nroots)
    type(base), intent(inout) :: solutions(nsubspace,nroots)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb   
    integer(kind_integer), intent(inout) :: ierr   
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
    type(base), allocatable :: subspace(:,:)
    type(base), allocatable :: vavx(:,:)
    type(base), allocatable :: vvx(:,:)
    type(base) :: expectation
    type(base) :: norm
    real(kind_float), allocatable :: all_roots(:)
    real(kind_float), allocatable :: d_o_sqrt(:)
!! integer for loops
    integer(kind_integer) :: j,k = 0
!--------------------------------------------------------------------

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)

!! Allocate local arrays
    allocate(subspace(nsubspace,nsubspace))
    allocate(all_roots(nsubspace))
    allocate(d_o_sqrt(nsubspace))
    allocate(vavx(nsubspace,nroots))
    allocate(vvx(nsubspace,nroots))

!! construct d_o_sqrt
    d_o_sqrt = sqrt(diag_overlap)

!! scale subspace(rayleigh) with norms
    do k = 1, nsubspace
      do j = 1, (k-1)
        subspace(j,k) = rayleigh(j,k)/(d_o_sqrt(j)*d_o_sqrt(k))
      end do
      do j = (k+1), nsubspace
        subspace(j,k) = rayleigh(j,k)/(d_o_sqrt(j)*d_o_sqrt(k))
      end do
      subspace(k,k) = rayleigh(k,k)/diag_overlap(k)
    end do

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! scale subspace(rayleigh) with cholesky
    call gtrsm('r','l','c','n',nsubspace,nsubspace,one_kb,&
  &   cholesky,nsubspace,subspace,nsubspace)
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
    call gtrsm('l','l','n','n',nsubspace,nsubspace,one_kb,&
  &   cholesky,nsubspace,subspace,nsubspace)

!! solve subspace onto all_roots
    call gheev('v','l',nsubspace,subspace,nsubspace,&
  &   all_roots,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*heev/*syev linear algebra error!', ierr
        print *, 'exit ritz step'
      end if
      ierr = -40
      return ! return to solver loop
    end if 

!! select roots desired
    roots = all_roots(1:nroots)
!! Printing out roots for debugging.
    if (iverb.ge.3) then
      print *, 'all solutions on subspace'
        do j = 1, nsubspace
          print *, 'root ', j,' ', all_roots(j)
        end do 
    end if
    
!! select solutions
    solutions = subspace(1:nsubspace,1:nroots)

!! reverse cholesky on solutions
!! UNKNOWN BUG, ONE CHANGES VALUE, FIX SOON
    one_kb = real(1,kind=kind_float)
    call gtrsm('l','l','c','n',nsubspace,nroots,one_kb,&
  &   cholesky,nsubspace,solutions,nsubspace)

!! reverse scaling to get solutions
    do j = 1, nroots
      do k = 1, nsubspace
        solutions(k,j) = solutions(k,j)/d_o_sqrt(k)
      end do
    end do

!! compute lagrangian
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! compute vavx 
    call ggemm('n','n',nsubspace,nroots,nsubspace,&
  &   one_kb,rayleigh,nsubspace,&
  &   solutions,nsubspace,zero_kb,&
  &   vavx,nsubspace)
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! compute vvx 
    call ggemm('n','n',nsubspace,nroots,nsubspace,&
  &   one_kb,overlap,nsubspace,&
  &   solutions,nsubspace,zero_kb,&
  &   vvx,nsubspace)
    if (iverb.ge.2) then
      print *, 'lagrangians of desired solutions:' 
    end if
    do j = 1, nroots
      call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &     vavx(1:nsubspace,j),1,expectation,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, '*dot(c) linear algebra error!', ierr
          print *, 'exit ritz step'
        end if
        ierr = -40
        return ! return to solver loop
      end if
      call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &     vvx(1:nsubspace,j),1,norm,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, '*dot(c) linear algebra error!', ierr
          print *, 'exit ritz step'
        end if
        ierr = -40
        return ! return to solver loop
      end if
      one_kb = real(1,kind=kind_float)
      lagrangian(j) = expectation-((norm-one_kb)*roots(j))
      if (iverb.ge.2) then
        print *, 'L of ',j,': ',lagrangian(j)
      end if
    end do

! Deallocate local arrays
    deallocate(vavx)
    deallocate(vvx)
    deallocate(subspace)
    deallocate(all_roots)
    deallocate(d_o_sqrt)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine krylov_a_ritz
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine krylov_a_norms(nbasis,nsubspace,nroots,&
  &     mvproduct,basis_vectors,full_solutions,solutions,&
  &     overlap,roots,&
  &     approx_spectra,krylov_precon,residuals,&
  &     euc_norm,largest_euc_norm,fro_norm,&
  &     nresiduals,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the norms step of a krylov solve,
!< producing the residual norms of the approximate solutions.
!< to save computational power the residuals are passed out 
!< from this routine as well.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace
    integer(kind_integer), intent(in) :: nroots
    type(base), intent(in) :: mvproduct(nbasis,nsubspace)
    type(base), intent(in) :: basis_vectors(nbasis,nsubspace)
    type(base), intent(in) :: full_solutions(nbasis,nroots)
    type(base), intent(in) :: solutions(nsubspace,nroots)
    type(base), intent(in) :: overlap(nsubspace,nsubspace)
    real(kind_float), intent(in) :: roots(nroots)
    real(kind_float), intent(in) :: approx_spectra(nbasis)
    class(libkrylov_precon_subroutine) :: krylov_precon
!--------------------------------------------------------------------
! Output Variables
!--------------------------------------------------------------------
    type(base), intent(inout) :: residuals(nbasis,nroots)
    real(kind_float), intent(inout) :: euc_norm(nroots)
    real(kind_float), intent(inout) :: largest_euc_norm
    real(kind_float), intent(inout) :: fro_norm
    integer(kind_integer), intent(inout) :: nresiduals
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb   
    integer(kind_integer), intent(inout) :: ierr   
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
    type(base), allocatable :: all_residuals(:,:)
    type(base), allocatable :: all_solutions(:,:)
    real(kind_float), allocatable :: all_roots(:)
    logical, allocatable :: eps_converged(:)
    real(kind_float) :: lognbasis
    integer(kind_integer) :: ntemp ! n of all_residuals
    type(base), allocatable :: xo(:,:)
    type(base), allocatable :: vxo(:,:)
    type(base), allocatable :: euc_sq(:)
    real(kind_float) :: res_temp
    type(base) :: test_val
!! integer for loops
    integer(kind_integer) :: j,k,l = 0
!--------------------------------------------------------------------

! Allocate local arrays
    allocate(all_residuals(nbasis,nroots))
    allocate(all_solutions(nbasis,nroots))
    allocate(eps_converged(nroots))
    allocate(xo(nsubspace,nroots))
    allocate(vxo(nbasis,nroots))
    allocate(euc_sq(nroots))
    allocate(all_roots(nroots))

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! calculate matrix vector products of the approximate solutions
!! in the representation of the full basis, aka avx, on residuals
    call ggemm('n','n',nbasis,nroots,nsubspace,&
  &   one_kb,mvproduct,nbasis,&
  &   solutions,nsubspace,zero_kb,&
  &   all_residuals,nbasis)
!! calculate scaled eigenvectors on the subspace
    do j = 1, nroots
      vxo(1:nbasis,j) = full_solutions(1:nbasis,j)*roots(j)
    end do
!! preserving
!!!! !! calculate scaled eigenvectors on the subspace
!!!!     do j = 1, nroots
!!!!       xo(1:nsubspace,j) = solutions(1:nsubspace,j)*roots(j)
!!!!     end do
!!!! !! Set constants required for BLAS
!!!!     one_kb = real(1,kind=kind_float)
!!!!     zero_kb = real(0,kind=kind_float)
!!!! !! calculate scaled eigenvectors on the full space
!!!!     call ggemm('n','n',nbasis,nroots,nsubspace,&
!!!!   &   one_kb,basis_vectors,nbasis,&
!!!!   &   xo,nsubspace,zero_kb,&
!!!!   &   vxo,nbasis)
!! make residuals = avx-vxo
    all_residuals = all_residuals - vxo

    if (iverb .ge. 5) then
      print *, 'number of roots solved for', nroots
      print *, 'size of subspace', nsubspace
      print *, 'printing overlap between raw residuals '
      print *, ' and present subspace'
  
      do j = 1, nroots
        do k = 1, nsubspace
          call gdot(nbasis,basis_vectors(1:nbasis,k),1,&
    &       all_residuals(1:nbasis,j),1,test_val,ierr)
          print *, 'inner product of raw residual: ', j
          print *, ' and basis vector: ',k
          print *, test_val
        end do
      end do
    end if

!! get inner product of residual with itself
    do j = 1, nroots
      call gdot(nbasis,all_residuals(1:nbasis,j),1,&
  &     all_residuals(1:nbasis,j),1,euc_sq(j),ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, '*dot linear algebra error!', ierr
          print *, 'exit norms step'
        end if
        ierr = -40
        return ! return to solver loop
      end if
    end do

!! assign type(base) to real
    euc_norm = euc_sq
    do j = 1, nroots
      if (euc_norm(j).lt.real(0,kind=kind_float)) then
        if (iverb.ge.0) then
          print *, 'square of ',j,' euclidean norm less than zero!'
          print *, 'exit norm step'
        end if
        ierr = -40
        return ! return to solver loop
      end if 
    end do
!! sum real euc_norm(squared) onto real fro_norm
    fro_norm = sum(euc_norm)

!! no check if fro_norm is positive, since it is a sum of positives
    fro_norm = sqrt(fro_norm)
    if (iverb.ge.3) then
      print *, 'frobenius norm: ',fro_norm
    end if

!! square root to get euc norm*roots
    euc_norm = sqrt(euc_norm)

    lognbasis = log10(real(nbasis,kind=kind_float))
!! compare euc_norm to logeps+lognbasis, 
!! set eps_converged and nresiduals
    eps_converged = .false.
    ntemp = nroots
    do j = 1, nroots
      if (log10(euc_norm(j)).lt.(logeps)) then
        eps_converged(j) = .true.
        ntemp = ntemp - 1
      end if
    end do
    if (iverb.ge.3) then
      print *, 'number of residuals before precondition: ',ntemp
    end if

!! find largest euc_norm
    largest_euc_norm = maxval(euc_norm)
    if (iverb.ge.3) then
      print *, 'largest euclidean norm: ',largest_euc_norm
      if (iverb.ge.4) then
        do j = 1,nroots
          print *, j,' euclidean norm: ',euc_norm(j)
        end do
      end if
    end if

!! return to calling subroutine if there are no residues
!! above machine precision
    if (ntemp.eq.0) then
      nresiduals = 0
      return
    end if

!! eliminate residuals that have reached machine convergence
    if (ntemp.lt.nroots) then
      l = 0
      do k = 1, ntemp
        if (.not.eps_converged(k)) then
          l = l + 1
          all_residuals(1:nbasis,l) = all_residuals(1:nbasis,k)
          all_solutions(1:nbasis,l) = full_solutions(1:nbasis,k)
          all_roots(l) = roots(k)
        end if
      end do
    else
      all_solutions = full_solutions
      all_roots = roots
    end if

!! Precondition with input function!
    associate(interfacing_fs => all_solutions%element,&
  &           interfacing_rd => all_residuals%element)
      call krylov_precon%lkl_precon(nbasis,ntemp,nsubspace,&
  &     approx_spectra,&
  &     all_roots(1:ntemp),interfacing_fs,&
  &     interfacing_rd(1:nbasis,1:ntemp),ierr)
    end associate
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_precon_subroutine) function failed'
        print *, 'error variable = ',ierr
        print *, 'exit norm step'
      end if
      ierr = -40
      return ! return to solver loop
    end if 

!! reset eps_converged, check norms of preconditioned residuals
!! reuse euc_sq,eps_converged, value of euc_sq lost!
    eps_converged = .false.
    nresiduals = ntemp
    do j = 1, ntemp
!! generate norm squared of preconditioned residual
      call gdot(nbasis,all_residuals(1:nbasis,j),1,&
  &     all_residuals(1:nbasis,j),1,euc_sq(j),ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, '*dot(c) linear algebra error!', ierr
          print *, 'exit norms step'
        end if
        ierr = -40
        return ! return to solver loop
      end if
!! make norm squared real(kind_float)
      res_temp = euc_sq(j)
!! check that norm is positive
      if (res_temp.lt.real(0,kind=kind_float)) then
        if (iverb.ge.0) then
          print *, 'square of ',j,' residual norm'
          print *, 'less than zero after preconditioning'
          print *, 'exit norm step'
        end if
        ierr = -40
        return ! return to solver loop
      end if
!! get norm
      res_temp = sqrt(res_temp)
!! check that norm is larger than (logeps+lognbasis)
      if (log10(res_temp).lt.(logeps)) then
        eps_converged(j) = .true.
        nresiduals = nresiduals - 1
      end if
      if (iverb.ge.4) then
        print *, j,' preconditioned residual norm: ',res_temp
      end if
    end do
    if (iverb.ge.3) then
      print *, 'number of preconditioned residuals: ',nresiduals
    end if

!! preconditioned residual less than eps even though residual is
!! not less than eps IS A PRECONDITIONER PROBLEM
!! ierr = -10

!! store preconditioned residuals on output array
    l = 0 ! cycle over all not converged preconditioned residuals
    if(ntemp.eq.nresiduals) then
      residuals(1:nbasis,1:nresiduals) = &
  &     all_residuals(1:nbasis,1:nresiduals)
    else
      do k = 1, ntemp
        if (.not.eps_converged(k)) then
          l = l + 1
          residuals(1:nbasis,l) = all_residuals(1:nbasis,k)
        end if
      end do
      ierr = -10
    end if

! Deallocate local arrays
    deallocate(all_residuals)
    deallocate(all_roots)
    deallocate(eps_converged)
    deallocate(vxo)
    deallocate(xo)
    deallocate(euc_sq)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine krylov_a_norms
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine problem_a_solver(krylov_approx,krylov_start,&
    & krylov_problem_a,&
    & krylov_guess,krylov_mvp,krylov_precon,krylov_output_a,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine solves a problem with the form 'problem_a'
!< with the non-orthonormal krylov subspace method

  !< This subroutine requires the following 
  !< user-defined subroutines:
  !< krylov_approx for the approximate spectra
  !< krylov_start for determining number of start vectors
  !< krylov_problem  for details of the problem
  !< krylov_guess for initializing more guess vectors and their
  !< overlap
  !< krylov_mvp for matrix vector products
  !< krylov_precon for preconditioning
  !< krylov_output for what to do with the eigenvectors and eigenvalues
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! parameters for precision based on real(kind_float)
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_subroutine) ::    krylov_approx
    class(libkrylov_start_subroutine) ::     krylov_start
    class(libkrylov_problem_a_subroutine) :: krylov_problem_a
    class(libkrylov_guess_subroutine) ::     krylov_guess
    class(libkrylov_mvp_subroutine) ::       krylov_mvp
    class(libkrylov_precon_subroutine) ::    krylov_precon
    class(libkrylov_output_a_subroutine) ::  krylov_output_a
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
! Split into sections for easier reading
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! variable for error variable
    integer(kind_integer), intent(inout) :: ierr 
!! integer for loops
    integer(kind_integer) :: j,k = 0
!! integer for restart files
    integer(kind_integer) :: k1,k2 = 0
!! integer for iteration counting
    integer(kind_integer) :: jter = 0
!! logical to pass a logic check as an arguement
    logical :: check = .false.
!! constants of type base
    type(base) :: one_kb
    type(base) :: zero_kb
    type(base) :: minus_one_kb
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! info to be created by the krylov_a_problem and not changed after
! most of these are used to allocate type(array)
! THESE DEFAULT VALUES SHOULD BE OVERWRITTEN BY DRIVERS
    integer(kind_integer) :: nbasis,nroots = 1
!< size of basis = nbasis = n
!< number of guess solutions = nstart = q(1)
!< number of solutions desired = nroots = p
    integer(kind_integer) :: minstart,maxstart = 1
!< starting basis size thresholds, minimum and maximum
    real(kind_float) :: threshold = real(8,kind=kind_float)
!< threshold = x , numerical approximation 10^(-x)>n~0
!< only for user convergence thresholds
    integer(kind_integer) :: maxiter = 25
!< maximum number of subspace iterations 
    character(len=22) :: id_string = 'libkrylov_a'
!< id = ID of the calculation
!< used only for dumping output
    integer(kind_integer) :: iverb = 0
!< verbosity level
    integer(kind_integer) :: irestart = 0
!< restart level (how often restart is dumped on disk,
!< and what is checked)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! The following are determined from the output of krylov%problem
    integer(kind_integer) :: nstart = 0
    integer(kind_integer) :: nsubspace = 0
!< size of subspace, extended in krylov_a_extend = nsubspace
    integer(kind_integer) :: maxsubspace = 0
!< max size of subspace
    character(len=32) :: vname = ''
!< file names for unformatted basis_vector restart file
    character(len=32) :: wname = ''
!< file names for unformatted matrix vector product restart file
    character(len=32) :: sname = ''
!< file names for unformatted solutions save file
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! Arrays that are allocated after krylov problem
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in with the guess of the spectrum
    real(kind_float), allocatable :: approx_spectra(:)
!< approximation of spectra of problem = approx_spectra = D
    logical, allocatable :: jconverged(:)
!< Indicates which roots are converged
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in with before iterations, expanded in expand
    type(base), allocatable :: basis_vectors(:,:)
    type(base), allocatable :: overlap(:,:)
    real(kind_float), allocatable :: diag_overlap(:)
    type(base), allocatable :: cholesky(:,:)
!< basis_vectors = transformation matrix/projector onto subspace /guess vectors = V 
!< overlap = overlap matrix, (V**dagger)(V)=S
!< diag_overlap = d=diagonal of overlap matrix, (V**dagger)(V)=S
!< cholesky = (L)(L**dagger) decomposition of (d)**(-1/2)(S)(d)**(-1/2)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    integer(kind_integer) :: iter
!< variable for do loop over iterations of krylov subspace
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at matrix vector products
    type(base), allocatable :: mvproduct(:,:)
    type(base), allocatable :: rayleigh(:,:)
!< AV = matrix vector products = mvproduct
!< V**dagger AV = rayleigh
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at krylov_a_ritz
    real(kind_float), allocatable :: roots(:) 
    type(base), allocatable ::  solutions(:,:)
    type(base), allocatable ::  lagrangian(:)
!< roots = eigenvalues of current subspace calculation that are relevant = omega
!< solutions = eigenvectors of current subspace calculation that are relevant = x
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in between ritz and norms
    type(base), allocatable :: full_solutions(:,:)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at krylov_a_norms
    type(base), allocatable :: residuals(:,:)
    real(kind_float), allocatable :: euc_norm(:)
    real(kind_float) :: fro_norm
    real(kind_float) :: largest_euc_norm
    integer(kind_integer) :: nresiduals = 0
!< residuals = preconditioned residuals of the approximate solutions 
!< on the full space = \tilde{R}
!< euc_norm = residual euclid norms of eigenvectors
!< max_euc_norm =  max residual euclid norms of eigenvectors
!< fro_norm = residual frobius norms of desired eigenvectors
!< nresiduals = number of non-zero residuals in the current iteration = nresidue
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at convergence check
    integer(kind_integer) :: nconverged = 0
!< number of converged solutions = nconverged
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in before extend
    integer(kind_integer) :: prev_nsubspace = 0
!< u = old q from previous iteration = prev_nsubspace
!--------------------------------------------------------------------

!! Begin solver!
    ierr = 0

  ! Determine details of davidson problem to be solved
  ! USER-DEFINED FUNCTION
    call krylov_problem_a%lkl_problem_a(nbasis,nroots,&
  &   minstart,maxstart,threshold,maxiter,&
  &   id_string,iverb,irestart,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_a_problem_subroutine) function failed'
        print *, 'error variable = ',ierr
      end if  
      ierr = -65
      return ! abort solver, return to call
    end if

    if (iverb.ge.0) then
      print *, '////////////////////////////////////////////////'
      print *, 'Non-Orthonormal Krylov Subspace Solver'
      print *, '////////////////////////////////////////////////'
      print *, ' Solving problem type problem_a'
      print *, '////////////////////////////////////////////////'
      print *, ' '
      if (iverb.ge.3) then
        print *, 'Compiler details:'
        print *, 'The basetype is " ',basetype_string,' "'
        print *, 'With precision " ',float_print_string,' "'
        print *, 'with machine precision ',eps
        print *, 'and log10 of machine precision is ',logeps
        print *, ' '
      end if
    end if

! check threshold is above machine precision
    if (-threshold.lt.logeps) then
      if (iverb.ge.0) then
        print *, 'threshold below machine precision, solving failed'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if

! force at least one root to be solved
    if (nroots.le.0) then
      nroots = 1
      if (iverb.ge.4) then
        print *, 'desired roots less than one, setting to one'
      end if
    end if

! ensure nroots are less than the basis size
    if (nroots.gt.nbasis) then
      if (iverb.ge.4) then
        print *, 'desired roots more than basis, solving failed'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if

! force starting subspace to be at least equal to nroots
    if (minstart.lt.nroots) then
      minstart = nroots
      if (iverb.ge.4) then
        print *, 'setting minimum starting subspace',&
  &  'to be equal to number of desired roots'
      end if
    end if

! force starting subspace to be at most equal to nbasis
    if (maxstart.gt.nbasis) then
      maxstart = nbasis
      if (iverb.ge.4) then
        print *, 'setting maximum starting subspace',&
  & 'to be equal to number of basis functions'
      end if
    end if


! allocate diagonal first to determine some features of problem
! to set nstart
    allocate(approx_spectra(nbasis))

! fill approx spectra
    call krylov_approx%vector_fill(nbasis,approx_spectra,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_float_subroutine)function for approx failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -50
      return ! abort solver, return to call
    end if

    call krylov_start%lkl_start(nbasis,nroots,&
  &        approx_spectra,nstart,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_start_subroutine) function failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -50
      return ! abort solver, return to call!
    end if


! force starting subspace to be at least minstart
    if (nstart.lt.minstart) then
      nstart = minstart
      if (iverb.ge.4) then
        print *, 'setting starting subspace to minimum'
      end if
    end if
! logic check that starting subspace is less than full basis
    if (nstart.gt.maxstart) then
      nstart = maxstart
      if (iverb.ge.4) then
        print *, 'setting starting subspace to maximum'
      end if
    end if

! Set initial subspace size
    nsubspace = nstart

! Determine max subspace, and check if it is feasible
    maxsubspace = nstart + (maxiter * nroots)

    if (maxsubspace.gt.nbasis) then
      if (iverb.ge.4) then
        print *, 'limiting number of iterations'
        print *, ' to ensure subspace is smaller than full basis'
      end if
      maxsubspace = nbasis
      maxiter = floor((real((nbasis-nstart),kind=kind_float)/&
  &     nroots+real(1,kind=kind_float)),kind=kind_integer)
    end if

!! define file name for restart files
    vname = trim(id_string)//'v.rstrt'
    wname = trim(id_string)//'w.rstrt'
    sname = trim(id_string)//'v.save'


! Allocate all arrays that exist across iterations
    allocate(basis_vectors(nbasis,maxsubspace)) !maximum
    allocate(mvproduct(nbasis,maxsubspace)) !maximum
    allocate(lagrangian(nroots))
    allocate(solutions(maxsubspace,nroots)) !maximum
    allocate(overlap(maxsubspace,maxsubspace)) !maximum
    allocate(cholesky(maxsubspace,maxsubspace)) !maximum
    allocate(rayleigh(maxsubspace,maxsubspace)) !maximum
    allocate(roots(nroots))
    allocate(diag_overlap(maxsubspace)) !maximum
    allocate(full_solutions(nbasis,nroots))
    allocate(residuals(nbasis,nroots)) !maximum
    allocate(euc_norm(nroots))
    allocate(jconverged(nroots))


!! zero out important quantities (may be redundant)
    basis_vectors = real(0,kind=kind_float)
    overlap = real(0,kind=kind_float)
    diag_overlap = real(0,kind=kind_float)

!! if restart is allowed, look for restart v files
!!  invert irestart if new restart is to be generated
!!   as v-file is missing
!! check can be moved after allocation? move back to before!
    if (irestart.ge.2) then
      inquire(file=vname,exist=check)
      if (check) then
        call array_read_rstrt_size(vname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no restart available
          ierr = 0
          irestart = -abs(irestart)
        else if (k1.ne.nbasis) then ! vfile not in this basis
          irestart = -abs(irestart)
        else if (k2.lt.nstart) then ! vfile from a different start?
          irestart = -abs(irestart)
        else if (k2.gt.nstart) then ! vfile from iter>1? ! vfile pass all checks
            nstart = k2
            maxiter = floor((real((maxsubspace-nstart),kind=kind_float)/&
  &           nroots+real(1,kind=kind_float)),kind=kind_integer)
        end if ! vfile pass all checks
      else !no restart available or possible
        irestart = -abs(irestart)
      end if
    end if

    if (irestart.ge.2) then !read restart if possible
      if (iverb.ge.2) then
        print *, 'Calculation starting from restart file!'
      end if
      call array_read_rstrt(vname,nbasis,nstart,&
  &     basis_vectors(1:nbasis,1:nstart),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'v.rstrt passed checks but failed to read'
          print *, 'error variable = ',ierr
          print *, 'suggestion: delete v.rstrt'
        end if
        ierr = -50
        return ! abort solver, return to call
      end if
    else if (irestart.eq.0) then !! skip savefile check if no restart
      if (iverb.ge.2) then
        print *, 'Calcuation starting from scratch!'
      end if
      associate(interfacing_bv => basis_vectors%element)
        call krylov_guess%lkl_guess(nbasis,nstart,0,&
  &       approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &       ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_guess_subroutine) function failed' 
          print *, 'error variable = ',ierr
        end if
        ierr = -45
        return ! abort solver, return to call
      end if
    else ! save file if it could be useful
      inquire(file=sname,exist=check)
      if (check) then
        call array_read_rstrt_size(sname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no restart available
          ierr = 0
          irestart = -abs(irestart)
        else if (k1.ne.nbasis) then ! sfile not in this basis
          irestart = -abs(irestart)
        else ! sfile passes all checks, using sfile
          if (iverb.ge.2) then
            print *, 'Calculation starting from save file!'
          end if
          if (k2.gt.nstart) then ! read in only up to nstart vecs
            k2 = nstart
          end if
          call array_read_rstrt(sname,nbasis,k2,&
  &           basis_vectors(1:nbasis,1:k2),iverb,ierr)
          if (ierr.ne.0) then
            if (iverb.ge.0) then
              print *, 'v.save passed checks but failed to read'
              print *, 'error variable = ',ierr
              print *, 'suggestion: delete v.save'
            end if
            ierr = -50
            return ! abort solver, return to call
          end if
          if (k2.eq.nstart) then ! no new initial vectors needed
            if (iverb.ge.2) then
              print *, ' with no new vectors needed!'
            end if
!! NAMBI : HERE IS WHERE to put restart from non converged calculation?
          else ! more initial vectors needed
            if (iverb.ge.2) then
              print *, ' generating more start vectors!'
            end if
            associate(interfacing_bv => basis_vectors%element)
              call krylov_guess%lkl_guess(nbasis,nstart,k2,&
  &             approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &             ierr)
            end associate
            if (ierr.ne.0) then
              if (iverb.ge.0) then
                print *, 'class(user_krylov_guess_subroutine) function failed' 
                print *, 'error variable = ',ierr
              end if
              ierr = -45
              return ! abort solver, return to call
            end if
          end if
        end if
      else !no save file
!! Fresh starting basis vectors generated if 
!! conditions are met.
        irestart = -abs(irestart)
        if (iverb.ge.2) then
          print *, 'Calculation starting from scratch!'
        end if
        associate(interfacing_bv => basis_vectors%element)
          call krylov_guess%lkl_guess(nbasis,nstart,0,&
  &         approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &         ierr)
        end associate
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'class(user_krylov_guess_subroutine) function failed' 
            print *, 'error variable = ',ierr
          end if
          ierr = -45
          return ! abort solver, return to call 
        end if
      end if
    end if


! print restart basis-vector products if required
    if (irestart.le.-2) then
      call array_print_rstrt(vname,nbasis,nsubspace,&
  &       basis_vectors(1:nbasis,1:nsubspace),iverb,ierr)
      ierr = 0
    end if


!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! determine overlap
    call ggemm('c','n',nstart,nstart,nbasis,one_kb,&
  &    basis_vectors(1:nbasis,1:nstart),nbasis,&
  &    basis_vectors(1:nbasis,1:nstart),nbasis,&
  &    zero_kb,&
  &    overlap(1:nstart,1:nstart),&
  &    nstart)
!! determine diag_overlap
    do j = 1 , nstart
      diag_overlap(j) = overlap(j,j)
    end do
    call krylov_cholesky(nsubspace,overlap(1:nsubspace,1:nsubspace),&
  &    diag_overlap(1:nsubspace),& 
  &    cholesky(1:nsubspace,1:nsubspace),iverb,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'initial overlap matrix failed cholesky decomposition' 
        print *, 'error variable = ',ierr
      end if
      ierr = -45
      return ! abort solver, return to call 
    end if

!! if restart from mvp is allowed, look for restart w files
!! invert irestart to generate new basis vectors
    if (irestart.ge.3) then
      inquire(file=wname,exist=check)
      if (check) then
        call array_read_rstrt_size(wname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no wfile
          irestart = -abs(irestart)
          ierr = 0
        else if (k1.ne.nbasis) then ! wfile not in this basis
          irestart = -abs(irestart)
        else if (k2.gt.nstart) then ! wfile not matching vfile?
          irestart = -abs(irestart)
        end if
      else ! no wfile
        irestart = -abs(irestart)
      end if
    end if

    if (irestart.le.2) then  !! need to generate new MVP
! call user defined matrix vector product for the first time
      if (iverb.ge.2) then
        print *, ' Fresh Matrix Vector Products!'
      end if
      associate(interfacing_bv => basis_vectors%element,&
  &             interfacing_mv => mvproduct%element)
      call krylov_mvp%lkl_mvp(nbasis,nsubspace,&
  &     interfacing_bv(1:nbasis,1:nsubspace),&
  &     interfacing_mv(1:nbasis,1:nsubspace),ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_mvp_subroutine) function failed' 
          print *, 'before the first iteration'
          print *, 'error variable = ',ierr
        end if
        ierr = -45
        return ! abort solver, return to call
      end if
! print restart matrix-vector products if required
      if (irestart.le.-3) then
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        ierr = 0
      end if
    else ! can read MVP restart, read it!
      if (iverb.ge.2) then
        print *, ' Including restart for matrix vector products!'
      end if
      call array_read_rstrt(wname,nbasis,k2,&
  &       mvproduct(1:nbasis,1:k2),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'w.rstrt passed checks but failed to read'
          print *, 'error variable = ',ierr
          print *, 'suggestion: delete w.rstrt'
        end if
        ierr = -50
        return ! abort solver, return to call
      end if
      if (k2.lt.nstart) then
        if (iverb.ge.2) then
          print *, 'assuming w.rstrt is intact and did not update!'
        end if
        associate(interfacing_bv => basis_vectors%element,&
  &               interfacing_mv => mvproduct%element)
          call krylov_mvp%lkl_mvp(nbasis,(nstart-k2),&
  &       interfacing_bv(1:nbasis,(k2+1):nsubspace),&
  &       interfacing_mv(1:nbasis,(k2+1):nsubspace),ierr)
        end associate
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'class(user_krylov_mvp_subroutine) function failed'
            print *, 'before the first iteration'
            print *, 'error variable = ',ierr
          end if
          ierr = -45
          return ! abort solver, return to call
        end if
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        ierr = 0
      end if
    end if

    call krylov_rayleigh(nbasis,nsubspace,&
  &     approx_spectra,mvproduct(1:nbasis,1:nsubspace),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     rayleigh(1:nsubspace,1:nsubspace),iverb,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'initial construction of rayleigh matrix failed' 
        print *, 'error variable = ',ierr
      end if
      ierr = -45
      return ! abort solver, return to call 
    end if

! reset irestart to normal operation
    irestart = abs(irestart)

    if (iverb.ge.1) then
      print *, ''
      print *, 'convergence criteria: 10^(-',threshold,')'
      print *, 'number of desired solutions:  ',nroots
      print *, 'initial subspace:  ',nstart
      print *, 'full vector space: ',nbasis
      print *, 'maximum number of iterations: ',maxiter
      print *, ''
    end if

! SOLVER LOOP
    jter = 0
    do iter = 1, maxiter

! Check for kill file
      inquire(file=kill_file_string,exist=check)
      if (check) then
        if (iverb.ge.0) then
          print *, 'kill file exist, libkrylov killed'
          if (iverb.ge.3) then
            print *, 'kill file is ',kill_file_string
          end if
        end if  
        ierr = -40
        return ! abort solver, return to call
      end if

      jter = jter + 1

      if (iverb.ge.0) then
        print *, '~~~~~Iteration (',iter,')~~~~~'
        if (iverb.ge.1) then
          print *, 'current sub space: ',nsubspace
        end if
      end if

! call krylov ritz subroutine
      call krylov_a_ritz(nbasis,nsubspace,nroots,&
  &     rayleigh(1:nsubspace,1:nsubspace),&
  &     cholesky(1:nsubspace,1:nsubspace),&
  &     overlap(1:nsubspace,1:nsubspace),diag_overlap(1:nsubspace),&
  &     roots,lagrangian,solutions(1:nsubspace,1:nroots),iverb,ierr)
!      call krylov_a_ritz(nbasis,nsubspace,nroots,&
!  &     basis_vectors(1:nbasis,1:nsubspace),&
!  &     mvproduct(1:nbasis,1:nsubspace),&
!  &     overlap(1:nsubspace,1:nsubspace),diag_overlap(1:nsubspace),&
!  &     roots,lagrangian,solutions(1:nsubspace,1:nroots),iverb,ierr)
      if (ierr.eq.-35) then ! error variable for ill-conditioned overlap
        nsubspace = prev_nsubspace
        if (iverb.ge.0) then
          print *, 'preparation for krylov ritz(subspace solve) failed'
          print *, 'error variable = ',ierr
        end if
        if (iter.gt.1) then
          if (iverb.ge.0) then
            print *, 'using previous subspace solutions for print'
          end if
          ierr = 0
        end if
        exit ! This exits subspace loop
      else if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov ritz(subspace solve) calculation failed'
          print *, 'error variable = ',ierr
        end if
        ierr = -40
        exit ! This exits subspace loop
      end if

!! Set constants required for BLAS
      one_kb = real(1,kind=kind_float)
      zero_kb = real(0,kind=kind_float)
!! calculation of solutions on full space
      call ggemm('n','n',nbasis,nroots,nsubspace,one_kb,&
  &      basis_vectors(1:nbasis,1:nsubspace),nbasis,&
  &      solutions(1:nsubspace,1:nroots),nsubspace,&
  &      zero_kb,&
  &      full_solutions(1:nbasis,1:nroots),&
  &      nbasis)

! call krylov norms subroutine
      call krylov_a_norms(nbasis,nsubspace,nroots,&
  &     mvproduct(1:nbasis,1:nsubspace),& 
  &     basis_vectors(1:nbasis,1:nsubspace),full_solutions,& 
  &     solutions(1:nsubspace,1:nroots),&
  &     overlap(1:nsubspace,1:nsubspace),&
  &     roots,approx_spectra,krylov_precon,&
  &     residuals,euc_norm,largest_euc_norm,&
  &     fro_norm,nresiduals,iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov norms calculation failed'
          print *, 'error variable = ',ierr
        end if 
        ierr = -40
        exit ! This exits subspace loop
      end if

! determine convergence of solutions based on euclidean norm
      nconverged = 0
      jconverged = .false.
      do j = 1 , nroots
        if ((-threshold).gt.log10(euc_norm(j))) then
          nconverged = nconverged + 1
          jconverged(j) = .true.
        end if
      end do
      if (iverb.ge.2) then
        print *, 'converged vectors: ', nconverged
      end if

! determine convergence of solutions based on frobenius norm
! The stricter test, this is done before check by euclidean norms
      if ((-threshold).gt.log10(fro_norm)) then
        if (iverb.ge.1) then
          print *, 'Converged by frobenius norm!'
        end if
        exit ! This exits subspace loop
      end if

! determine convergence of solutions based on nconverged
      if (nconverged.ge.nroots) then
        if (iverb.ge.1) then
          print *, 'Converged by euclidean norm!'
        end if
        exit ! This exits subspace loop
      end if

! convergence checks failed when this line is reached
    if (iverb.ge.2) then
      print *, 'More iterations required for desired convergence!'
    end if

! check that more iterations are allowed before extending subspace
      if (iter.eq.maxiter) then
        if (iverb.ge.0) then
          print *, 'failed to converge within max number of iterations'
        end if
        exit ! This exits subspace loop
      end if

! Check that there are residuals to extend the subspace with
      if (nresiduals.eq.0) then
        if (iverb.ge.0) then
          print *, 'No preconditioned residuals above machine precision!'
          print *, 'failed to find vectors to expand subspace!'
        end if
        exit ! This exits subspace loop
      end if

! Check for stop file
      inquire(file=stop_file_string,exist=check)
      if (check) then
        if (iverb.ge.0) then
          print *, 'stop file exist, libkrylov stopped'
          if (iverb.ge.3) then
            print *, 'stop file is ',stop_file_string
          end if
        end if  
        exit ! exit subspace loop
      end if
! spacer
      if (iverb.ge.0) then
        print *, ' '
      end if

!! test normalizing all residuals
!      do j = 1, nresiduals
!        call gdot(nbasis,residuals(1:nbasis,j),1,&
!  &           residuals(1:nbasis,j),1,&
!  &           overlap(j+nsubspace,j+nsubspace),ierr)
!        diag_overlap(j+nsubspace) = overlap(j+nsubspace,j+nsubspace)
!        diag_overlap(j+nsubspace) = sqrt(diag_overlap(j+nsubspace))
!        print *, 'normalizing residual',j
!        residuals(1:nbasis,j) = residuals(1:nbasis,j)/&
!  &         diag_overlap(j+nsubspace)
!      end do

!!! !! orthogonalizing residuals - MGS
!!!       do j = 2, nresiduals
!!!         do k = 1, j-1
!!!           call gdot(nbasis,residuals(1:nbasis,k),1,&
!!!   &             residuals(1:nbasis,k),1,&
!!!   &             overlap(k+nsubspace,k+nsubspace),ierr)
!!!           call gdot(nbasis,residuals(1:nbasis,j),1,&
!!!   &             residuals(1:nbasis,k),1,&
!!!   &             overlap(k+nsubspace,j+nsubspace),ierr)
!!!           if (iverb.ge.4) then
!!!             print *, 'inner product of residual: ', j
!!!             print *, ' and residual: ',k
!!!             print *, overlap(k+nsubspace,j+nsubspace)
!!!           end if
!!!           residuals(1:nbasis,j) = &
!!!   &              residuals(1:nbasis,j) -&
!!!   &              (residuals(1:nbasis,k)*&
!!!   &              overlap(k+nsubspace,j+nsubspace)/&
!!!   &              overlap(k+nsubspace,k+nsubspace))
!!!         end do
!!!       end do

!! orthogonalization via QR, have k hold nresiduals as input
      k = nresiduals
      call krylov_orthogonalize(nbasis,k,residuals(1:nbasis,1:k),&
  &       nresiduals,iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'optimizing new basis vectors failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        nsubspace = prev_nsubspace
        ierr = 0
        exit ! This exits subspace loop
      end if

!!! !! test orthonalization all residuals
!!!       print *, 'post orthogonalization norms'
!!!       do j = 1, nresiduals
!!!         call gdot(nbasis,residuals(1:nbasis,j),1,&
!!!   &             residuals(1:nbasis,j),1,&
!!!   &             overlap(j+nsubspace,j+nsubspace),ierr)
!!!         diag_overlap(j+nsubspace) = overlap(j+nsubspace,j+nsubspace)
!!!         diag_overlap(j+nsubspace) = sqrt(diag_overlap(j+nsubspace))
!!!         print *, 'o norms',j,diag_overlap(j+nsubspace)
!!!       end do

!! project residuals out of subspace
      call krylov_project(nbasis,nsubspace,nroots,&
  &     diag_overlap(1:nsubspace),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     cholesky(1:nsubspace,1:nsubspace),&
  &     residuals(1:nbasis,1:nroots),&
  &     iverb,ierr)

!! test results of projection all residuals
      print *, 'post projection norms'
      k = 1
      do j = 1, nresiduals
        call gdot(nbasis,residuals(1:nbasis,j),1,&
  &             residuals(1:nbasis,j),1,&
  &             overlap(j+nsubspace,j+nsubspace),ierr)
        diag_overlap(j+nsubspace) = overlap(j+nsubspace,j+nsubspace)
        diag_overlap(j+nsubspace) = sqrt(diag_overlap(j+nsubspace))
        print *, 'p norms',j,diag_overlap(j+nsubspace)
        if (diag_overlap(j+nsubspace).gt.eps) then
          residuals(1:nbasis,k) = residuals(1:nbasis,j)
          k = k + 1
        end if
      end do
      nresiduals = k - 1


! call krylov extend subroutine, after saving prev_nsubspace
      prev_nsubspace = nsubspace
      nsubspace = nsubspace + nresiduals  
      call krylov_extend(nbasis,nsubspace,&
  &     nresiduals,prev_nsubspace,&
  &     residuals(1:nbasis,1:nresiduals),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     overlap(1:nsubspace,1:nsubspace),&
  &     diag_overlap(1:nsubspace),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov subspace expansion failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        nsubspace = prev_nsubspace
        ierr = 0
        exit ! This exits subspace loop
      end if

      if (iverb.ge.4) then
        do j = 1, nresiduals
          do k = 1, nsubspace
            print *, 'inner product of residual: ', j
            print *, ' and basis vector: ',k
            print *, overlap(k,j+nsubspace)
          end do
        end do
      end if

! call for diagonalization of copy of overlap matrix as a check,
! if it passes proceed to expand subspace properly
!      call krylov_check(nsubspace,&
!  &       overlap(1:nsubspace,1:nsubspace),&
!  &       diag_overlap(1:nsubspace),iverb,ierr)
      call krylov_cholesky(nsubspace,&
  &      overlap(1:nsubspace,1:nsubspace),&
  &      diag_overlap(1:nsubspace),& 
  &      cholesky(1:nsubspace,1:nsubspace),iverb,ierr)
      if (ierr.eq.-30) then !krylov check failed, attempt rescue
        if (iverb.ge.0) then
          print *, 'new krylov subspace unstable'
          print *, 'error variable = ',ierr
          print *, 'skipping attempts to stabilize'
          print *, 'new krylov subspace failed stability check'
          print *, 'using previous subspace solutions for print'
        end if
        ierr = 0
        nsubspace = prev_nsubspace
        exit ! this exits subspace loop

!!!! !!!!  Drastic restart implementation, not used for now.

!!!!         ierr = 0
!!!! !! Putting X(full solutions) as new previous V(basis)
!!!!         basis_vectors(1:nbasis,1:nroots) = &
!!!!   &      full_solutions(1:nbasis,1:nroots)
!!!! !! set nsubspace to new value
!!!!         nsubspace = nroots+nresiduals
!!!!         prev_nsubspace = nroots
!!!! !! Set constants required for BLAS
!!!!         one_kb = real(1,kind=kind_float)
!!!!         zero_kb = real(0,kind=kind_float)
!!!! !! determine old part of new overlap
!!!!         call ggemm('c','n',nroots,nroots,nbasis,one_kb,&
!!!!   &       basis_vectors(1:nbasis,1:nroots),nbasis,&
!!!!   &       basis_vectors(1:nbasis,1:nroots),nbasis,&
!!!!   &       zero_kb,&
!!!!   &       overlap(1:nroots,1:nroots),&
!!!!   &       nroots)
!!!!         do j = 1, nroots
!!!!           diag_overlap(j) = overlap(j,j)
!!!!         end do
!!!! !! re-extend
!!!!         call krylov_extend(nbasis,nsubspace,&
!!!!   &       nresiduals,prev_nsubspace,&
!!!!   &       residuals(1:nbasis,1:nresiduals),&
!!!!   &       basis_vectors(1:nbasis,1:nsubspace),&
!!!!   &       overlap(1:nsubspace,1:nsubspace),&
!!!!   &       diag_overlap(1:nsubspace),iverb,ierr)
!!!!         if (ierr.ne.0) then
!!!!           if (iverb.ge.0) then
!!!!             print *, 'new krylov subspace expansion failed'
!!!!             print *, 'error variable = ',ierr
!!!!             print *, 'using previous subspace solutions for print'
!!!!           end if
!!!!           nsubspace = prev_nsubspace
!!!!           ierr = 0
!!!!           exit ! This exits subspace loop
!!!!         end if
!!!!         prev_nsubspace = nroots
!!!!         call krylov_cholesky(nsubspace,&
!!!!   &       overlap(1:nsubspace,1:nsubspace),&
!!!!   &       diag_overlap(1:nsubspace),& 
!!!!   &       cholesky(1:nsubspace,1:nsubspace),iverb,ierr)
!!!! !        call krylov_check(nsubspace,&
!!!! !  &         overlap(1:nsubspace,1:nsubspace),&
!!!! !  &         diag_overlap(1:nsubspace),iverb,ierr)
!!!!         if (ierr.eq.0) then !! if rescue worked
!!!!           if (iverb.ge.0) then
!!!!             print *, 'stabilization may have worked'
!!!!             print *, 'please observe condition number'
!!!!             print *, 'continuing iterations'
!!!!           end if
!!!!         else
!!!!           if (iverb.ge.0) then
!!!!             print *, 'rescued subspace still failed stability check'
!!!!             print *, 'error variable = ',ierr
!!!!             print *, 'using previous subspace solutions for print'
!!!!           end if
!!!!           ierr = 0
!!!!           nsubspace = prev_nsubspace
!!!!           exit ! This exits subspace loop
!!!!         end if
!!!! ! call user defined matrix vector product
!!!!         associate(interfacing_bv => basis_vectors%element,&
!!!!   &             interfacing_mv => mvproduct%element)
!!!!           call krylov_mvp%lkl_mvp(nbasis,prev_nsubspace,&
!!!!   &         interfacing_bv(1:nbasis,1:prev_nsubspace),&
!!!!   &         interfacing_mv(1:nbasis,1:prev_nsubspace),ierr)
!!!!         end associate
!!!!         if (ierr.ne.0) then
!!!!           if (iverb.ge.0) then
!!!!             print *, 'class(libkrylov_mvp_subroutine) function failed'
!!!!             print *, 'error variable = ',ierr
!!!!             print *, 'using previous subspace solutions for print'
!!!!           end if
!!!!           ierr = 0
!!!!           nsubspace = prev_nsubspace
!!!!           exit ! This exits subspace loop
!!!!         end if

      else if (ierr.ne.0) then !krylov_check failed irrecoverably
        if (iverb.ge.0) then
          print *, 'new krylov subspace failed stability check'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        nsubspace = prev_nsubspace
        ierr = 0
        exit ! This exits subspace loop
      end if

! call user defined matrix vector product
      associate(interfacing_bv => basis_vectors%element,&
  &           interfacing_mv => mvproduct%element)
        call krylov_mvp%lkl_mvp(nbasis,nresiduals,&
  &       interfacing_bv(1:nbasis,(prev_nsubspace+1):nsubspace),&
  &       interfacing_mv(1:nbasis,(prev_nsubspace+1):nsubspace),ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(libkrylov_mvp_subroutine) function failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        ierr = 0
        nsubspace = prev_nsubspace
        exit ! This exits subspace loop
      end if

! print restart basis-vectors if required
      if (irestart.ge.2) then
        call array_print_rstrt(vname,nbasis,nsubspace,&
  &         basis_vectors(1:nbasis,1:nsubspace),iverb,ierr)
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'unable to print v restart files'
            ierr = 0
          end if
        end if
      end if
! print restart if required
      if (irestart.ge.3) then
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'unable to print w restart files'
            ierr = 0
          end if
        end if
      end if

! expand rayleigh matrix
      call krylov_expand(nbasis,nsubspace,&
  &     nresiduals,prev_nsubspace,&
  &     approx_spectra,mvproduct(1:nbasis,1:nsubspace),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     rayleigh(1:nsubspace,1:nsubspace),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'expanding rayleigh matrix failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        ierr = 0
        nsubspace = prev_nsubspace
        exit ! This exits subspace loop
      end if


    end do ! krylov subspace loop ends

! spacer
    if (iverb.ge.0) then
      print *, ' '
        if (iverb.ge.2) then
          print *, 'number of iterations: ',jter
          print *, ' '
        end if
    end if

! Check for kill file
    inquire(file=kill_file_string,exist=check)
    if (check) then
      if (iverb.ge.0) then
        print *, 'kill file exist, libkrylov killed'
        if (iverb.ge.3) then
          print *, 'kill file is ',kill_file_string
        end if
      end if  
      ierr = -40
      return ! abort solver, return to call
    end if

!  check status of calculation, call appropriate ending tasks
    if (ierr.ne.0) then ! serious error somewhere in the calculation
      if (iverb.ge.0) then
        print *, 'quality of values unknown,'
        print *, 'old save file not overwritten,'
        print *, 'class(libkrylov_a_output_subroutine) not called'
      end if
    else ! iterations exited with no serious errors, possible useful data!
      if (irestart.ge.1) then ! user asked for save files
        call array_print_rstrt(sname,nbasis,nroots,&
  &       full_solutions(1:nbasis,1:nroots),iverb,ierr)
        if (ierr.eq.0) then ! save file printed! safe to delete restart
          if (irestart.ge.2) then
            call array_del_rstrt(vname,iverb,ierr) 
              ! no check for ierr, no action on fail
            ierr = 0
            if (irestart.ge.3) then
              call array_del_rstrt(wname,iverb,ierr)
              ! no check for ierr, no action on fail
            ierr = 0
            end if
          end if
        else ! something wrong with printing save, don't delete files
          if (iverb.ge.0) then
            print *, 'unable to print save file'
          end if
!reset ierr, no matter what happened in restart
          ierr = 0
        end if
      end if
!! call user output function
      associate(interfacing_lg => lagrangian%element,&
  &             interfacing_fs => full_solutions%element)
        call krylov_output_a%lkl_output_a(nbasis,nsubspace,nroots,&
  &       nconverged,jconverged,&
  &       roots(1:nroots),interfacing_lg(1:nroots),&
  &       interfacing_fs(1:nbasis,1:nroots),&
  &       euc_norm(1:nroots),fro_norm,id_string,ierr)
      end associate
!! final ierr check and adjustments
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_output_subroutine) function failed'
        end if
        ierr = -20
      else if (nconverged.le.0) then !only if ierr .eq. 0
        if (iverb.ge.0) then
          print *, 'solver produced no solutions' 
        end if
        ierr = -15
      else if (nconverged.lt.nroots) then 
!< only if ierr.eq.0.and.nconverged.gt.0 
        if (iverb.ge.1) then
          print *, 'not all desired solutions produced'
          print *, 'ierr contains number of solutions printed'
        end if
        ierr = nconverged
      end if
    end if

    deallocate(basis_vectors)
    deallocate(mvproduct)
    deallocate(approx_spectra)
    deallocate(lagrangian)
    deallocate(solutions)
    deallocate(full_solutions)
    deallocate(overlap)
    deallocate(cholesky)
    deallocate(rayleigh)
    deallocate(roots)
    deallocate(diag_overlap)
    deallocate(residuals)
    deallocate(euc_norm)
    deallocate(jconverged)

    if (iverb.ge.0) then
      print *, '////////////////////////////////////////////////'
      print *, 'Solver Done'
      print *, '////////////////////////////////////////////////'
    end if

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_a_solver
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine krylov_b_ritz(nbasis,nsubspace,nrhs,&
  &     rayleigh,&
  &     cholesky,proj_rhs,&
  &     overlap,diag_overlap,&
  &     lagrangian,solutions,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the ritz step of a krylov solve,
!< producing guess/approximate solutions of the linear problem
!< in the subspace basis
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace
    integer(kind_integer), intent(in) :: nrhs
    type(base), intent(in) :: rayleigh(nsubspace,nsubspace)
    type(base), intent(in) :: cholesky(nsubspace,nsubspace)
    type(base), intent(in) :: proj_rhs(nsubspace,nrhs)
    type(base), intent(in) :: overlap(nsubspace,nsubspace)
    real(kind_float), intent(in) :: diag_overlap(nsubspace)
!--------------------------------------------------------------------
! Output Variables
!--------------------------------------------------------------------
    type(base), intent(inout) :: lagrangian(nrhs)
    type(base), intent(inout) :: solutions(nsubspace,nrhs)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb   
    integer(kind_integer), intent(inout) :: ierr   
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
    type(base), allocatable :: subspace(:,:)
    type(base), allocatable :: scaled_rhs(:,:)
    type(base), allocatable :: vavx(:,:)
    type(base) :: expectation
    type(base) :: norm
    type(base) :: rhs_with_x
    type(base) :: x_with_rhs
    real(kind_float), allocatable :: d_o_sqrt(:)
!! integer for linear solve
    integer(kind_integer),allocatable :: ipiv(:)
!! integer for loops
    integer(kind_integer) :: j,k,l,m = 0
!--------------------------------------------------------------------

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)

!! Allocate local arrays
    allocate(subspace(nsubspace,nsubspace))
    allocate(d_o_sqrt(nsubspace))
    allocate(scaled_rhs(nsubspace,nrhs))
    allocate(ipiv(nsubspace))
    allocate(vavx(nsubspace,nrhs))

!! construct d_o_sqrt
    d_o_sqrt = sqrt(diag_overlap)

!! scale subspace(rayleigh) with norms
    do k = 1, nsubspace
      do j = 1, nsubspace
        if (j.eq.k) then
          subspace(j,j) = rayleigh(j,j)/diag_overlap(j)
        else
          subspace(j,k) = rayleigh(j,k)/(d_o_sqrt(j)*d_o_sqrt(k))
        end if
      end do
    end do

!! scale rhs
    do k = 1, nrhs
      do j = 1, nsubspace
        scaled_rhs(j,k) = proj_rhs(j,k)/d_o_sqrt(j)
      end do
    end do

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
!! scale subspace(rayleigh) with cholesky
    call gtrsm('r','l','c','n',nsubspace,nsubspace,one_kb,&
  &   cholesky,nsubspace,subspace,nsubspace)
    one_kb = real(1,kind=kind_float)
    call gtrsm('l','l','n','n',nsubspace,nsubspace,one_kb,&
  &   cholesky,nsubspace,subspace,nsubspace)

!!scale rhs with cholesky
    one_kb = real(1,kind=kind_float)
    call gtrsm('l','l','n','n',nsubspace,nrhs,one_kb,&
  &   cholesky,nsubspace,scaled_rhs,nsubspace)

! move scaled rhs onto solutions
    solutions = scaled_rhs
!! solve for solutions onto solutions
    call ghesv('l',nsubspace,nrhs,subspace,nsubspace,ipiv,&
  &     solutions,nsubspace,ierr)
    if (iverb.ge.5) then
      print *, 'ipiv from solve :'
      print *, ipiv
    end if
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, '*hesv/*sysv linear algebra error!', ierr
        print *, 'exit ritz step'
      end if
      ierr = -40
      return ! return to solver loop
    end if 

!! reverse cholesky on solutions
!! UNKNOWN BUG, ONE CHANGES VALUE, FIX SOON
    one_kb = real(1,kind=kind_float)
    call gtrsm('l','l','c','n',nsubspace,nrhs,one_kb,&
  &   cholesky,nsubspace,solutions,nsubspace)

!! reverse scaling to get solutions
    do j = 1, nrhs
      do k = 1, nsubspace
        solutions(k,j) = solutions(k,j)/d_o_sqrt(k)
      end do
    end do

!! compute lagrangian
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! compute vavx 
    call ggemm('n','n',nsubspace,nrhs,nsubspace,&
  &   one_kb,rayleigh,nsubspace,&
  &   solutions,nsubspace,zero_kb,&
  &   vavx,nsubspace)
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
    if (iverb.ge.2) then
      print *, 'lagrangians of desired solutions:' 
    end if
    do j = 1, nrhs
      call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &     vavx(1:nsubspace,j),1,expectation,ierr)
      call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &     proj_rhs(1:nsubspace,j),1,x_with_rhs,ierr)
      call gdot(nsubspace,proj_rhs(1:nsubspace,j),1,&
  &     solutions(1:nsubspace,j),1,rhs_with_x,ierr)
      lagrangian(j) = expectation&
  &     - rhs_with_x - x_with_rhs
      if (iverb.ge.2) then
        print *, 'L of ',j,' rhs: ',lagrangian(j)
      end if
    end do

! Deallocate local arrays
    deallocate(vavx)
    deallocate(ipiv)
    deallocate(scaled_rhs)
    deallocate(subspace)
    deallocate(d_o_sqrt)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine krylov_b_ritz
!--------------------------------------------------------------------
!--------------------------------------------------------------------


!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine krylov_b_norms(nbasis,nsubspace,nrhs,&
  &     mvproduct,basis_vectors,full_solutions,solutions,&
  &     overlap,rhs,&
  &     approx_spectra,krylov_precon,residuals,&
  &     euc_norm,largest_euc_norm,fro_norm,&
  &     nresiduals,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the norms step of a krylov solve,
!< producing the residual norms of the approximate solutions.
!< to save computational power the residuals are passed out 
!< from this routine as well.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace
    integer(kind_integer), intent(in) :: nrhs
    type(base), intent(in) :: mvproduct(nbasis,nsubspace)
    type(base), intent(in) :: basis_vectors(nbasis,nsubspace)
    type(base), intent(in) :: full_solutions(nbasis,nrhs)
    type(base), intent(in) :: solutions(nsubspace,nrhs)
    type(base), intent(in) :: overlap(nsubspace,nsubspace)
    type(base), intent(in) :: rhs(nbasis,nrhs)
    real(kind_float), intent(in) :: approx_spectra(nbasis)
    class(libkrylov_precon_subroutine) :: krylov_precon
!--------------------------------------------------------------------
! Output Variables
!--------------------------------------------------------------------
    type(base), intent(inout) :: residuals(nbasis,nrhs)
    real(kind_float), intent(inout) :: euc_norm(nrhs)
    real(kind_float), intent(inout) :: largest_euc_norm
    real(kind_float), intent(inout) :: fro_norm
    integer(kind_integer), intent(inout) :: nresiduals
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb   
    integer(kind_integer), intent(inout) :: ierr   
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
    type(base), allocatable :: all_residuals(:,:)
    type(base), allocatable :: all_solutions(:,:)
    real(kind_float), allocatable :: all_omega(:) !for generic interface
    logical, allocatable :: eps_converged(:)
    real(kind_float) :: lognbasis
    integer(kind_integer) :: ntemp ! n of all_residuals
    type(base), allocatable :: xo(:,:)
    type(base), allocatable :: vxo(:,:)
    type(base), allocatable :: euc_sq(:)
    real(kind_float) :: res_temp
!    integer(kind_float) :: ptest = 0 ! preconditioner test
!! integer for loops
    integer(kind_integer) :: j,k,l,m,n = 0
!--------------------------------------------------------------------

! Allocate local arrays
    allocate(all_residuals(nbasis,nrhs))
    allocate(all_solutions(nbasis,nrhs))
    allocate(eps_converged(nrhs))
    allocate(euc_sq(nrhs))
    allocate(all_omega(nrhs))

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! calculate matrix vector products of the approximate solutions
!! in the representation of the full basis, aka avx, on residuals
    call ggemm('n','n',nbasis,nrhs,nsubspace,&
  &   one_kb,mvproduct,nbasis,&
  &   solutions,nsubspace,zero_kb,&
  &   all_residuals,nbasis)
!! make residuals = avx-rhs
    all_residuals = all_residuals - rhs

!! get inner product of residual with itself
    do j = 1, nrhs
      call gdot(nbasis,all_residuals(1:nbasis,j),1,&
  &     all_residuals(1:nbasis,j),1,euc_sq(j),ierr)
    end do

!! assign type(base) to real
    euc_norm = euc_sq
    do j = 1, nrhs
      if (euc_norm(j).lt.real(0,kind=kind_float)) then
        if (iverb.ge.0) then
          print *, 'square of ',j,' euclidean norm less than zero!'
          print *, 'exit norm step'
        end if
        ierr = -40
        return ! return to solver loop
      end if 
    end do
!! sum real euc_norm(squared) onto real fro_norm
    fro_norm = sum(euc_norm)
!! no check if fro_norm is positive, since it is a sum of positives

!! square root to get fro norm
    fro_norm = sqrt(fro_norm)
    if (iverb.ge.3) then
      print *, 'frobenius norm: ',fro_norm
    end if

!! square root to get euc norm*roots
    euc_norm = sqrt(euc_norm)

    lognbasis = log10(real(nbasis,kind=kind_float))
!! compare euc_norm to logeps+lognbasis, 
!! set eps_converged and nresiduals
    eps_converged = .false.
    ntemp = nrhs
    do j = 1, nrhs
      if (log10(euc_norm(j)).lt.(logeps)) then
        eps_converged(j) = .true.
        ntemp = ntemp - 1
      end if
    end do
    if (iverb.ge.3) then
      print *, 'number of residuals before precondition: ',ntemp
    end if

!! find largest euc_norm
    largest_euc_norm = maxval(euc_norm)
    if (iverb.ge.3) then
      print *, 'largest euclidean norm: ',largest_euc_norm
      if (iverb.ge.4) then
        do j = 1,nrhs
          print *, j,' euclidean norm: ',euc_norm(j)
        end do
      end if
    end if

!! return to calling subroutine if there are no residues
!! above machine precision
    if (ntemp.eq.0) then
      nresiduals = 0
      return
    end if

!! eliminate residuals that have reached machine convergence
    if (ntemp.lt.nrhs) then
      l = 0 ! cycle over not converged residuals
      do k = 1, nrhs
        if (.not.eps_converged(k)) then
          l = l + 1
          all_residuals(1:nbasis,l) = all_residuals(1:nbasis,k)
          all_solutions(1:nbasis,l) = full_solutions(1:nbasis,k)
! rhs not needed for preconditioning
        end if
      end do
      all_omega(1:ntemp) = real(0,kind=kind_float)
    else ! all residuals above machine precision
      all_omega = real(0,kind=kind_float)
      all_solutions = full_solutions
! rhs not needed for preconditioning
! no shifting for all_residuals' index
    end if

!! Precondition with input function!
    associate(interfacing_fs => all_solutions%element,&
  &            interfacing_rd => all_residuals%element)
      call krylov_precon%lkl_precon(nbasis,ntemp,nsubspace,&
  &     approx_spectra,&
  &     all_omega(1:ntemp),interfacing_fs,&
  &     interfacing_rd(1:nbasis,1:ntemp),ierr)
    end associate

    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_precon_subroutine) function failed'
        print *, 'error variable = ',ierr
        print *, 'exit norm step'
      end if
      ierr = -40
      return ! return to solver loop
    end if



!! set log of nbasis
    lognbasis = log10(real(nbasis,kind=kind_float))

!! reset eps_converged, check norms of preconditioned residuals
!! reuse euc_sq,eps_converged, value of euc_sq lost!
    eps_converged = .false.
    nresiduals = ntemp
    do j = 1, ntemp
!! generate norm squared of preconditioned residual
      call gdot(nbasis,all_residuals(1:nbasis,j),1,&
  &     all_residuals(1:nbasis,j),1,euc_sq(j),ierr)
!! make norm squared real(kind_float)
      res_temp = euc_sq(j)
!! check that norm is positive
      if (res_temp.lt.real(0,kind=kind_float)) then
        if (iverb.ge.0) then
          print *, 'square of ',j,' residual norm'
          print *, 'less than zero after preconditioning'
          print *, 'exit norm step'
        end if
        ierr = -40
        return ! return to solver loop
      end if
!! get norm
      res_temp = sqrt(res_temp)
!! check that norm is larger than (logeps+lognbasis)
      if (log10(res_temp).lt.(logeps)) then
        eps_converged(j) = .true.
        nresiduals = nresiduals - 1
      end if
      if (iverb.ge.4) then
        print *, j,' preconditioned residual norm: ',res_temp
      end if
    end do
    if (iverb.ge.3) then
      print *, 'number of preconditioned residuals: ',nresiduals
    end if

!! store preconditioned residuals on output array
    l = 0 ! cycle over all not converged preconditioned residuals
    if(ntemp.eq.nresiduals) then
      residuals(1:nbasis,1:nresiduals) = &
  &     all_residuals(1:nbasis,1:nresiduals)
    else
      do k = 1, ntemp
        if (.not.eps_converged(k)) then
          l = l + 1
          residuals(1:nbasis,l) = all_residuals(1:nbasis,k)
        end if
      end do
      ierr = -10
    end if

! Deallocate local arrays
    deallocate(all_residuals)
    deallocate(all_omega)
    deallocate(eps_converged)
    deallocate(euc_sq)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine krylov_b_norms
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine problem_b_solver(krylov_approx,krylov_start,krylov_rhs,&
    & krylov_problem_b,krylov_guess,&
    & krylov_mvp,krylov_precon,krylov_output_b,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine solves a problem with the form 'problem_b'
!< with the non-orthonormal krylov subspace method

  !< This subroutine requires the following 
  !< user-defined subroutines:
  !< krylov_approx for the approximate spectra
  !< krylov_start for determining number of start vectors
  !< krylov_rhs for the right hand side
  !< krylov_problem  for details of the problem
  !< krylov_guess for initializing more guess vectors and their
  !< overlap
  !< krylov_mvp for matrix vector products
  !< krylov_precon for preconditioning
  !< krylov_output for what to do with the eigenvectors
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! parameters for precision based on real(kind_float)
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
    use libkrylovinterface !! Nambi?
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_subroutine) ::    krylov_approx
    class(libkrylov_start_subroutine) ::     krylov_start
    class(libkrylov_matrix_subroutine) ::    krylov_rhs
    class(libkrylov_problem_b_subroutine) :: krylov_problem_b
    class(libkrylov_guess_subroutine) ::     krylov_guess
    class(libkrylov_mvp_subroutine) ::       krylov_mvp
    class(libkrylov_precon_subroutine) ::    krylov_precon
    class(libkrylov_output_b_subroutine) ::  krylov_output_b
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
! Split into sections for easier reading
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! variable for error variable
    integer(kind_integer), intent(inout) :: ierr
!! integer for loops
    integer(kind_integer) :: j = 0
!! integer for restart files
    integer(kind_integer) :: k1,k2 = 0
!! integer for iteration counting
    integer(kind_integer) :: jter = 0
!! logical to pass a logic check as an argument
    logical :: check = .false.
!! constants of type base
    type(base) :: one_kb
    type(base) :: zero_kb
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! info to be created by the krylov_b_problem and not changed after
! most of these are used to allocate type(array)
! THESE DEFAULT VALUES SHOULD BE OVERWRITTEN BY DRIVERS
    integer(kind_integer) :: nbasis,minstart,maxstart,nrhs = 1
!< size of basis = nbasis = n
!< number of guess solutions = nstart = q(1)
!< number of rhs-sides that are given to the solver = nrhs
!< determines size of rhs
    real(kind_float) :: threshold = real(8,kind=kind_float)
!< threshold = x , numerical approximation 10^(-x)>n~0
!< only for user convergence thresholds
    integer(kind_integer) :: maxiter = 25
!< maximum number of subspace iterations 
    character(len=22) :: id_string = 'libkrylov_b'
!< id = ID of the calculation
!< used only for dumping output
    integer(kind_integer) :: iverb = 0
!< verbosity level
    integer(kind_integer) :: irestart = 0
!< restart level (how often restart is dumped on disk,
!< and what is checked)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! The following are determined from the output of krylov%problem
    integer(kind_integer) :: nstart = 0
!< nstart = starting subspace
    integer(kind_integer) :: nsubspace = 0
!< size of subspace, extended in krylov_a_extend = nsubspace
    integer(kind_integer) :: maxsubspace = 0
!< max size of subspace
    character(len=32) :: vname = ''
!< file names for unformatted basis_vector restart file
    character(len=32) :: wname = ''
!< file names for unformatted matrix vector product restart file
    character(len=32) :: rname = ''
!< file names for unformatted rhs restart file
    character(len=32) :: sname = ''
!< file names for unformatted solutions save file
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! Arrays that are allocated after krylov problem
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in with the guess of the spectrum
    real(kind_float), allocatable :: approx_spectra(:)
!< approximation of spectra of problem = approx_spectra = D
    real(kind_float), allocatable :: omega(:) 
!< frequencies to be solved for = omega
    type(base), allocatable :: rhs(:,:)
!< RHS of problem = rhs = P
    logical, allocatable :: jconverged(:)
!< logical for determining which roots are converged
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in with before iterations, expanded in expand
    type(base), allocatable :: basis_vectors(:,:)
    type(base), allocatable :: overlap(:,:)
    real(kind_float), allocatable :: diag_overlap(:)
    type(base), allocatable :: cholesky(:,:)
!< basis_vectors = transformation matrix/projector onto subspace /guess vectors = V 
!< overlap = overlap matrix, (V**dagger)(V)
!< diag_overlap = diagonal of overlap matrix, (V**dagger)(V)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    integer(kind_integer) :: iter
!< variable for do loop over iterations of krylov subspace
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at matrix vector products
    type(base), allocatable :: mvproduct(:,:)
!< AV = matrix vector products = mvproduct
    type(base), allocatable :: proj_rhs(:,:)
!< (V^T)P = projected rhs = proj_rhs  
    type(base), allocatable :: rayleigh(:,:)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at krylov_b_ritz
    type(base), allocatable ::  solutions(:,:)
    type(base), allocatable ::  lagrangian(:)
!< solutions = eigenvectors of current subspace calculation that are relevant = x
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at between ritz and norms
    type(base), allocatable :: full_solutions(:,:)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at krylov_b_norms
    type(base), allocatable :: residuals(:,:)
    real(kind_float), allocatable :: euc_norm(:)
    real(kind_float) :: fro_norm
    real(kind_float) :: largest_euc_norm
    integer(kind_integer) :: nresiduals = 0
!< residuals = preconditioned residuals of the approximate solutions 
!< on the full space = \tilde{R}
!< euc_norm = residual euclid norms of eigenvectors
!< max_euc_norm =  max residual euclid norms of eigenvectors
!< fro_norm = residual frobius norms of desired eigenvectors
!< nresiduals = number of non-zero residuals in the current iteration = nresidue
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at convergence check
    integer(kind_integer) :: nconverged = 0
!< number of converged solutions = nconverged
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in before extend
    integer(kind_integer) :: prev_nsubspace = 0
!< u = old q from previous iteration = prev_nsubspace
!--------------------------------------------------------------------

!! Begin solver!
    ierr = 0

  ! Determine details of davidson problem to be solved
  ! USER-DEFINED FUNCTION
    call krylov_problem_b%lkl_problem_b(nbasis,nrhs,&
  &   minstart,maxstart,threshold,maxiter,&
  &   id_string,iverb,irestart,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_b_problem_subroutine) function failed'
        print *, 'error variable = ',ierr
      end if  
      ierr = -65
      return ! abort solver, return to call
    end if

  if (iverb.ge.0) then
    print *, '////////////////////////////////////////////////'
    print *, 'Non-Orthonormal Krylov Subspace Solver'
    print *, '////////////////////////////////////////////////'
    print *, ' Solving problem type problem_b'
    print *, '////////////////////////////////////////////////'
    print *, ' '
    if (iverb.ge.3) then
      print *, 'Compiler details:'
      print *, 'The basetype is " ',basetype_string,' "'
      print *, 'With precision " ',float_print_string,' "'
      print *, 'with machine precision ',eps
      print *, 'and log10 of machine precision is ',logeps
      print *, ' '
    end if
  end if

! check threshold is above machine precision
    if (-threshold.lt.logeps) then
      if (iverb.ge.0) then
        print *, 'threshold below machine precision, solving failed'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if

! ensure nrhs are less than the basis size
    if (nrhs.gt.nbasis) then
      if (iverb.ge.4) then
        print *, 'desired roots more than basis, solving failed'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if

! force starting subspace to be at most equal to nbasis
    if (maxstart.gt.nbasis) then
      maxstart = nbasis
      if (iverb.ge.4) then
        print *, 'setting maximum starting subspace',&
  &  ' to be equal to number of basis functions'
      end if
    end if

! check that there is at least one rhs
    if (nrhs.le.0) then
      if (iverb.ge.0) then
        print *, 'no right hand sides, solving failed'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if

! force starting subspace to be at least equal to nroots
    if (minstart.lt.nrhs) then
      minstart = nrhs
      if (iverb.ge.4) then
        print *, 'setting minimum starting subspace',&
  & 'to be equal to number of right hand sides'
      end if
    end if

! allocate diagonal first to determine some features of problem
! to set nstart
    allocate(approx_spectra(nbasis))

! fill approx spectra
    call krylov_approx%vector_fill(nbasis,approx_spectra,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_float_subroutine)function for approx failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -50
      return ! abort solver, return to call
    end if

    call krylov_start%lkl_start(nbasis,nrhs,&
  &        approx_spectra,nstart,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_start_subroutine) function failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -50
      return ! abort solver, return to call!
    end if

! force starting subspace to be at least equal to nroots
    if (nstart.lt.minstart) then
      nstart = minstart
      if (iverb.ge.4) then
        print *, 'setting starting subspace to minimum'
      end if
    end if
! logic check that subspace is less than full basis
    if (nstart.gt.maxstart) then
      nstart = maxstart
      if (iverb.ge.4) then
        print *, 'setting starting subspace to maximum'
      end if
    end if

! Determine max subspace, and check if it is feasible
    maxsubspace = nstart + (maxiter * nrhs)

    if (maxsubspace.gt.nbasis) then
      if (iverb.ge.4) then
        print *, 'limiting number of iterations'
        print *, ' to ensure subspace is smaller than full basis'
      end if
      maxsubspace = nbasis
      maxiter = floor((real((nbasis-nstart),kind=kind_float)/&
  &     nrhs+real(1,kind=kind_float)),kind=kind_integer)
    end if

!! define file name for restart files
    vname = trim(id_string)//'v.rstrt'
    wname = trim(id_string)//'w.rstrt'
    rname = trim(id_string)//'r.rstrt'
    sname = trim(id_string)//'v.save'

! Set initial subspace size
    nsubspace = nstart


! Allocate all arrays that exist across iterations
    allocate(basis_vectors(nbasis,maxsubspace)) !maximum
    allocate(mvproduct(nbasis,maxsubspace)) !maximum
    allocate(rhs(nbasis,nrhs))
    allocate(proj_rhs(maxsubspace,nrhs)) !maximum
    allocate(rayleigh(maxsubspace,maxsubspace)) !maximum
    allocate(lagrangian(nrhs))
    allocate(solutions(maxsubspace,nrhs)) !maximum
    allocate(full_solutions(nbasis,nrhs))
    allocate(overlap(maxsubspace,maxsubspace)) !maximum
    allocate(cholesky(maxsubspace,maxsubspace)) !maximum
    allocate(diag_overlap(maxsubspace)) !maximum
    allocate(residuals(nbasis,nrhs)) !maximum
    allocate(euc_norm(nrhs))
    allocate(jconverged(nrhs))


!! zero out important quantities
    basis_vectors = real(0,kind=kind_float)
    overlap = real(0,kind=kind_float)
    diag_overlap = real(0,kind=kind_float)
    
    associate(interfacing_rhs => rhs%element)
      call krylov_rhs%matrix_fill(nbasis,nrhs,interfacing_rhs,ierr)
    end associate

    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_base_subroutine)function rhs failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -55
      return ! abort solver, return to call
    end if

!! if restart is allowed, look for restart v files
!!  invert irestart if new restart is to be generated
!!   as v-file is missing
!! check can be moved after allocation?
    if (irestart.ge.2) then
      inquire(file=vname,exist=check)
      if (check) then
        call array_read_rstrt_size(vname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no restart available
          ierr = 0
          irestart = -abs(irestart)
        else if (k1.ne.nbasis) then ! vfile not in this basis
          irestart = -abs(irestart)
        else if (k2.lt.nstart) then ! vfile from a different start?
          irestart = -abs(irestart)
        else if (k2.gt.nstart) then ! vfile from iter>1? ! vfile pass all checks
            nstart = k2
            maxiter = floor((real((maxsubspace-nstart),kind=kind_float)/&
  &           nrhs+real(1,kind=kind_float)),kind=kind_integer)
        end if ! vfile pass all checks
      else !no restart available or possible
        irestart = -abs(irestart)
      end if
    end if

    if (irestart.ge.2) then !read restart if possible
      if (iverb.ge.2) then
        print *, 'Calculation starting from restart file!'
      end if
      call array_read_rstrt(vname,nbasis,nstart,&
  &     basis_vectors(1:nbasis,1:nstart),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'v.rstrt passed checks but failed to read'
          print *, 'error variable = ',ierr
          print *, 'suggestion: delete v.rstrt'
        end if
        ierr = -50
        return ! abort solver, return to call
      end if
    else if (irestart.eq.0) then !! skip savefile check if no restart
      if (iverb.ge.2) then
        print *, 'Calcuation starting from scratch!'
      end if
      associate(interfacing_bv => basis_vectors%element)
        call krylov_guess%lkl_guess(nbasis,nstart,0,&
  &       approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &       ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_guess_subroutine) function failed' 
          print *, 'error variable = ',ierr
        end if
        ierr = -45
        return ! abort solver, return to call
      end if
    else ! save file if it could be useful
      inquire(file=sname,exist=check)
      if (check) then
        call array_read_rstrt_size(sname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no restart available
          ierr = 0
          irestart = -abs(irestart)
        else if (k1.ne.nbasis) then ! sfile not in this basis
          irestart = -abs(irestart)
        else ! sfile passes all checks, using sfile
          if (iverb.ge.2) then
            print *, 'Calculation starting from save file!'
          end if
          if (k2.gt.nstart) then ! read in only up to nstart vecs
            k2 = nstart
          end if
          call array_read_rstrt(sname,nbasis,k2,&
  &           basis_vectors(1:nbasis,1:k2),iverb,ierr)
          if (ierr.ne.0) then
            if (iverb.ge.0) then
              print *, 'v.save passed checks but failed to read'
              print *, 'error variable = ',ierr
              print *, 'suggestion: delete v.save'
            end if
            ierr = -50
            return ! abort solver, return to call
          end if
          if (k2.eq.nstart) then ! no new initial vectors needed
            if (iverb.ge.2) then
              print *, ' with no new vectors needed!'
            end if
          else ! more initial vectors needed
            if (iverb.ge.2) then
              print *, ' generating more start vectors!'
            end if
            associate(interfacing_bv => basis_vectors%element)
              call krylov_guess%lkl_guess(nbasis,nstart,k2,&
  &             approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &             ierr)
            end associate
            if (ierr.ne.0) then
              if (iverb.ge.0) then
                print *, 'class(user_krylov_guess_subroutine) function failed' 
                print *, 'error variable = ',ierr
              end if
              ierr = -45
              return ! abort solver, return to call
            end if
          end if
        end if
      else !no save file
!! Fresh starting basis vectors generated if 
!! conditions are met.
        irestart = -abs(irestart)
        if (iverb.ge.2) then
          print *, 'Calculation starting from scratch!'
        end if
        associate(interfacing_bv => basis_vectors%element)
          call krylov_guess%lkl_guess(nbasis,nstart,0,&
  &         approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &         ierr)
        end associate
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'class(user_krylov_guess_subroutine) function failed' 
            print *, 'error variable = ',ierr
          end if
          ierr = -45
          return ! abort solver, return to call 
        end if
      end if
    end if


! print restart basis-vector products if required
    if (irestart.le.-2) then
      call array_print_rstrt(vname,nbasis,nsubspace,&
  &       basis_vectors(1:nbasis,1:nsubspace),iverb,ierr)
      ierr = 0
    end if


!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! determine overlap
    call ggemm('c','n',nstart,nstart,nbasis,one_kb,&
  &    basis_vectors(1:nbasis,1:nstart),nbasis,&
  &    basis_vectors(1:nbasis,1:nstart),nbasis,&
  &    zero_kb,&
  &    overlap(1:nstart,1:nstart),&
  &    nstart)
!! determine diag_overlap
    do j = 1 , nstart
      diag_overlap(j) = overlap(j,j)
    end do
    call krylov_cholesky(nsubspace,overlap(1:nsubspace,1:nsubspace),&
  &    diag_overlap(1:nsubspace),& 
  &    cholesky(1:nsubspace,1:nsubspace),iverb,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'initial overlap matrix failed cholesky decomposition' 
        print *, 'error variable = ',ierr
      end if
      ierr = -45
      return ! abort solver, return to call 
    end if

!! if restart from mvp is allowed, look for restart w files
!! invert irestart to generate new basis vectors
    if (irestart.ge.3) then
      inquire(file=wname,exist=check)
      if (check) then
        call array_read_rstrt_size(wname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no wfile
          irestart = -abs(irestart)
          ierr = 0
        else if (k1.ne.nbasis) then ! wfile not in this basis
          irestart = -abs(irestart)
        else if (k2.gt.nstart) then ! wfile not matching vfile?
          irestart = -abs(irestart)
        end if
      else ! no wfile
        irestart = -abs(irestart)
      end if
    end if

    if (irestart.le.2) then  !! need to generate new MVP
! call user defined matrix vector product for the first time
      associate(interfacing_bv => basis_vectors%element,&
  &             interfacing_mv => mvproduct%element)
        call krylov_mvp%lkl_mvp(nbasis,nsubspace,&
  &       interfacing_bv(1:nbasis,1:nsubspace),&
  &       interfacing_mv(1:nbasis,1:nsubspace),ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(libkrylov_mvp_subroutine) function failed' 
          print *, 'before the first iteration'
          print *, 'error variable = ',ierr
        end if
        ierr = -45
        return ! abort solver, return to call
      end if
! print restart matrix-vector products if required
      if (irestart.le.-3) then
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        ierr = 0
      end if
    else ! can read MVP restart, read it!
      if (iverb.ge.2) then
        print *, ' Including restart for matrix vector products!'
      end if
      call array_read_rstrt(wname,nbasis,k2,&
  &       mvproduct(1:nbasis,1:k2),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'w.rstrt passed checks but failed to read'
          print *, 'error variable = ',ierr
          print *, 'suggestion: delete w.rstrt'
        end if
        ierr = -50
        return ! abort solver, return to call
      end if
      if (k2.lt.nstart) then
        if (iverb.ge.2) then
          print *, 'assuming w.rstrt is intact and did not update!'
        end if
        associate(interfacing_bv => basis_vectors%element,&
  &               interfacing_mv => mvproduct%element)
        call krylov_mvp%lkl_mvp(nbasis,(nstart-k2),&
  &       interfacing_bv(1:nbasis,(k2+1):nsubspace),&
  &       interfacing_mv(1:nbasis,(k2+1):nsubspace),ierr)
        end associate
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'class(user_krylov_mvp_subroutine) function failed' 
            print *, 'before the first iteration'
            print *, 'error variable = ',ierr
          end if
          ierr = -45
          return ! abort solver, return to call
        end if
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        ierr = 0
      end if
    end if

!! if restart for rhs is allowed, look for restart r files
!! invert irestart to generate new proj-rhs vectors
    if (irestart.ge.4) then
      inquire(file=rname,exist=check)
      if (check) then
        call array_read_rstrt_size(rname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no rfile
          irestart = -abs(irestart)
          ierr = 0
        else if (k1.gt.nstart) then ! rfile not matching vfile?
          irestart = -abs(irestart)
        else if (k2.ne.nrhs) then ! rfile not matching problem?
          irestart = -abs(irestart)
        end if
      else ! no rfile
        irestart = -abs(irestart)
      end if
    end if

    if (irestart.le.3) then  !! need to generate new RHS
      one_kb = real(1,kind=kind_float)
      zero_kb = real(0,kind=kind_float)
      call ggemm('c','n',nsubspace,nrhs,nbasis,one_kb,&
&       basis_vectors(1:nbasis,1:nsubspace),nbasis,&
&       rhs(1:nbasis,1:nrhs),nbasis,&
&       zero_kb,&
&       proj_rhs(1:nsubspace,1:nrhs),&
&       nsubspace)
! print restart proj-rhs products if required
      if (irestart.le.-4) then
        call array_print_rstrt(rname,nsubspace,nrhs,&
  &       proj_rhs(1:nsubspace,1:nrhs),iverb,ierr)
        ierr = 0
      end if
    else ! can read proj_rhs restart, read it!
      if (iverb.ge.2) then
        print *, ' Including restart for projected RHS!'
      end if
      call array_read_rstrt(rname,k1,nrhs,&
  &       proj_rhs(1:k1,1:nrhs),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'r.rstrt passed checks but failed to read'
          print *, 'error variable = ',ierr
          print *, 'suggestion: delete r.rstrt'
        end if
        ierr = -50
        return ! abort solver, return to call
      end if
      if (k1.lt.nstart) then
        if (iverb.ge.2) then
          print *, 'assuming r.rstrt is intact and did not update!'
        end if
        one_kb = real(1,kind=kind_float)
        zero_kb = real(0,kind=kind_float)
        call ggemm('c','n',(nstart-k1),nrhs,nbasis,one_kb,&
&         basis_vectors(1:nbasis,(k1+1):nsubspace),nbasis,&
&         rhs(1:nbasis,1:nrhs),nbasis,&
&         zero_kb,&
&         proj_rhs((k1+1):nsubspace,1:nrhs),&
&         nsubspace)
        call array_print_rstrt(rname,nsubspace,nrhs,&
  &       proj_rhs(1:nsubspace,1:nrhs),iverb,ierr)
        ierr = 0
      end if
    end if

    call krylov_rayleigh(nbasis,nsubspace,&
  &     approx_spectra,mvproduct(1:nbasis,1:nsubspace),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     rayleigh(1:nsubspace,1:nsubspace),iverb,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'initial construction of rayleigh matrix failed' 
        print *, 'error variable = ',ierr
      end if
      ierr = -45
      return ! abort solver, return to call 
    end if

! reset irestart to normal operation
    irestart = abs(irestart)

!! check projected rhs are unique - otherwise residuals will 
!! be linearly dependent
    if (nrhs.gt.1) then
      call krylov_unique(nstart,nrhs,&
  &     proj_rhs(1:nstart,1:nrhs),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.gt.0) then
          print *, 'projecting rhs failed'
          print *, '  the rhs could be identical'
          print *, '   otherwise the basis could be the problem'
        end if
        return
      end if 
    end if


    if (iverb.ge.1) then
      print *, ''
      print *, 'convergence criteria: 10^(-',threshold,')'
      print *, 'initial subspace:  ',nstart
      print *, 'full vector space: ',nbasis
      print *, 'maximum number of iterations: ',maxiter
      print *, ' '
    end if

! SOLVER LOOP
    jter = 0
    do iter = 1, maxiter


! Check for kill file
      inquire(file=kill_file_string,exist=check)
      if (check) then
        if (iverb.ge.0) then
          print *, 'kill file exist, libkrylov killed'
          if (iverb.ge.3) then
            print *, 'kill file is ',kill_file_string
          end if
        end if
        ierr = -40
        return ! abort solver, return to call
      end if

      jter = jter + 1

      if (iverb.ge.0) then
        print *, '~~~~~Iteration (',iter,')~~~~~'
        if (iverb.ge.1) then
          print *, 'current sub space: ',nsubspace
        end if
      end if

! call krylov ritz subroutine
      call krylov_b_ritz(nbasis,nsubspace,nrhs,&
  &     rayleigh(1:nsubspace,1:nsubspace),&
  &     cholesky(1:nsubspace,1:nsubspace),&
  &     proj_rhs(1:nsubspace,1:nrhs),&
  &     overlap(1:nsubspace,1:nsubspace),diag_overlap(1:nsubspace),&
  &     lagrangian,solutions(1:nsubspace,1:nrhs),iverb,ierr)
      if (ierr.eq.-35) then ! error variable for ill-conditioned overlap
        nsubspace = prev_nsubspace
        if (iverb.ge.0) then
          print *, 'preparation for krylov ritz(subspace solve) failed'
          print *, 'error variable = ',ierr
        end if
        if (iter.gt.1) then
          if (iverb.ge.0) then
            print *, 'using previous subspace solutions for print'
          end if
          ierr = 0
        end if
        exit ! This exits subspace loop
      else if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov ritz(subspace solve) calculation failed'
          print *, 'error variable = ',ierr
        end if
        ierr = -40
        exit ! This exits subspace loop
      end if

!! calculation of solutions on full space
      call ggemm('n','n',nbasis,nrhs,nsubspace,one_kb,&
  &      basis_vectors,nbasis,&
  &      solutions,maxsubspace,&
  &      zero_kb,&
  &      full_solutions,&
  &      nbasis)

! call krylov norms subroutine
      call krylov_b_norms(nbasis,nsubspace,nrhs,&
  &     mvproduct(1:nbasis,1:nsubspace),& 
  &     basis_vectors(1:nbasis,1:nsubspace),full_solutions,& 
  &     solutions(1:nsubspace,1:nrhs),&
  &     overlap(1:nsubspace,1:nsubspace),&
  &     rhs,approx_spectra,krylov_precon,&
  &     residuals,euc_norm,largest_euc_norm,&
  &     fro_norm,nresiduals,iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov norms calculation failed'
          print *, 'error variable = ',ierr
        end if 
        ierr = -40
        exit ! This exits subspace loop
      end if

! determine convergence of solutions based on euclidean norm
      nconverged = 0
      jconverged = .false.
      do j = 1 , nrhs
        if ((-threshold).gt.log10(euc_norm(j))) then
          nconverged = nconverged + 1
          jconverged(j) = .true.
        end if
      end do
      if (iverb.ge.2) then
        print *, 'converged vectors: ', nconverged
      end if

! determine convergence of solutions based on frobenius norm
! The stricter test, this is done before check by euclidean norms
      if ((-threshold).gt.log10(fro_norm)) then
        if (iverb.ge.1) then
          print *, 'Converged by frobenius norm!'
        end if
        exit ! This exits subspace loop
      end if

! determine convergence of solutions based on nconverged
      if (nconverged.ge.nrhs) then
        if (iverb.ge.1) then
          print *, 'Converged by euclidean norm!'
        end if
        exit ! This exits subspace loop
      end if

! convergence checks failed when this line is reached
      if (iverb.ge.2) then
        print *, 'More iterations required for desired convergence!'
      end if

! check that more iterations are allowed before extending subspace
      if (iter.eq.maxiter) then
        if (iverb.ge.0) then
          print *, 'failed to converge within max number of iterations'
        end if
        exit ! This exits subspace loop
      end if

! Check that there are residuals to extend the subspace with
      if (nresiduals.eq.0) then
        if (iverb.ge.0) then
          print *, 'No preconditioned residuals above machine precision!'
          print *, 'failed to find vectors to expand subspace!'
        end if
        exit ! This exits subspace loop
      end if

! Check for stop file
      inquire(file=stop_file_string,exist=check)
      if (check) then
        if (iverb.ge.0) then
          print *, 'stop file exist, libkrylov stopped'
          if (iverb.ge.3) then
            print *, 'stop file is ',stop_file_string
          end if
        end if
        exit ! exit subspace loop
      end if

! call krylov extend subroutine, after saving prev_nsubspace
      prev_nsubspace = nsubspace
      nsubspace = nsubspace + nresiduals  
      call krylov_extend(nbasis,nsubspace,&
  &     nresiduals,prev_nsubspace,&
  &     residuals(1:nbasis,1:nresiduals),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     overlap(1:nsubspace,1:nsubspace),&
  &     diag_overlap(1:nsubspace),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov subspace expansion failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        nsubspace = prev_nsubspace
        ierr = 0
        exit ! This exits subspace loop
      end if

! cholesky decomposition of matrix
      call krylov_cholesky(nsubspace,overlap(1:nsubspace,1:nsubspace),&
  &     diag_overlap(1:nsubspace),& 
  &     cholesky(1:nsubspace,1:nsubspace),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'new krylov subspace failed stability check'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        nsubspace = prev_nsubspace
        ierr = 0
        exit ! This exits subspace loop
      end if

! print restart basis-vectors if required
      if (irestart.ge.2) then
        call array_print_rstrt(vname,nbasis,nsubspace,&
  &       basis_vectors(1:nbasis,1:nsubspace),iverb,ierr)
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'unable to print v restart files'
            ierr = 0
          end if
        end if
      end if

!! need to increase RHS as well
      call ggemm('c','n',nresiduals,nrhs,nbasis,one_kb,&
  &     basis_vectors(1:nbasis,(prev_nsubspace+1):nsubspace),nbasis,&
  &     rhs(1:nbasis,1:nrhs),nbasis,&
  &     zero_kb,&
  &     proj_rhs((prev_nsubspace+1):nsubspace,1:nrhs),&
  &     nresiduals)

! print restart proj_rhs if required
      if (irestart.ge.4) then
        call array_print_rstrt(rname,nsubspace,nrhs,&
  &       proj_rhs(1:nsubspace,1:nrhs),iverb,ierr)
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'unable to print r restart files'
            ierr = 0
          end if
        end if
      end if


! spacer
      if (iverb.ge.0) then
        print *, ' '
      end if

! call user defined matrix vector product
      associate(interfacing_bv => basis_vectors%element,&
  &             interfacing_mv => mvproduct%element)
        call krylov_mvp%lkl_mvp(nbasis,nresiduals,&
  &       interfacing_bv(1:nbasis,(prev_nsubspace+1):nsubspace),&
  &       interfacing_mv(1:nbasis,(prev_nsubspace+1):nsubspace),ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_mvp_subroutine) function failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        ierr = 0
        nsubspace = prev_nsubspace
        exit ! This exits subspace loop
      end if

! print restart if required
      if (irestart.ge.3) then
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'unable to print w restart files'
            ierr = 0
          end if
        end if
      end if


! expand rayleigh matrix
      call krylov_expand(nbasis,nsubspace,&
  &     nresiduals,prev_nsubspace,&
  &     approx_spectra,mvproduct(1:nbasis,1:nsubspace),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     rayleigh(1:nsubspace,1:nsubspace),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'expanding rayleigh matrix failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        ierr = 0
        nsubspace = prev_nsubspace
        exit ! This exits subspace loop
      end if

    end do ! krylov subspace loop ends

! spacer
    if (iverb.ge.0) then
      print *, ' '
        if (iverb.ge.2) then
          print *, 'number of iterations: ',jter
          print *, ' '
        end if
    end if

! Check for kill file
    inquire(file=kill_file_string,exist=check)
    if (check) then
      if (iverb.ge.0) then
        print *, 'kill file exist, libkrylov killed'
        if (iverb.ge.3) then
          print *, 'kill file is ',kill_file_string
        end if
      end if
      ierr = -40
      return ! abort solver, return to call
    end if


!  check status of calculation, call appropriate ending tasks
    if (ierr.ne.0) then ! serious error somewhere in the calculation
      if (iverb.ge.0) then
        print *, 'quality of values unknown,'
        print *, 'old save file not overwritten,'
        print *, 'class(user_krylov_a_output_subroutine) not called'
      end if
    else ! iterations exited with no serious errors, possible useful data!
      if (irestart.ge.1) then ! user asked for save files
        call array_print_rstrt(sname,nbasis,nrhs,&
  &       full_solutions(1:nbasis,1:nrhs),iverb,ierr)
        if (ierr.eq.0) then ! save file printed! safe to delete restart
          if (irestart.ge.2) then
            call array_del_rstrt(vname,iverb,ierr)
            ! no check for ierr, no action on fail
            ierr = 0
            if (irestart.ge.3) then
              call array_del_rstrt(wname,iverb,ierr)
              ! no check for ierr, no action on fail
              ierr = 0
              if (irestart.ge.4) then
                call array_del_rstrt(rname,iverb,ierr)
                ! no check for ierr, no action on fail
                ierr = 0
              end if
            end if
          end if
        else ! something wrong with printing save, don't delete files
          if (iverb.ge.0) then
            print *, 'unable to print save file'
          end if
!reset ierr, no matter what happened in restart
          ierr = 0
        end if
      end if
!! call user output function
      associate(interfacing_lg => lagrangian%element,&
  &             interfacing_rhs => rhs%element,&
  &             interfacing_fs => full_solutions%element)
      call krylov_output_b%lkl_output_b(nbasis,nsubspace,nrhs,&
  &     nconverged,jconverged,interfacing_rhs,interfacing_lg,&
  &     interfacing_fs(1:nbasis,1:nrhs),&
  &     euc_norm,fro_norm,id_string,ierr)
      end associate
!! final ierr check and adjustments
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_output_subroutine) function failed'
        end if
        ierr = -20
      else if (nconverged.le.0) then !only if ierr .eq. 0
        if (iverb.ge.0) then
          print *, 'solver produced no solutions'
        end if
        ierr = -15
      else if (nconverged.lt.nrhs) then !only if output function works
        if (iverb.ge.1) then
          print *, 'not all desired solutions produced'
          print *, 'ierr contains number of solutions printed'
        end if
        ierr = nconverged
      end if
    end if

    deallocate(basis_vectors)
    deallocate(mvproduct)
    deallocate(approx_spectra)
    deallocate(rhs)
    deallocate(proj_rhs)
    deallocate(rayleigh)
    deallocate(lagrangian)
    deallocate(solutions)
    deallocate(full_solutions)
    deallocate(overlap)
    deallocate(cholesky)
    deallocate(diag_overlap)
    deallocate(residuals)
    deallocate(euc_norm)
    deallocate(jconverged)

    if (iverb.ge.0) then
      print *, '////////////////////////////////////////////////'
      print *, 'Solver Done'
      print *, '////////////////////////////////////////////////'
    end if

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_b_solver
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine krylov_c_ritz(nbasis,nsubspace,nomega,nrhs,nroots,&
  &     rayleigh,&
  &     cholesky,proj_rhs,&
  &     overlap,diag_overlap,&
  &     omega,lagrangian,solutions,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the ritz step of a krylov solve,
!< producing guess/approximate solutions of the Slyvester problem
!< in the subspace basis
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace
    integer(kind_integer), intent(in) :: nomega
    integer(kind_integer), intent(in) :: nrhs
    integer(kind_integer), intent(in) :: nroots
    type(base), intent(in) :: rayleigh(nsubspace,nsubspace)
    type(base), intent(in) :: cholesky(nsubspace,nsubspace)
    type(base), intent(in) :: proj_rhs(nsubspace,nrhs)
    type(base), intent(in) :: overlap(nsubspace,nsubspace)
    real(kind_float), intent(in) :: diag_overlap(nsubspace)
    real(kind_float), intent(in) :: omega(nomega)
!--------------------------------------------------------------------
! Output Variables
!--------------------------------------------------------------------
    type(base), intent(inout) :: lagrangian(nroots)
    type(base), intent(inout) :: solutions(nsubspace,nroots)
!--------------------------------------------------------------------
! Error Variables
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb   
    integer(kind_integer), intent(inout) :: ierr   
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
    type(base), allocatable :: subspace(:,:)
    type(base), allocatable :: scaled_rhs(:,:)
    type(base), allocatable :: subspace_shift(:,:)
    type(base), allocatable :: vavx(:,:)
    type(base), allocatable :: vvx(:,:)
    type(base) :: expectation
    type(base) :: norm
    type(base) :: rhs_with_x
    type(base) :: x_with_rhs
    real(kind_float), allocatable :: d_o_sqrt(:)
!! integer for linear solve
    integer(kind_integer),allocatable :: ipiv(:)
!! integer for loops
    integer(kind_integer) :: j,k,l,m = 0
!--------------------------------------------------------------------

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)

!! Allocate local arrays
    allocate(subspace(nsubspace,nsubspace))
    allocate(d_o_sqrt(nsubspace))
    allocate(scaled_rhs(nsubspace,nrhs))
    allocate(subspace_shift(nsubspace,nsubspace))
    allocate(ipiv(nsubspace))
    allocate(vavx(nsubspace,nroots))
    allocate(vvx(nsubspace,nroots))

!! construct d_o_sqrt
    d_o_sqrt = sqrt(diag_overlap)

!! scale subspace(rayleigh) with norms
    do k = 1, nsubspace
      do j = 1, nsubspace
        if (j.eq.k) then
          subspace(j,j) = rayleigh(j,j)/diag_overlap(j)
        else
          subspace(j,k) = rayleigh(j,k)/(d_o_sqrt(j)*d_o_sqrt(k))
        end if
      end do
    end do

!! scale rhs
    do k = 1, nrhs
      do j = 1, nsubspace
         scaled_rhs(j,k) = proj_rhs(j,k)/d_o_sqrt(j)
      end do
    end do

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
!! scale subspace(rayleigh) with cholesky
    call gtrsm('r','l','c','n',nsubspace,nsubspace,one_kb,&
  &   cholesky,nsubspace,subspace,nsubspace)
    one_kb = real(1,kind=kind_float)
    call gtrsm('l','l','n','n',nsubspace,nsubspace,one_kb,&
  &   cholesky,nsubspace,subspace,nsubspace)

!!scale rhs with cholesky
    one_kb = real(1,kind=kind_float)
    call gtrsm('l','l','n','n',nsubspace,nrhs,one_kb,&
  &   cholesky,nsubspace,scaled_rhs,nsubspace)

!! loop for different frequencies
    l = 0 
!< set first l, for offset of first solution corresponding to freq
    if ((nroots.eq.nomega).and.(nroots.eq.nrhs)) then 
!< one solution per omega per rhs, include all equal to 1
      do k = 1, nroots
!! shift subspace with frequency
        subspace_shift = subspace
        if (abs(omega(k)).gt.eps) then
          do j = 1, nsubspace
            subspace_shift(j,j) = subspace(j,j) - omega(k)
          end do
        end if
! move scaled rhs onto solutions
        solutions(1:nsubspace,k) = &
  &       scaled_rhs(1:nsubspace,k)
!! solve for solutions onto solutions
        call ghesv('l',nsubspace,1,subspace_shift,nsubspace,ipiv,&
  &       solutions(1:nsubspace,k:k),nsubspace,ierr)
        if (iverb.ge.5) then
          print *, 'ipiv from solve',k,' :'
          print *, ipiv
        end if
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, '*hesv/*sysv linear algebra error!', ierr
            print *, 'for ',k,' frequency' 
            print *, 'exit ritz step'
          end if
          ierr = -40
          return ! return to solver loop
        end if 
      end do
    else
      do k = 1, nomega
!! shift subspace with frequency
        subspace_shift = subspace
        if (abs(omega(k)).gt.eps) then
          do j = 1, nsubspace
            subspace_shift(j,j) = subspace(j,j) - omega(k)
          end do
        end if
! move scaled rhs onto solutions
        solutions(1:nsubspace,(l+1):(l+nrhs)) = &
  &       scaled_rhs(1:nsubspace,1:nrhs)
!! solve for solutions onto solutions
        call ghesv('l',nsubspace,nrhs,subspace_shift,nsubspace,ipiv,&
  &       solutions(1:nsubspace,(l+1):(l+nrhs)),nsubspace,ierr)
        if (iverb.ge.5) then
          print *, 'ipiv from solve',k,' :'
          print *, ipiv
        end if
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, '*hesv/*sysv linear algebra error!', ierr
            print *, 'for ',k,' frequency' 
            print *, 'exit ritz step'
          end if
          ierr = -40
          return ! return to solver loop
        end if 
        l = l + nrhs ! l+1 is column index of first solution
!< move index for next iteration
      end do
    end if

!! reverse cholesky on solutions
!! UNKNOWN BUG, ONE CHANGES VALUE, FIX SOON
    one_kb = real(1,kind=kind_float)
    call gtrsm('l','l','c','n',nsubspace,nroots,one_kb,&
  &   cholesky,nsubspace,solutions,nsubspace)

!! reverse scaling to get solutions
    do j = 1, nroots
      do k = 1, nsubspace
        solutions(k,j) = solutions(k,j)/d_o_sqrt(k)
      end do
    end do

!! compute lagrangian
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! compute vavx 
    call ggemm('n','n',nsubspace,nroots,nsubspace,&
  &   one_kb,rayleigh,nsubspace,&
  &   solutions,nsubspace,zero_kb,&
  &   vavx,nsubspace)
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! compute vvx 
    call ggemm('n','n',nsubspace,nroots,nsubspace,&
  &   one_kb,overlap,nsubspace,&
  &   solutions,nsubspace,zero_kb,&
  &   vvx,nsubspace)
    if (iverb.ge.2) then
      print *, 'lagrangians of desired solutions:' 
    end if
    k = 0 ! cycle over rhs
    l = 1 ! cycle over omega
    if ((nroots.eq.nomega).and.(nroots.eq.nrhs)) then ! one solution per frequency per rhs
!< this includes only one solution, one frequency, one rhs
      do j = 1, nroots
        call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &       vavx(1:nsubspace,j),1,expectation,ierr)
        call gdot(nsubspace,proj_rhs(1:nsubspace,j),1,&
  &       solutions(1:nsubspace,j),1,rhs_with_x,ierr)
        call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &       proj_rhs(1:nsubspace,j),1,x_with_rhs,ierr)
        if (abs(omega(j)).gt.eps) then
          call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &         vvx(1:nsubspace,j),1,norm,ierr)
          lagrangian(j) = expectation&
  &         -(norm*omega(j))- rhs_with_x - x_with_rhs
        else
          lagrangian(j) = expectation&
  &         - rhs_with_x - x_with_rhs
        end if
        if (iverb.ge.2) then
          print *, 'L of ',j,' freq and rhs : ',lagrangian(j)
        end if
      end do
    else if (nroots.eq.nomega) then ! only one rhs
      do j = 1, nroots
        call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &       vavx(1:nsubspace,j),1,expectation,ierr)
        call gdot(nsubspace,proj_rhs(1:nsubspace,1),1,&
  &       solutions(1:nsubspace,j),1,rhs_with_x,ierr)
        call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &       proj_rhs(1:nsubspace,1),1,x_with_rhs,ierr)
        if (abs(omega(j)).gt.eps) then
          call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &         vvx(1:nsubspace,j),1,norm,ierr)
          lagrangian(j) = expectation&
  &         -(norm*omega(j))- rhs_with_x - x_with_rhs
        else
          lagrangian(j) = expectation&
  &         - rhs_with_x - x_with_rhs
        end if
        if (iverb.ge.2) then
          print *, 'L of ',j,' freq (fixed rhs): ',lagrangian(j)
        end if
      end do
    else if (nroots.eq.nrhs) then ! only one frequency
      if (abs(omega(1)).gt.eps) then
        do j = 1, nroots
          call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &         vavx(1:nsubspace,j),1,expectation,ierr)
          call gdot(nsubspace,proj_rhs(1:nsubspace,j),1,&
  &         solutions(1:nsubspace,j),1,rhs_with_x,ierr)
          call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &         proj_rhs(1:nsubspace,j),1,x_with_rhs,ierr)
          call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &         vvx(1:nsubspace,j),1,norm,ierr)
          lagrangian(j) = expectation&
  &         -(norm*omega(1))- rhs_with_x - x_with_rhs
          if (iverb.ge.2) then
            print *, 'L of ',j,' rhs (fixed freq): ',lagrangian(j)
          end if
        end do
      else
        do j = 1, nroots
          call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &         vavx(1:nsubspace,j),1,expectation,ierr)
          call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &         proj_rhs(1:nsubspace,j),1,x_with_rhs,ierr)
          call gdot(nsubspace,proj_rhs(1:nsubspace,j),1,&
  &         solutions(1:nsubspace,j),1,rhs_with_x,ierr)
          lagrangian(j) = expectation&
  &         - rhs_with_x - x_with_rhs
          if (iverb.ge.2) then
            print *, 'L of ',j,' rhs (fixed freq): ',lagrangian(j)
          end if
        end do
      end if
    else ! all pairs of rhs and omega calculated - cycle rhs then freq
      do j = 1, nroots
        k = k + 1
        if (k.gt.nrhs) then
          k = 1
          l = l + 1
        end if
        call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &       vavx(1:nsubspace,j),1,expectation,ierr)
        call gdot(nsubspace,proj_rhs(1:nsubspace,k),1,&
  &       solutions(1:nsubspace,j),1,rhs_with_x,ierr)
        call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &       proj_rhs(1:nsubspace,k),1,x_with_rhs,ierr)
        if (abs(omega(l)).gt.eps) then
          call gdot(nsubspace,solutions(1:nsubspace,j),1,&
  &         vvx(1:nsubspace,j),1,norm,ierr)
          lagrangian(j) = expectation&
  &         -(norm*omega(l))- rhs_with_x - x_with_rhs
        else
          lagrangian(j) = expectation&
  &         - rhs_with_x - x_with_rhs
        end if
        if (iverb.ge.2) then
          print *, 'L of ',k,' rhs and ',l,' freq: ',lagrangian(j)
        end if
      end do
    end if

! Deallocate local arrays
    deallocate(subspace_shift)
    deallocate(vavx)
    deallocate(vvx)
    deallocate(ipiv)
    deallocate(subspace)
    deallocate(d_o_sqrt)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine krylov_c_ritz
!--------------------------------------------------------------------
!--------------------------------------------------------------------


!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine krylov_c_norms(nbasis,nsubspace,nomega,nrhs,nroots,&
  &     mvproduct,basis_vectors,full_solutions,solutions,&
  &     overlap,omega,rhs,&
  &     approx_spectra,krylov_precon,residuals,&
  &     euc_norm,largest_euc_norm,fro_norm,&
  &     nresiduals,iverb,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine does the norms step of a krylov solve,
!< producing the residual norms of the approximate solutions.
!< to save computational power the residuals are passed out 
!< from this routine as well.
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! define real(kind_float) and associated operations
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input Variables
!--------------------------------------------------------------------
! Comments in the solver subroutine below
    integer(kind_integer), intent(in) :: nbasis
    integer(kind_integer), intent(in) :: nsubspace
    integer(kind_integer), intent(in) :: nomega
    integer(kind_integer), intent(in) :: nrhs
    integer(kind_integer), intent(in) :: nroots
    type(base), intent(in) :: mvproduct(nbasis,nsubspace)
    type(base), intent(in) :: basis_vectors(nbasis,nsubspace)
    type(base), intent(in) :: full_solutions(nbasis,nroots)
    type(base), intent(in) :: solutions(nsubspace,nroots)
    type(base), intent(in) :: overlap(nsubspace,nsubspace)
    real(kind_float), intent(in) :: omega(nomega)
    type(base), intent(in) :: rhs(nbasis,nrhs)
    real(kind_float), intent(in) :: approx_spectra(nbasis)
    class(libkrylov_precon_subroutine) :: krylov_precon
!--------------------------------------------------------------------
! Output Variables
!--------------------------------------------------------------------
    type(base), intent(inout) :: residuals(nbasis,nroots)
    real(kind_float), intent(inout) :: euc_norm(nroots)
    real(kind_float), intent(inout) :: largest_euc_norm
    real(kind_float), intent(inout) :: fro_norm
    integer(kind_integer), intent(inout) :: nresiduals
!--------------------------------------------------------------------
! Error Parameter
!--------------------------------------------------------------------
    integer(kind_integer), intent(inout) :: iverb   
    integer(kind_integer), intent(inout) :: ierr   
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
    type(base) :: one_kb
    type(base) :: zero_kb
    type(base), allocatable :: all_residuals(:,:)
    real(kind_float), allocatable :: all_omega(:)
    logical, allocatable :: eps_converged(:)
    real(kind_float) :: lognbasis
    integer(kind_integer) :: ntemp ! n of all_residuals
    type(base), allocatable :: xo(:,:)
    type(base), allocatable :: vxo(:,:)
    type(base), allocatable :: euc_sq(:)
    real(kind_float) :: res_temp
!    integer(kind_float) :: ptest = 0 ! preconditioner test
!! integer for loops
    integer(kind_integer) :: j,k,l,m,n = 0
!--------------------------------------------------------------------

! Allocate local arrays
    allocate(all_residuals(nbasis,nroots))
    allocate(eps_converged(nroots))
    allocate(xo(nsubspace,nroots))
    allocate(vxo(nbasis,nroots))
    allocate(euc_sq(nroots))
    allocate(all_omega(nroots))

!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! calculate matrix vector products of the approximate solutions
!! in the representation of the full basis, aka avx, on residuals
    call ggemm('n','n',nbasis,nroots,nsubspace,&
  &   one_kb,mvproduct,nbasis,&
  &   solutions,nsubspace,zero_kb,&
  &   all_residuals,nbasis)
!! calculate scaled eigenvectors on the subspace
    k = 0 ! index-1 for first rhs per omega
    if (nroots.eq.nomega) then ! one solution per frequency
      do j = 1, nroots
        if (abs(omega(j)).gt.eps) then
          xo(1:nsubspace,j) = solutions(1:nsubspace,j)*omega(j)
        else
          xo(1:nsubspace,j) = real(0,kind=kind_float)
        end if
      end do
    else !more solutions than frequencies
      do j = 1, nomega
        if (abs(omega(j)).gt.eps) then
          xo(1:nsubspace,(k+1):(k+nrhs)) = &
  &         solutions(1:nsubspace,(k+1):(k+nrhs))*omega(j)
        else
          xo(1:nsubspace,(k+1):(k+nrhs)) = real(0,kind=kind_float)
        end if
        k = k + nrhs
     end do
    end if
!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! calculate scaled eigenvectors on the full space
    call ggemm('n','n',nbasis,nroots,nsubspace,&
  &   one_kb,basis_vectors,nbasis,&
  &   xo,nsubspace,zero_kb,&
  &   vxo,nbasis)
!! make residuals = avx-vxo
    all_residuals = all_residuals - vxo
!! make residuals = avx-vxo-rhs
    k = 0 ! index for the first rhs per omega
    if (nrhs.eq.nroots) then ! one solution per rhs
      all_residuals = all_residuals - rhs
    else
      do j = 1, nomega
        all_residuals(1:nbasis,(k+1):(k+nrhs)) =& 
  &       all_residuals(1:nbasis,(k+1):(k+nrhs)) &
  &        -rhs(1:nbasis,1:nrhs)
        k = k + nrhs
      end do
    end if

!! get inner product of residual with itself
    do j = 1, nroots
      call gdot(nbasis,all_residuals(1:nbasis,j),1,&
  &     all_residuals(1:nbasis,j),1,euc_sq(j),ierr)
    end do

!! assign type(base) to real
    euc_norm = euc_sq
    do j = 1, nroots
      if (euc_norm(j).lt.real(0,kind=kind_float)) then
        if (iverb.ge.0) then
          print *, 'square of ',j,' euclidean norm less than zero!'
          print *, 'exit norm step'
        end if
        ierr = -40
        return ! return to solver loop
      end if 
    end do
!! sum real euc_norm(squared) onto real fro_norm
    fro_norm = sum(euc_norm)
!! no check if fro_norm is positive, since it is a sum of positives

!! square root to get fro norm
    fro_norm = sqrt(fro_norm)
    if (iverb.ge.3) then
      print *, 'frobenius norm: ',fro_norm
    end if

!! square root to get euc norm
    euc_norm = sqrt(euc_norm)

    lognbasis = log10(real(nbasis,kind=kind_float))
!! compare euc_norm to logeps+lognbasis, 
!! set eps_converged and nresiduals
    eps_converged = .false.
    ntemp = nroots
    do j = 1, nroots
      if (log10(euc_norm(j)).lt.(logeps)) then
        eps_converged(j) = .true.
        ntemp = ntemp - 1
      end if
    end do
    if (iverb.ge.3) then
      print *, 'number of residuals before precondition: ',ntemp
    end if

!! find largest euc_norm
    largest_euc_norm = maxval(euc_norm)
    if (iverb.ge.3) then
      print *, 'largest euclidean norm: ',largest_euc_norm
      if (iverb.ge.4) then
        do j = 1,nroots
          print *, j,' euclidean norm: ',euc_norm(j)
        end do
      end if
    end if

!! return to calling subroutine if there are no residues
!! above machine precision
    if (ntemp.eq.0) then
      nresiduals = 0
      return
    end if

!! get all omega to precondition every residual
    n = 0 ! cycle over rhs
    do k = 1, nomega
      all_omega((n+1):(n+nrhs)) = omega(k)
! rhs not needed for preconditioning
! no shifting for all_residuals' index
      n = n + nrhs
    end do

!! Precondition with input function!
    associate(interfacing_fs => full_solutions%element,&
  &            interfacing_rd => all_residuals%element)
    call krylov_precon%lkl_precon(nbasis,nroots,nsubspace,&
  &     approx_spectra,&
  &     all_omega(1:nroots),interfacing_fs,&
  &     interfacing_rd(1:nbasis,1:nroots),ierr)
    end associate
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_precon_subroutine) function failed'
        print *, 'error variable = ',ierr
        print *, 'exit norm step'
      end if
      ierr = -40
      return ! return to solver loop
    end if

!! modified gram schmidt for the same rhs, 
    if (nroots.gt.nomega) then
      if (iverb.ge.4) then
        print *, 'inner product of preconditioned residuals:'
      end if
      do n = 1 , nrhs
        do j = n+nrhs , nroots , nrhs
          do k = n, j-nrhs, nrhs
            call gdot(nbasis,all_residuals(1:nbasis,j),1,&
  &           all_residuals(1:nbasis,k),1,euc_sq(1),ierr)
            if (iverb.ge.4) then
              print *, 'inner product of residuals: ', j,' and ',k
              print *, ' corresponding to RHS: ', n,' :'
              print *, euc_sq(1)
            end if
            call gdot(nbasis,all_residuals(1:nbasis,k),1,&
  &           all_residuals(1:nbasis,k),1,euc_sq(2),ierr)
            all_residuals(1:nbasis,j) = &
  &            all_residuals(1:nbasis,j) -&
  &            all_residuals(1:nbasis,k)*euc_sq(1)/euc_sq(2)
          end do
        end do
      end do
    end if


!! set log of nbasis
    lognbasis = log10(real(nbasis,kind=kind_float))

!! reset eps_converged, check norms of preconditioned residuals
!! reuse euc_sq,eps_converged, value of euc_sq lost!
    eps_converged = .false.
    nresiduals = nroots
    do j = 1, nroots
!! generate norm squared of preconditioned residual
      call gdot(nbasis,all_residuals(1:nbasis,j),1,&
  &     all_residuals(1:nbasis,j),1,euc_sq(j),ierr)
!! make norm squared real(kind_float)
      res_temp = euc_sq(j)
!! check that norm is positive
      if (res_temp.lt.real(0,kind=kind_float)) then
        if (iverb.ge.0) then
          print *, 'square of ',j,' residual norm'
          print *, 'less than zero after orthogonalization'
          print *, 'exit norm step'
        end if
        ierr = -40
        return ! return to solver loop
      end if
!! get norm
      res_temp = sqrt(res_temp)
!! check that norm is larger than (logeps+lognbasis)
      if (log10(res_temp).lt.(logeps)) then
        eps_converged(j) = .true.
        nresiduals = nresiduals - 1
      end if
      if (iverb.ge.4) then
        print *, j,' orthogonalized residual norm: ',res_temp
      end if
    end do
    if (iverb.ge.3) then
      print *, 'number of orthogonalized residuals: ',nresiduals
    end if

!! store preconditioned residuals on output array
    l = 0 ! cycle over all not converged preconditioned residuals
    if(nroots.eq.nresiduals) then
      residuals(1:nbasis,1:nresiduals) = &
  &     all_residuals(1:nbasis,1:nresiduals)
    else
      do k = 1, nroots
        if (.not.eps_converged(k)) then
          l = l + 1
          residuals(1:nbasis,l) = all_residuals(1:nbasis,k)
        end if
      end do
    end if

! Deallocate local arrays
    deallocate(all_residuals)
    deallocate(all_omega)
    deallocate(eps_converged)
    deallocate(vxo)
    deallocate(xo)
    deallocate(euc_sq)

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine krylov_c_norms
!--------------------------------------------------------------------
!--------------------------------------------------------------------

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  subroutine problem_c_solver(krylov_approx,krylov_start,krylov_rhs,&
    & krylov_omega,krylov_problem_c,krylov_guess,&
    & krylov_mvp,krylov_precon,krylov_output_c,ierr)
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Description:
!--------------------------------------------------------------------
!< This subroutine solves a problem with the form 'problem_a'
!< with the non-orthonormal krylov subspace method

  !< This subroutine requires the following 
  !< user-defined subroutines:
  !< krylov_approx for the approximate spectra
  !< krylov_start for determining number of start vectors
  !< krylov_rhs for the right hand side
  !< krylov_omega for the frequencies
  !< krylov_problem  for details of the problem
  !< krylov_guess for initializing more guess vectors and their
  !< overlap
  !< krylov_mvp for matrix vector products
  !< krylov_precon for preconditioning
  !< krylov_output for what to do with the eigenvectors and frequencies
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
! Modules and Global Variables
!--------------------------------------------------------------------
! for kind_integer and other precision related parameters
    use basekinds
! parameters for precision based on real(kind_float)
    use floatformat
! define type(base) and type(basereal) and associated operations
    use basetypes
    use blastypes
!--------------------------------------------------------------------
! Implicit None statement
!--------------------------------------------------------------------
    implicit none
!--------------------------------------------------------------------
! Input functions
!--------------------------------------------------------------------
    class(libkrylov_vector_subroutine) ::          krylov_approx
    class(libkrylov_start_subroutine) ::  krylov_start
    class(libkrylov_matrix_subroutine) ::      krylov_rhs
    class(libkrylov_vector_subroutine) ::          krylov_omega
    class(libkrylov_problem_c_subroutine) :: krylov_problem_c
    class(libkrylov_guess_subroutine) ::     krylov_guess
    class(libkrylov_mvp_subroutine) ::       krylov_mvp
    class(libkrylov_precon_subroutine) ::     krylov_precon
    class(libkrylov_output_c_subroutine) ::  krylov_output_c
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
! Split into sections for easier reading
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! variable for error variable
    integer(kind_integer), intent(inout) :: ierr
!! integer for loops
    integer(kind_integer) :: j = 0
!! integer for restart files
    integer(kind_integer) :: k1,k2 = 0
!! integer for iteration counting
    integer(kind_integer) :: jter = 0
!! logical to pass a logic check as an argument
    logical :: check = .false.
!! constants of type base
    type(base) :: one_kb
    type(base) :: zero_kb
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! info to be created by the krylov_a_problem and not changed after
! most of these are used to allocate type(array)
! THESE DEFAULT VALUES SHOULD BE OVERWRITTEN BY DRIVERS
    integer(kind_integer) :: nbasis,minstart,maxstart,nomega,nrhs = 1
!< size of basis = nbasis = n
!< number of guess solutions = nstart = q(1)
!< number of frequencies desired = nomega 
!< number of rhs-sides that are given to the solver = nrhs
!< determines size of rhs
    real(kind_float) :: threshold = real(8,kind=kind_float)
!< threshold = x , numerical approximation 10^(-x)>n~0
!< only for user convergence thresholds
    integer(kind_integer) :: maxiter = 25
!< maximum number of subspace iterations 
    logical :: unique_rhs_omega = .false.
!< if there is a unique rhs provided for each omega.
    character(len=22) :: id_string = 'libkrylov_c'
!< id = ID of the calculation
!< used only for dumping output
    integer(kind_integer) :: iverb = 0
!< verbosity level
    integer(kind_integer) :: irestart = 0
!< restart level (how often restart is dumped on disk,
!< and what is checked)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! The following are determined from the output of krylov%problem
    integer(kind_integer) :: nroots = 0
    integer(kind_integer) :: nstart = 0
!< number of solution vectors, 
!< if nomega=nrhs, nroots= nrhs
!< else nroots = nomega*nrhs
!< nstart = starting subspace
    integer(kind_integer) :: nsubspace = 0
!< size of subspace, extended in krylov_a_extend = nsubspace
    integer(kind_integer) :: maxsubspace = 0
!< max size of subspace
    character(len=32) :: vname = ''
!< file names for unformatted basis_vector restart file
    character(len=32) :: wname = ''
!< file names for unformatted matrix vector product restart file
    character(len=32) :: rname = ''
!< file names for unformatted rhs restart file
    character(len=32) :: sname = ''
!< file names for unformatted solutions save file
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! Arrays that are allocated after krylov problem
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in with the guess of the spectrum
    real(kind_float), allocatable :: approx_spectra(:)
!< approximation of spectra of problem = approx_spectra = D
    real(kind_float), allocatable :: omega(:) 
!< frequencies to be solved for = omega
    type(base), allocatable :: rhs(:,:)
!< RHS of problem = rhs = P
    logical, allocatable :: jconverged(:)
!< logical for determining which roots are converged
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in with before iterations, expanded in expand
    type(base), allocatable :: basis_vectors(:,:)
    type(base), allocatable :: overlap(:,:)
    real(kind_float), allocatable :: diag_overlap(:)
    type(base), allocatable :: cholesky(:,:)
!< basis_vectors = transformation matrix/projector onto subspace /guess vectors = V 
!< overlap = overlap matrix, (V**dagger)(V)
!< diag_overlap = diagonal of overlap matrix, (V**dagger)(V)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    integer(kind_integer) :: iter
!< variable for do loop over iterations of krylov subspace
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at matrix vector products
    type(base), allocatable :: mvproduct(:,:)
!< AV = matrix vector products = mvproduct
    type(base), allocatable :: proj_rhs(:,:)
!< (V^T)P = projected rhs = proj_rhs  
    type(base), allocatable :: rayleigh(:,:)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at krylov_b_ritz
    type(base), allocatable ::  solutions(:,:)
    type(base), allocatable ::  lagrangian(:)
!< solutions = eigenvectors of current subspace calculation that are relevant = x
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    type(base), allocatable :: full_solutions(:,:)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at krylov_a_norms
    type(base), allocatable :: residuals(:,:)
    real(kind_float), allocatable :: euc_norm(:)
    real(kind_float) :: fro_norm
    real(kind_float) :: largest_euc_norm
    integer(kind_integer) :: nresiduals = 0
!< residuals = preconditioned residuals of the approximate solutions 
!< on the full space = \tilde{R}
!< euc_norm = residual euclid norms of eigenvectors
!< max_euc_norm =  max residual euclid norms of eigenvectors
!< fro_norm = residual frobius norms of desired eigenvectors
!< nresiduals = number of non-zero residuals in the current iteration = nresidue
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in at convergence check
    integer(kind_integer) :: nconverged = 0
!< number of converged solutions = nconverged
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!! filled in before extend
    integer(kind_integer) :: prev_nsubspace = 0
!< u = old q from previous iteration = prev_nsubspace
!--------------------------------------------------------------------

!! Begin solver!
    ierr = 0

  ! Determine details of davidson problem to be solved
  ! USER-DEFINED FUNCTION
    call krylov_problem_c%lkl_problem_c(nbasis,nomega,nrhs,&
  &   minstart,maxstart,threshold,maxiter,unique_rhs_omega,&
  &   id_string,iverb,irestart,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_c_problem_subroutine) function failed'
        print *, 'error variable = ',ierr
      end if  
      ierr = -65
      return ! abort solver, return to call
    end if

  if (iverb.ge.0) then
    print *, '////////////////////////////////////////////////'
    print *, 'Non-Orthonormal Krylov Subspace Solver'
    print *, '////////////////////////////////////////////////'
    print *, ' Solving problem type problem_c'
    print *, '////////////////////////////////////////////////'
    print *, ' '
    if (iverb.ge.3) then
      print *, 'Compiler details:'
      print *, 'The basetype is " ',basetype_string,' "'
      print *, 'With precision " ',float_print_string,' "'
      print *, 'with machine precision ',eps
      print *, 'and log10 of machine precision is ',logeps
      print *, ' '
    end if
  end if

! check threshold is above machine precision
    if (-threshold.lt.logeps) then
      if (iverb.ge.0) then
        print *, 'threshold below machine precision, solving failed'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if


! force starting subspace to be at most equal to nbasis
    if (maxstart.gt.nbasis) then
      maxstart = nbasis
      if (iverb.ge.4) then
        print *, 'setting maximum starting subspace',&
  &  'to be equal to number of basis functions'
      end if
    end if

! check that there is at least one rhs
    if (nrhs.le.0) then
      if (iverb.ge.0) then
        print *, 'no right hand sides, solving failed'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if

! check that there is at least one frequency
    if (nomega.le.0) then
      if (iverb.ge.0) then
        print *, 'no frequencies, solving failed'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if

! determine nroots
    if (unique_rhs_omega.and.(nomega.eq.nrhs)) then
      nroots = nomega
      if (iverb.ge.4) then
        print *, 'unique rhs for each frequencey'
        print *, 'total of ',nroots,' roots'
      end if
    else if ((nrhs.eq.1).and.(nomega.eq.1)) then
      nroots = 1
      if (iverb.ge.4) then
        print *, ' one roots will be calculated,'
        print *, ' since only one rhs vector and frequency'
        print *, '  provided!' 
      end if
    else if (nomega.eq.1) then
      nroots = nrhs
      if (iverb.ge.4) then
        print *, nroots,' roots will be calculated,'
        print *, ' all rhs vectors at the one frequency'
        print *, '  provided!' 
      end if
    else if (nrhs.eq.1) then
      nroots = nomega
      if (iverb.ge.4) then
        print *, nroots,' roots will be calculated,'
        print *, ' all frequencies at the one rhs vector'
        print *, '  provided!' 
      end if
    else
      nroots = nomega*nrhs
      if (iverb.ge.4) then
        print *, nroots,' roots will be calculated!'
        print *, ' since number of rhs vectors and frequencies'
        print *, '  do not match!' 
      end if
    end if

! ensure nroots are less than the basis size
    if (nroots.gt.nbasis) then
      if (iverb.ge.4) then
        print *, 'desired roots more than basis, solving failed'
        print *, 'breaking up the problem is advised'
      end if
      ierr = -60
      return ! abort solver, return to call
    end if

! force starting subspace to be at least equal to nroots
    if (minstart.lt.nroots) then
      minstart = nroots
      if (iverb.ge.4) then
        print *, 'setting minimum starting subspace',&
  &    'to be equal to number of desired roots'
      end if
    end if

! allocate diagonal first to determine some features of problem
! to set nstart
    allocate(approx_spectra(nbasis))

! fill approx spectra
    call krylov_approx%vector_fill(nbasis,approx_spectra,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_float_subroutine)function for approx failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -50
      return ! abort solver, return to call
    end if

    call krylov_start%lkl_start(nbasis,nroots,&
  &        approx_spectra,nstart,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_krylov_start_subroutine) function failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -50
      return ! abort solver, return to call!
    end if



! force starting subspace to be at least equal to nroots
    if (nstart.lt.minstart) then
      nstart = minstart
      if (iverb.ge.4) then
        print *, 'setting starting subspace to minimum'
      end if
    end if
! logic check that at least one iteration is possible
    if (nstart.gt.maxstart) then
      nstart = maxstart
      if (iverb.ge.4) then
        print *, 'setting starting subspace to maximum'
      end if
    end if

! Determine max subspace, and check if it is feasible
    maxsubspace = nstart + (maxiter * nroots)

    if (maxsubspace.gt.nbasis) then
      if (iverb.ge.4) then
        print *, 'limiting number of iterations'
        print *, ' to ensure subspace is smaller than full basis'
      end if
      maxsubspace = nbasis
      maxiter = floor((real((nbasis-nstart),kind=kind_float)/&
  &     nroots+real(1,kind=kind_float)),kind=kind_integer)
    end if

!! define file name for restart files
    vname = trim(id_string)//'v.rstrt'
    wname = trim(id_string)//'w.rstrt'
    rname = trim(id_string)//'r.rstrt'
    sname = trim(id_string)//'v.save'


! Set initial subspace size
    nsubspace = nstart


! Allocate all arrays that exist across iterations
    allocate(basis_vectors(nbasis,maxsubspace)) !maximum
    allocate(mvproduct(nbasis,maxsubspace)) !maximum
    allocate(rhs(nbasis,nrhs))
    allocate(proj_rhs(maxsubspace,nrhs)) !maximum
    allocate(rayleigh(maxsubspace,maxsubspace)) !maximum
    allocate(lagrangian(nroots))
    allocate(solutions(maxsubspace,nroots)) !maximum
    allocate(full_solutions(nbasis,nroots))
    allocate(overlap(maxsubspace,maxsubspace)) !maximum
    allocate(cholesky(maxsubspace,maxsubspace)) !maximum
    allocate(omega(nomega)) 
    allocate(diag_overlap(maxsubspace)) !maximum
    allocate(residuals(nbasis,nroots)) !maximum
    allocate(euc_norm(nroots))
    allocate(jconverged(nroots))


!! zero out important quantities
    basis_vectors = real(0,kind=kind_float)
    overlap = real(0,kind=kind_float)
    diag_overlap = real(0,kind=kind_float)
    

    associate(interfacing_rhs => rhs%element)
      call krylov_rhs%matrix_fill(nbasis,nrhs,interfacing_rhs,ierr)
    end associate
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_base_subroutine)function rhs failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -55
      return ! abort solver, return to call
    end if

    call krylov_omega%vector_fill(nomega,omega,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'class(user_base_subroutine)function omega failed'
        print *, 'error variable = ',ierr
      end if
      ierr = -50
      return ! abort solver, return to call
    end if

!! if restart is allowed, look for restart v files
!!  invert irestart if new restart is to be generated
!!   as v-file is missing
!! check can be moved after allocation?
    if (irestart.ge.2) then
      inquire(file=vname,exist=check)
      if (check) then
        call array_read_rstrt_size(vname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no restart available
          ierr = 0
          irestart = -abs(irestart)
        else if (k1.ne.nbasis) then ! vfile not in this basis
          irestart = -abs(irestart)
        else if (k2.lt.nstart) then ! vfile from a different start?
          irestart = -abs(irestart)
        else if (k2.gt.nstart) then ! vfile from iter>1? ! vfile pass all checks
            nstart = k2
            maxiter = floor((real((maxsubspace-nstart),kind=kind_float)/&
  &           nroots+real(1,kind=kind_float)),kind=kind_integer)
        end if ! vfile pass all checks
      else !no restart available or possible
        irestart = -abs(irestart)
      end if
    end if

    if (irestart.ge.2) then !read restart if possible
      if (iverb.ge.2) then
        print *, 'Calculation starting from restart file!'
      end if
      call array_read_rstrt(vname,nbasis,nstart,&
  &     basis_vectors(1:nbasis,1:nstart),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'v.rstrt passed checks but failed to read'
          print *, 'error variable = ',ierr
          print *, 'suggestion: delete v.rstrt'
        end if
        ierr = -50
        return ! abort solver, return to call
      end if
    else if (irestart.eq.0) then !! skip savefile check if no restart
      if (iverb.ge.2) then
        print *, 'Calcuation starting from scratch!'
      end if
      associate(interfacing_bv => basis_vectors%element)
        call krylov_guess%lkl_guess(nbasis,nstart,0,&
  &       approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &       ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_guess_subroutine) function failed' 
          print *, 'error variable = ',ierr
        end if
        ierr = -45
        return ! abort solver, return to call
      end if
    else ! save file if it could be useful
      inquire(file=sname,exist=check)
      if (check) then
        call array_read_rstrt_size(sname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no restart available
          ierr = 0
          irestart = -abs(irestart)
        else if (k1.ne.nbasis) then ! sfile not in this basis
          irestart = -abs(irestart)
        else ! sfile passes all checks, using sfile
          if (iverb.ge.2) then
            print *, 'Calculation starting from save file!'
          end if
          if (k2.gt.nstart) then ! read in only up to nstart vecs
            k2 = nstart
          end if
          call array_read_rstrt(sname,nbasis,k2,&
  &           basis_vectors(1:nbasis,1:k2),iverb,ierr)
          if (ierr.ne.0) then
            if (iverb.ge.0) then
              print *, 'v.save passed checks but failed to read'
              print *, 'error variable = ',ierr
              print *, 'suggestion: delete v.save'
            end if
            ierr = -50
            return ! abort solver, return to call
          end if
          if (k2.eq.nstart) then ! no new initial vectors needed
            if (iverb.ge.2) then
              print *, ' with no new vectors needed!'
            end if
          else ! more initial vectors needed
            if (iverb.ge.2) then
              print *, ' generating more start vectors!'
            end if
            associate(interfacing_bv => basis_vectors%element)
              call krylov_guess%lkl_guess(nbasis,nstart,k2,&
  &             approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &             ierr)
            end associate
            if (ierr.ne.0) then
              if (iverb.ge.0) then
                print *, 'class(user_krylov_guess_subroutine) function failed' 
                print *, 'error variable = ',ierr
              end if
              ierr = -45
              return ! abort solver, return to call
            end if
          end if
        end if
      else !no save file
!! Fresh starting basis vectors generated if 
!! conditions are met.
        irestart = -abs(irestart)
        if (iverb.ge.2) then
          print *, 'Calculation starting from scratch!'
        end if
        associate(interfacing_bv => basis_vectors%element)
          call krylov_guess%lkl_guess(nbasis,nstart,0,&
  &         approx_spectra,interfacing_bv(1:nbasis,1:nstart),&
  &         ierr)
        end associate
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'class(user_krylov_guess_subroutine) function failed' 
            print *, 'error variable = ',ierr
          end if
          ierr = -45
          return ! abort solver, return to call 
        end if
      end if
    end if


! print restart basis-vector products if required
    if (irestart.le.-2) then
      call array_print_rstrt(vname,nbasis,nsubspace,&
  &       basis_vectors(1:nbasis,1:nsubspace),iverb,ierr)
      ierr = 0
    end if


!! Set constants required for BLAS
    one_kb = real(1,kind=kind_float)
    zero_kb = real(0,kind=kind_float)
!! determine overlap
    call ggemm('c','n',nstart,nstart,nbasis,one_kb,&
  &    basis_vectors(1:nbasis,1:nstart),nbasis,&
  &    basis_vectors(1:nbasis,1:nstart),nbasis,&
  &    zero_kb,&
  &    overlap(1:nstart,1:nstart),&
  &    nstart)
!! determine diag_overlap
    do j = 1 , nstart
      diag_overlap(j) = overlap(j,j)
    end do
    call krylov_cholesky(nsubspace,overlap(1:nsubspace,1:nsubspace),&
  &    diag_overlap(1:nsubspace),& 
  &    cholesky(1:nsubspace,1:nsubspace),iverb,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'initial overlap matrix failed cholesky decomposition' 
        print *, 'error variable = ',ierr
      end if
      ierr = -45
      return ! abort solver, return to call 
    end if

!! if restart from mvp is allowed, look for restart w files
!! invert irestart to generate new basis vectors
    if (irestart.ge.3) then
      inquire(file=wname,exist=check)
      if (check) then
        call array_read_rstrt_size(wname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no wfile
          irestart = -abs(irestart)
          ierr = 0
        else if (k1.ne.nbasis) then ! wfile not in this basis
          irestart = -abs(irestart)
        else if (k2.gt.nstart) then ! wfile not matching vfile?
          irestart = -abs(irestart)
        end if
      else ! no wfile
        irestart = -abs(irestart)
      end if
    end if

    if (irestart.le.2) then  !! need to generate new MVP
! call user defined matrix vector product for the first time
      if (iverb.ge.2) then
        print *, ' Fresh Matrix Vector Product!'
      end if
      associate(interfacing_bv => basis_vectors%element, &
  &             interfacing_mv => mvproduct%element)
        call krylov_mvp%lkl_mvp(nbasis,nsubspace,&
  &       interfacing_bv(1:nbasis,1:nsubspace),&
  &       interfacing_mv(1:nbasis,1:nsubspace),ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_mvp_subroutine) function failed' 
          print *, 'before the first iteration'
          print *, 'error variable = ',ierr
        end if
        ierr = -45
        return ! abort solver, return to call
      end if
! print restart matrix-vector products if required
      if (irestart.le.-3) then
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        ierr = 0
      end if
    else ! can read MVP restart, read it!
      if (iverb.ge.2) then
        print *, ' Including restart for matrix vector products!'
      end if
      call array_read_rstrt(wname,nbasis,k2,&
  &       mvproduct(1:nbasis,1:k2),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'w.rstrt passed checks but failed to read'
          print *, 'error variable = ',ierr
          print *, 'suggestion: delete w.rstrt'
        end if
        ierr = -50
        return ! abort solver, return to call
      end if
      if (k2.lt.nstart) then
        if (iverb.ge.2) then
          print *, 'assuming w.rstrt is intact and did not update!'
        end if
        associate(interfacing_bv => basis_vectors%element, &
  &               interfacing_mv => mvproduct%element)
          call krylov_mvp%lkl_mvp(nbasis,(nstart-k2),&
  &         interfacing_bv(1:nbasis,(k2+1):nsubspace),&
  &         interfacing_mv(1:nbasis,(k2+1):nsubspace),ierr)
        end associate
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'class(user_krylov_mvp_subroutine) function failed' 
            print *, 'before the first iteration'
            print *, 'error variable = ',ierr
          end if
          ierr = -45
          return ! abort solver, return to call
        end if
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        ierr = 0
      end if
    end if

    call krylov_rayleigh(nbasis,nsubspace,&
  &     approx_spectra,mvproduct(1:nbasis,1:nsubspace),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     rayleigh(1:nsubspace,1:nsubspace),iverb,ierr)
    if (ierr.ne.0) then
      if (iverb.ge.0) then
        print *, 'initial construction of rayleigh matrix failed' 
        print *, 'error variable = ',ierr
      end if
      ierr = -45
      return ! abort solver, return to call 
    end if

!! if restart for rhs is allowed, look for restart r files
!! invert irestart to generate new basis vectors
    if (irestart.ge.4) then
      inquire(file=rname,exist=check)
      if (check) then
        call array_read_rstrt_size(rname,k1,k2,iverb,ierr)
        if (ierr.ne.0) then ! no rfile
          irestart = -abs(irestart)
          ierr = 0
        else if (k1.gt.nstart) then ! rfile not matching vfile?
          irestart = -abs(irestart)
        else if (k2.ne.nrhs) then ! rfile not matching problem?
          irestart = -abs(irestart)
        end if
      else ! no rfile
        irestart = -abs(irestart)
      end if
    end if

    if (irestart.le.3) then  !! need to generate new RHS
      if (iverb.ge.2) then
        print *, ' Fresh Projected RHS!'
      end if
      one_kb = real(1,kind=kind_float)
      zero_kb = real(0,kind=kind_float)
      call ggemm('c','n',nsubspace,nrhs,nbasis,one_kb,&
&       basis_vectors(1:nbasis,1:nsubspace),nbasis,&
&       rhs(1:nbasis,1:nrhs),nbasis,&
&       zero_kb,&
&       proj_rhs(1:nsubspace,1:nrhs),&
&       nsubspace)
! print restart matrix-vector products if required
      if (irestart.le.-4) then
        call array_print_rstrt(rname,nsubspace,nrhs,&
  &       proj_rhs(1:nsubspace,1:nrhs),iverb,ierr)
        ierr = 0
      end if
    else ! can read proj_rhs restart, read it!
      if (iverb.ge.2) then
        print *, ' Including restart for projected RHS!'
      end if
      call array_read_rstrt(rname,k1,nrhs,&
  &       proj_rhs(1:k1,1:nrhs),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'r.rstrt passed checks but failed to read'
          print *, 'error variable = ',ierr
          print *, 'suggestion: delete r.rstrt'
        end if
        ierr = -50
        return ! abort solver, return to call
      end if
      if (k1.lt.nstart) then
        if (iverb.ge.2) then
          print *, 'assuming r.rstrt is intact and did not update!'
        end if
        one_kb = real(1,kind=kind_float)
        zero_kb = real(0,kind=kind_float)
        call ggemm('c','n',(nstart-k1),nrhs,nbasis,one_kb,&
&         basis_vectors(1:nbasis,(k1+1):nsubspace),nbasis,&
&         rhs(1:nbasis,1:nrhs),nbasis,&
&         zero_kb,&
&         proj_rhs((k1+1):nsubspace,1:nrhs),&
&         nsubspace)
        call array_print_rstrt(rname,nsubspace,nrhs,&
  &       proj_rhs(1:nsubspace,1:nrhs),iverb,ierr)
        ierr = 0
      end if
    end if

! reset irestart to normal operation
    irestart = abs(irestart)

!! check projected rhs are unique - otherwise residuals will 
!! be linearly dependent
    if (nrhs.gt.1) then
      call krylov_unique(nstart,nrhs,&
  &     proj_rhs(1:nstart,1:nrhs),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.gt.0) then
          print *, 'projecting rhs failed'
          print *, '  the rhs could be identical'
          print *, '   otherwise the basis could be the problem'
        end if
        return
      end if
    end if

    if (iverb.ge.1) then
      print *, ''
      print *, 'convergence criteria: 10^(-',threshold,')'
      print *, 'initial subspace:  ',nstart
      print *, 'full vector space: ',nbasis
      print *, 'maximum number of iterations: ',maxiter
      print *, ' '
    end if

! SOLVER LOOP
    jter = 0
    do iter = 1, maxiter


! Check for kill file
      inquire(file=kill_file_string,exist=check)
      if (check) then
        if (iverb.ge.0) then
          print *, 'kill file exist, libkrylov killed'
          if (iverb.ge.3) then
            print *, 'kill file is ',kill_file_string
          end if
        end if
        ierr = -40
        return ! abort solver, return to call
      end if

      jter = jter + 1

      if (iverb.ge.0) then
        print *, '~~~~~Iteration (',iter,')~~~~~'
        if (iverb.ge.1) then
          print *, 'current sub space: ',nsubspace
        end if
      end if

! call krylov ritz subroutine
      call krylov_c_ritz(nbasis,nsubspace,nomega,nrhs,nroots,&
  &     rayleigh(1:nsubspace,1:nsubspace),&
  &     cholesky(1:nsubspace,1:nsubspace),&
  &     proj_rhs(1:nsubspace,1:nrhs),&
  &     overlap(1:nsubspace,1:nsubspace),diag_overlap(1:nsubspace),&
  &     omega,lagrangian,solutions(1:nsubspace,1:nroots),iverb,ierr)
      if (ierr.eq.-35) then ! error variable for ill-conditioned overlap
        nsubspace = prev_nsubspace
        if (iverb.ge.0) then
          print *, 'preparation for krylov ritz(subspace solve) failed'
          print *, 'error variable = ',ierr
        end if
        if (iter.gt.1) then
          if (iverb.ge.0) then
            print *, 'using previous subspace solutions for print'
          end if
          ierr = 0
        end if
        exit ! This exits subspace loop
      else if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov ritz(subspace solve) calculation failed'
          print *, 'error variable = ',ierr
        end if
        ierr = -40
        exit ! This exits subspace loop
      end if

!! calculation of solutions on full space
      call ggemm('n','n',nbasis,nroots,nsubspace,one_kb,&
  &      basis_vectors,nbasis,&
  &      solutions,maxsubspace,&
  &      zero_kb,&
  &      full_solutions,&
  &      nbasis)

! call krylov norms subroutine
      call krylov_c_norms(nbasis,nsubspace,nomega,nrhs,nroots,&
  &     mvproduct(1:nbasis,1:nsubspace),& 
  &     basis_vectors(1:nbasis,1:nsubspace),full_solutions,& 
  &     solutions(1:nsubspace,1:nroots),&
  &     overlap(1:nsubspace,1:nsubspace),&
  &     omega,rhs,approx_spectra,krylov_precon,&
  &     residuals,euc_norm,largest_euc_norm,&
  &     fro_norm,nresiduals,iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov norms calculation failed'
          print *, 'error variable = ',ierr
        end if 
        ierr = -40
        exit ! This exits subspace loop
      end if

! determine convergence of solutions based on euclidean norm
      nconverged = 0
      jconverged = .false.
      do j = 1 , nroots
        if ((-threshold).gt.log10(euc_norm(j))) then
          nconverged = nconverged + 1
          jconverged(j) = .true.
        end if
      end do
      if (iverb.ge.2) then
        print *, 'converged vectors: ', nconverged
      end if

! determine convergence of solutions based on frobenius norm
! The stricter test, this is done before check by euclidean norms
      if ((-threshold).gt.log10(fro_norm)) then
        if (iverb.ge.1) then
          print *, 'Converged by frobenius norm!'
        end if
        exit ! This exits subspace loop
      end if

! determine convergence of solutions based on nconverged
      if (nconverged.ge.nroots) then
        if (iverb.ge.1) then
          print *, 'Converged by euclidean norm!'
        end if
        exit ! This exits subspace loop
      end if

! convergence checks failed when this line is reached
      if (iverb.ge.2) then
        print *, 'More iterations required for desired convergence!'
      end if

! check that more iterations are allowed before extending subspace
      if (iter.eq.maxiter) then
        if (iverb.ge.0) then
          print *, 'failed to converge within max number of iterations'
        end if
        exit ! This exits subspace loop
      end if

! Check that there are residuals to extend the subspace with
      if (nresiduals.eq.0) then
        if (iverb.ge.0) then
          print *, 'No preconditioned residuals above machine precision!'
          print *, 'failed to find vectors to expand subspace!'
        end if
        exit ! This exits subspace loop
      end if

! Check for stop file
      inquire(file=stop_file_string,exist=check)
      if (check) then
        if (iverb.ge.0) then
          print *, 'stop file exist, libkrylov stopped'
          if (iverb.ge.3) then
            print *, 'stop file is ',stop_file_string
          end if
        end if
        exit ! exit subspace loop
      end if

! call krylov extend subroutine, after saving prev_nsubspace
      prev_nsubspace = nsubspace
      nsubspace = nsubspace + nresiduals  
      call krylov_extend(nbasis,nsubspace,&
  &     nresiduals,prev_nsubspace,&
  &     residuals(1:nbasis,1:nresiduals),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     overlap(1:nsubspace,1:nsubspace),&
  &     diag_overlap(1:nsubspace),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'krylov subspace expansion failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        nsubspace = prev_nsubspace
        ierr = 0
        exit ! This exits subspace loop
      end if

! cholesky decomposition of matrix
      call krylov_cholesky(nsubspace,overlap(1:nsubspace,1:nsubspace),&
  &     diag_overlap(1:nsubspace),& 
  &     cholesky(1:nsubspace,1:nsubspace),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'new krylov subspace failed stability check'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        nsubspace = prev_nsubspace
        ierr = 0
        exit ! This exits subspace loop
      end if

! print restart basis-vectors if required
      if (irestart.ge.2) then
        call array_print_rstrt(vname,nbasis,nsubspace,&
  &       basis_vectors(1:nbasis,1:nsubspace),iverb,ierr)
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'unable to print v restart files'
            ierr = 0
          end if
        end if
      end if

!! need to increase RHS as well
      call ggemm('c','n',nresiduals,nrhs,nbasis,one_kb,&
  &     basis_vectors(1:nbasis,(prev_nsubspace+1):nsubspace),nbasis,&
  &     rhs(1:nbasis,1:nrhs),nbasis,&
  &     zero_kb,&
  &     proj_rhs((prev_nsubspace+1):nsubspace,1:nrhs),&
  &     nresiduals)

! print restart proj_rhs if required
      if (irestart.ge.4) then
        call array_print_rstrt(rname,nsubspace,nrhs,&
  &       proj_rhs(1:nsubspace,1:nrhs),iverb,ierr)
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'unable to print r restart files'
            ierr = 0
          end if
        end if
      end if


! spacer
      if (iverb.ge.0) then
        print *, ' '
      end if

! call user defined matrix vector product
      associate(interfacing_bv => basis_vectors%element, &
  &             interfacing_mv => mvproduct%element)
        call krylov_mvp%lkl_mvp(nbasis,nresiduals,&
  &       interfacing_bv(1:nbasis,(prev_nsubspace+1):nsubspace),&
  &       interfacing_mv(1:nbasis,(prev_nsubspace+1):nsubspace),ierr)
      end associate
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_mvp_subroutine) function failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        ierr = 0
        nsubspace = prev_nsubspace
        exit ! This exits subspace loop
      end if

! print restart if required
      if (irestart.ge.3) then
        call array_print_rstrt(wname,nbasis,nsubspace,&
  &       mvproduct(1:nbasis,1:nsubspace),iverb,ierr)
        if (ierr.ne.0) then
          if (iverb.ge.0) then
            print *, 'unable to print w restart files'
            ierr = 0
          end if
        end if
      end if

! expand rayleigh matrix
      call krylov_expand(nbasis,nsubspace,&
  &     nresiduals,prev_nsubspace,&
  &     approx_spectra,mvproduct(1:nbasis,1:nsubspace),&
  &     basis_vectors(1:nbasis,1:nsubspace),&
  &     rayleigh(1:nsubspace,1:nsubspace),iverb,ierr)
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'expanding rayleigh matrix failed'
          print *, 'error variable = ',ierr
          print *, 'using previous subspace solutions for print'
        end if
        ierr = 0
        nsubspace = prev_nsubspace
        exit ! This exits subspace loop
      end if

    end do ! krylov subspace loop ends

! spacer
    if (iverb.ge.0) then
      print *, ' '
        if (iverb.ge.2) then
          print *, 'number of iterations: ',jter
          print *, ' '
        end if
    end if

! Check for kill file
    inquire(file=kill_file_string,exist=check)
    if (check) then
      if (iverb.ge.0) then
        print *, 'kill file exist, libkrylov killed'
        if (iverb.ge.3) then
          print *, 'kill file is ',kill_file_string
        end if
      end if
      ierr = -40
      return ! abort solver, return to call
    end if


!  check status of calculation, call appropriate ending tasks
    if (ierr.ne.0) then ! serious error somewhere in the calculation
      if (iverb.ge.0) then
        print *, 'quality of values unknown,'
        print *, 'old save file not overwritten,'
        print *, 'class(user_krylov_a_output_subroutine) not called'
      end if
    else ! iterations exited with no serious errors, possible useful data!
      if (irestart.ge.1) then ! user asked for save files
        call array_print_rstrt(sname,nbasis,nroots,&
  &       full_solutions(1:nbasis,1:nroots),iverb,ierr)
        if (ierr.eq.0) then ! save file printed! safe to delete restart
          if (irestart.ge.2) then
            call array_del_rstrt(vname,iverb,ierr)
            ! no check for ierr, no action on fail
            ierr = 0
            if (irestart.ge.3) then
              call array_del_rstrt(wname,iverb,ierr)
              ! no check for ierr, no action on fail
              ierr = 0
              if (irestart.ge.4) then
                call array_del_rstrt(rname,iverb,ierr)
                ! no check for ierr, no action on fail
                ierr = 0
              end if
            end if
          end if
        else ! something wrong with printing save, don't delete files
          if (iverb.ge.0) then
            print *, 'unable to print save file'
          end if
!reset ierr, no matter what happened in restart
          ierr = 0
        end if
      end if
!! call user output function
      associate(interfacing_rhs => rhs%element, &
  &             interfacing_lg => lagrangian%element, &
  &             interfacing_fs => full_solutions%element)
        call krylov_output_c%lkl_output_c(nbasis,nsubspace,nomega,nrhs,&
  &       nroots,nconverged,jconverged,omega,interfacing_rhs,&
  &       interfacing_lg(1:nroots),&
  &       interfacing_fs(1:nbasis,1:nroots),&
  &       euc_norm(1:nroots),fro_norm,id_string,ierr)
      end associate
!! final ierr check and adjustments
      if (ierr.ne.0) then
        if (iverb.ge.0) then
          print *, 'class(user_krylov_output_subroutine) function failed'
        end if
        ierr = -20
      else if (nconverged.le.0) then !only if ierr .eq. 0
        if (iverb.ge.0) then
          print *, 'solver produced no solutions'
        end if
        ierr = -15
      else if (nconverged.lt.nroots) then !only if output function works
        if (iverb.ge.1) then
          print *, 'not all desired solutions produced'
          print *, 'ierr contains number of solutions printed'
        end if
        ierr = nconverged
      end if
    end if

    deallocate(basis_vectors)
    deallocate(mvproduct)
    deallocate(approx_spectra)
    deallocate(rhs)
    deallocate(proj_rhs)
    deallocate(rayleigh)
    deallocate(lagrangian)
    deallocate(solutions)
    deallocate(full_solutions)
    deallocate(overlap)
    deallocate(cholesky)
    deallocate(omega)
    deallocate(diag_overlap)
    deallocate(residuals)
    deallocate(euc_norm)
    deallocate(jconverged)

    if (iverb.ge.0) then
      print *, '////////////////////////////////////////////////'
      print *, 'Solver Done'
      print *, '////////////////////////////////////////////////'
    end if

!--------------------------------------------------------------------
!--------------------------------------------------------------------
  end subroutine problem_c_solver
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!--------------------------------------------------------------------
end module libkrylovsolver
!--------------------------------------------------------------------
!--------------------------------------------------------------------
