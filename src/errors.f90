module errors

    use kinds, only: IK
    implicit none

    integer(IK), parameter :: OK = 0_IK

    integer(IK), parameter :: NO_OPTIONS = -101_IK
    integer(IK), parameter :: NO_SUCH_OPTION = -102_IK
    integer(IK), parameter :: INVALID_OPTION = -103_IK
    integer(IK), parameter :: INVALID_KIND = -104_IK
    integer(IK), parameter :: INVALID_STRUCTURE = -105_IK
    integer(IK), parameter :: INVALID_EQUATION = -106_IK
    integer(IK), parameter :: INVALID_DIMENSION = -107_IK
    integer(IK), parameter :: INVALID_INPUT = -108_IK

    integer(IK), parameter :: NO_SPACES = -201_IK
    integer(IK), parameter :: NO_SUCH_SPACE = -202_IK
    integer(IK), parameter :: INCOMPATIBLE_SPACE = -203_IK
    integer(IK), parameter :: NOTHING_TO_DO = -204_IK
    integer(IK), parameter :: NO_ITERATIONS = -205_IK
    integer(IK), parameter :: NO_SUCH_ITERATION = -206_IK
    integer(IK), parameter :: NO_SOLUTIONS = -207_IK
    integer(IK), parameter :: NO_SUCH_SOLUTION = -208_IK
    integer(IK), parameter :: INVALID_CONFIGURATION = -209_IK
    integer(IK), parameter :: INCOMPLETE_CONFIGURATION = -210_IK
    integer(IK), parameter :: INCOMPATIBLE_CONFIG = -211_IK
    integer(IK), parameter :: INCOMPATIBLE_EQUATION = -212_IK
    integer(IK), parameter :: INCOMPLETE_EQUATION = -213_IK
    integer(IK), parameter :: INCOMPATIBLE_PRECONDITIONER = -214_IK
    integer(IK), parameter :: INCOMPLETE_PRECONDITIONER = -215_IK
    integer(IK), parameter :: INCOMPATIBLE_ORTHONORMALIZER = -216_IK

    integer(IK), parameter :: LINEAR_ALGEBRA_ERROR = -301_IK

    integer(IK), parameter :: NOT_CONVERGED = -401_IK
    integer(IK), parameter :: MAX_ITERATIONS_REACHED = -402_IK
    integer(IK), parameter :: MAX_DIM_REACHED = -403_IK
    integer(IK), parameter :: ILL_CONDITIONED = -404_IK
    integer(IK), parameter :: NO_BASIS_UPDATE = -405_IK
    integer(IK), parameter :: LINEARLY_DEPENDENT_BASIS = -406_IK

    integer(IK), parameter :: KEY_NOT_FOUND = -501_IK

end module errors
