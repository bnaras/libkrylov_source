#include <stdio.h>
#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, index, value_len = 256, length;
  char_t value[value_len];

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t kind[] = CKRYLOV_REAL_KIND, structure[] = CKRYLOV_SYMMETRIC_STRUCTURE,
         equation[] = CKRYLOV_EIGENVALUE_EQUATION;
  int_t full_dim = 100, solution_dim = 2, basis_dim = 3;
  index = ckrylov_add_space(kind, strlen(kind), structure, strlen(structure),
                            equation, strlen(equation), full_dim, solution_dim,
                            basis_dim);
  CHECK(index == 1);

  char_t key1[] = "enum", values1[] = "a;b";
  error = ckrylov_define_space_enum_option(index, key1, strlen(key1), values1,
                                           strlen(values1));
  CHECK(error == CKRYLOV_OK);

  char_t value1[] = "a", value2[] = "b", value3[] = "c";
  error = ckrylov_validate_space_enum_option(index, key1, strlen(key1), value1,
                                             strlen(value1));
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_validate_space_enum_option(index, key1, strlen(key1), value2,
                                             strlen(value2));
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_validate_space_enum_option(index, key1, strlen(key1), value3,
                                             strlen(value3));
  CHECK(error == CKRYLOV_INVALID_OPTION);

  char_t key2[] = "missing";
  error = ckrylov_validate_space_enum_option(index, key2, strlen(key2), value1,
                                             strlen(value1));
  CHECK(error == CKRYLOV_NO_SUCH_OPTION);

  error = ckrylov_set_space_enum_option(index, key1, strlen(key1), value1,
                                        strlen(value1));
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_set_space_enum_option(index, key1, strlen(key1), value3,
                                        strlen(value3));
  CHECK(error == CKRYLOV_INVALID_OPTION);

  error = ckrylov_get_space_enum_option(index, key1, strlen(key1), value,
                                        value_len);
  CHECK(error == CKRYLOV_OK);
  CHECK(strncmp(value, value1, strlen(value1)) == 0);

  length = ckrylov_length_space_enum_option(index, key1, strlen(key1));
  CHECK(length == 1);

  error = ckrylov_get_space_enum_option(index, key2, strlen(key2), value,
                                        value_len);
  CHECK(error == CKRYLOV_NO_SUCH_OPTION);
  CHECK(strncmp(value, "", 1) == 0);

  length = ckrylov_length_space_enum_option(index, key2, strlen(key2));
  CHECK(length == CKRYLOV_NO_SUCH_OPTION);

  index = 2;
  error = ckrylov_validate_space_enum_option(index, key1, strlen(key1), value1,
                                             strlen(value1));
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_set_space_enum_option(index, key1, strlen(key1), value1,
                                        strlen(value1));
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_get_space_enum_option(index, key1, strlen(key1), value,
                                        value_len);
  CHECK(error == CKRYLOV_NO_SUCH_SPACE);
  CHECK(strncmp(value, "", 1) == 0);

  length = ckrylov_length_space_enum_option(index, key1, strlen(key1));
  CHECK(length == CKRYLOV_NO_SUCH_SPACE);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
