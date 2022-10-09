#ifndef CTESTING_H_
#define CTESTING_H_

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <tgmath.h>

#include "ctypes.h"

#define CHECK(COND)                                                      \
  do {                                                                   \
    if (!(COND)) {                                                       \
      fprintf(stderr, "Assertion failed: %s (%s:%d)\n", #COND, __FILE__, \
              __LINE__);                                                 \
      exit(EXIT_FAILURE);                                                \
    }                                                                    \
  } while (0)

#define PASS()          \
  do {                  \
    exit(EXIT_SUCCESS); \
  } while (0)

#define DEFAULT_THR (100.0 * REAL_EPSILON)

void fix_phase_real(real_t *a, int_t n, real_t *a_out, real_t thr) {
  for (int_t i = 0; i < n; ++i) {
    a_out[i] = a[i];
  }

  int_t first;
  for (first = 0; first < n; ++first) {
    if (fabs(a_out[first]) >= thr) break;
  }

  if (first < n && a_out[first] < -thr) {
    for (int_t i = first; i < n; ++i) {
      a_out[i] *= (-1);
    }
  }
}

void fix_phase_complex(complex_t *a, int_t n, complex_t *a_out, real_t thr) {
  for (int_t i = 0; i < n; ++i) {
    a_out[i] = a[i];
  }

  int_t first;
  for (first = 0; first < n; ++first) {
    if (fabs(a_out[first]) >= thr) break;
  }

  if (first < n) {
    real_t theta = carg(a_out[first]);
    complex_t fac = cos(theta) - sin(theta) * I;
    for (int_t i = first; i < n; ++i) {
      a_out[i] *= fac;
    }
  }
}

bool_t near_real_by_thr_with_phase(real_t *a, real_t *b, int_t n, real_t thr,
                                   bool_t fix_phase) {
  bool_t eq = true;
  real_t *a1, *b1;

  if (fix_phase) {
    a1 = (real_t *)malloc(n * sizeof(real_t));
    fix_phase_real(a, n, a1, thr);
    b1 = (real_t *)malloc(n * sizeof(real_t));
    fix_phase_real(b, n, b1, thr);
  } else {
    a1 = a;
    b1 = b;
  }

  for (int_t i = 0; i < n; ++i) {
    if (fabs(a1[i] - b1[i]) > thr) {
      eq = false;
      break;
    }
  }

  if (fix_phase) {
    free(a1);
    free(b1);
  }

  return eq;
}

bool_t near_real_by_thr(real_t *a, real_t *b, int_t n, real_t thr) {
  return near_real_by_thr_with_phase(a, b, n, thr, false);
}

bool_t near_real_with_phase(real_t *a, real_t *b, int_t n, bool_t fix_phase) {
  return near_real_by_thr_with_phase(a, b, n, DEFAULT_THR, fix_phase);
}

bool_t near_real(real_t *a, real_t *b, int_t n) {
  return near_real_by_thr_with_phase(a, b, n, DEFAULT_THR, false);
}

bool_t near_complex_by_thr_with_phase(complex_t *a, complex_t *b, int_t n,
                                      real_t thr, bool_t fix_phase) {
  bool_t eq = true;
  complex_t *a1, *b1;

  if (fix_phase) {
    a1 = (complex_t *)malloc(n * sizeof(complex_t));
    fix_phase_complex(a, n, a1, thr);
    b1 = (complex_t *)malloc(n * sizeof(complex_t));
    fix_phase_complex(b, n, b1, thr);
  } else {
    a1 = a;
    b1 = b;
  }

  for (int_t i = 0; i < n; ++i) {
    if (fabs(a1[i] - b1[i]) > thr) {
      eq = false;
      break;
    }
  }

  if (fix_phase) {
    free(a1);
    free(b1);
  }

  return eq;
}

bool_t near_complex_by_thr(complex_t *a, complex_t *b, int_t n, real_t thr) {
  return near_complex_by_thr_with_phase(a, b, n, thr, false);
}

bool_t near_complex_with_phase(complex_t *a, complex_t *b, int_t n,
                               bool_t fix_phase) {
  return near_complex_by_thr_with_phase(a, b, n, DEFAULT_THR, fix_phase);
}

bool_t near_complex(complex_t *a, complex_t *b, int_t n) {
  return near_complex_by_thr_with_phase(a, b, n, DEFAULT_THR, false);
}

#endif /* CTESTING_H_ */
