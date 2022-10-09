#include <string.h>

#include "ckrylov.h"
#include "ctesting.h"

int main() {
  int_t error, value_len = 256, length;
  char_t value[value_len];

  error = ckrylov_initialize();
  CHECK(error == CKRYLOV_OK);

  char_t key1[] = "enum", values1[] = "a;b";
  error =
      ckrylov_define_enum_option(key1, strlen(key1), values1, strlen(values1));
  CHECK(error == CKRYLOV_OK);

  char_t value1[] = "a", value2[] = "b", value3[] = "c";
  error =
      ckrylov_validate_enum_option(key1, strlen(key1), value1, strlen(value1));
  CHECK(error == CKRYLOV_OK);
  error =
      ckrylov_validate_enum_option(key1, strlen(key1), value2, strlen(value2));
  CHECK(error == CKRYLOV_OK);
  error =
      ckrylov_validate_enum_option(key1, strlen(key1), value3, strlen(value3));
  CHECK(error == CKRYLOV_INVALID_OPTION);

  char_t key2[] = "missing";
  error =
      ckrylov_validate_enum_option(key2, strlen(key2), value1, strlen(value1));
  CHECK(error == CKRYLOV_NO_SUCH_OPTION);

  error = ckrylov_set_enum_option(key1, strlen(key1), value1, strlen(value1));
  CHECK(error == CKRYLOV_OK);

  error = ckrylov_set_enum_option(key1, strlen(key1), value3, strlen(value3));
  CHECK(error == CKRYLOV_INVALID_OPTION);

  error = ckrylov_get_enum_option(key1, strlen(key1), value, value_len);
  CHECK(error == CKRYLOV_OK);
  CHECK(strncmp(value, value1, strlen(value1)) == 0);

  length = ckrylov_length_enum_option(key1, strlen(key1));
  CHECK(length == 1);

  error = ckrylov_get_enum_option(key2, strlen(key2), value, value_len);
  CHECK(error == CKRYLOV_NO_SUCH_OPTION);
  CHECK(strncmp(value, "", 1) == 0);

  length = ckrylov_length_enum_option(key2, strlen(key2));
  CHECK(length == CKRYLOV_NO_SUCH_OPTION);

  error = ckrylov_finalize();
  CHECK(error == CKRYLOV_OK);

  PASS();
}
