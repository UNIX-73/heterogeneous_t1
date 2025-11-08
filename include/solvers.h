#pragma once

#include <stdbool.h>
#include <stddef.h>

void cpu_solve(size_t m, size_t n, float *matrix, float *vec, float *out);

void gpu_solve(size_t m, size_t n, float *matrix, float *vec, float *out);

bool equal_matrices(size_t m, size_t n, float *a, float *b);
