!--------------------------------------------------------------------
!--------------------------------------------------------------------
program restart_check
!--------------------------------------------------------------------
!--------------------------------------------------------------------
!
!--------------------------------------------------------------------
!< Description:
!< This program checks the restart files in the current directory,
!< printing to screen the status
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
! with elementary functions and BLAS calls
  use basetypes
  use blastypes
! the generic interface for krylov subspace routines
  use libkrylovsolver
!--------------------------------------------------------------------
! Implicit none
!--------------------------------------------------------------------
!
  implicit none
!
!--------------------------------------------------------------------
! Local Variables
!--------------------------------------------------------------------
!! variable for error variable
  integer(kind_integer) :: ierr = 0
!! integer for restart files
  integer(kind_integer) :: j1,j2,k1,k2 = 0
!! logical to pass a logic check as an arguement
    logical :: check = .false.
!< if there is a unique rhs provided for each omega.
    character(len=22) :: id_string = ''
    integer(kind_integer) :: iverb = 0
    character(len=32) :: vname = ''
!< file names for unformatted basis_vector restart file
    character(len=32) :: wname = ''
!< file names for unformatted matrix vector product restart file
    character(len=32) :: rname = ''
!< file names for unformatted rhs restart file
    character(len=32) :: sname = ''
!< file names for unformatted solutions save file
!--------------------------------------------------------------------

    iverb = 5

    print *, '////////////////////////////////////////////////'
    print *, 'Non-Orthonormal Krylov Subspace Solver'
    print *, '////////////////////////////////////////////////'
    print *, ' RESTART SANITY CHECKER'
    print *, '////////////////////////////////////////////////'
    print *, ' '
    print *, 'Compiler details:'
    print *, 'The basetype is " ',basetype_string,' "'
    print *, 'With precision " ',float_print_string,' "'
    print *, 'with machine precision ',eps
    print *, 'and log10 of machine precision is ',logeps
    print *, ' '

    print *, 'Please enter the id_string of files to test'
    read (*,*) id_string
    print *, id_string,' entered'

!! define file name for restart files
    vname = trim(id_string)//'v.rstrt'
    wname = trim(id_string)//'w.rstrt'
    rname = trim(id_string)//'r.rstrt'
    sname = trim(id_string)//'v.save'

    print *, 'Checking if irestart = 1 is feasible (v.save)'
    inquire(file=sname,exist=check)
    if (check) then
      call array_read_rstrt_size(sname,k1,k2,iverb,ierr)
      if (ierr.ne.0) then ! no save file,
        print *, 'basis vector save error'
        print *, 'restart not feasible'
        ierr = 0
      else
        print *, 'basis size is ',k1
        print *, 'number of vectors saved is ',k2
        print *, 'restart feasible'
      end if
    else
      print *, 'v.save file does not exist'
      print *, 'restart not feasible'
    end if

    print *, 'Checking if irestart = 2 is feasible (v.rstrt)'
    inquire(file=vname,exist=check)
    if (check) then
      call array_read_rstrt_size(vname,k1,k2,iverb,ierr)
      if (ierr.ne.0) then ! no save file,
        print *, 'basis vector rstrt error'
        print *, 'restart not feasible'
        stop
      else
        print *, 'basis size is ',k1
        print *, 'number vectors in restart is ',k2
        print *, 'restart feasible'
      end if
    else
      print *, 'v.rstrt file does not exist'
      print *, 'restart not feasible'
      stop
    end if

    print *, 'Checking if irestart = 3 is feasible (w.rstrt)'
    inquire(file=wname,exist=check)
    if (check) then
      call array_read_rstrt_size(vname,j1,j2,iverb,ierr)
      if (ierr.ne.0) then ! no save file,
        print *, 'mvproduct rstrt error'
        print *, 'restart not feasible'
        stop
      else
        print *, 'basis size is ',j1
        print *, 'number vectors in restart is ',j2
        if (j1.ne.k1) then
          print *, 'v.rstrt and w.rstrt have different basis'
          print *, 'restart not feasible'
          stop
        else if (j2.gt.k2) then
          print *, 'w.rstrt has more vectors than v.rstrt'
          print *, 'restart not feasible'
          stop
        else if (j2.lt.k2) then
          print *, 'v.rstrt has more vectors than w.rstrt'
          print *, 'proceed cautiously'
        else
          print *, 'restart feasible'
        end if
      end if
    else
      print *, 'w.rstrt file does not exist'
      print *, 'restart not feasible'
      stop
    end if

    print *, 'Checking if irestart = 4 is feasible (r.rstrt)'
    inquire(file=rname,exist=check)
    if (check) then
      call array_read_rstrt_size(rname,j1,j2,iverb,ierr)
      if (ierr.ne.0) then ! no save file,
        print *, 'projected rhs rstrt error'
        print *, 'restart not feasible'
        stop
      else
        print *, 'number of rhs vectors is ',j2
        print *, 'number basis vectors in restart is ',j1
        if (j1.gt.k2) then
          print *, 'r.rstrt has more vectors than v.rstrt'
          print *, 'restart not feasible'
          stop
        else if (j1.lt.k2) then
          print *, 'v.rstrt has more vectors than r.rstrt'
          print *, 'proceed cautiously'
        else
          print *, 'restart feasible'
        end if
      end if
    else
      print *, 'r.rstrt file does not exist'
      print *, 'restart not feasible'
      stop
    end if

!--------------------------------------------------------------------
!--------------------------------------------------------------------
end program restart_check
!--------------------------------------------------------------------
!--------------------------------------------------------------------
