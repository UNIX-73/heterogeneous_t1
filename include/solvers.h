#pragma once

#include <stdbool.h>
#include <stddef.h>

void cpu_solve(size_t m, size_t n, float *matrix, float *vec, float *out);

void gpu_solve(size_t m, size_t n, float *matrix, float *vec, float *out, size_t blk_size);

bool arrays_are_equal(size_t size, float *a, float *b);
