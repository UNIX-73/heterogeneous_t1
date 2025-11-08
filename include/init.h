#pragma once

#include <stddef.h>

#define MATRICES_N 4

#define declare_matrix_and_vec(m_size, n_size)                                                     \
	MatrixAndVec m_##m_size##_##n_size = {                                                         \
		.m = m_size,                                                                               \
		.n = n_size,                                                                               \
		.matrix = NULL,                                                                            \
		.vec = NULL,                                                                               \
	}

typedef struct
{
	size_t m;
	size_t n;
	float *matrix;
	float *vec;
} MatrixAndVec;

extern MatrixAndVec *matrices[MATRICES_N];

void alloc_matrices();