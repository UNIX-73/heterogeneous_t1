#include <cstdio>
#include <solvers.h>
#include <stddef.h>

bool equal_matrices(size_t m, size_t n, float *a, float *b)
{
	size_t size = m * n;

	for (size_t i = 0; i < size; i++)
	{
		if (a[i] != b[i])
		{
			printf("matrix not equal at i %ld", i);
			return false;
		}
	}
	return true;
}

void cpu_solve(size_t m, size_t n, float *matrix, float *vec, float *out)
{
	for (size_t row = 0; row < m; row++)
	{
		float result = 0.0;

		for (size_t col = 0; col < n; col++)
			result += matrix[row * n + col] * vec[col];

		out[row] = result;
	}
}

void gpu_solve(size_t m, size_t n, float *matrix, float *vec, float *out)
{
}

__global__ void gpu_solve_kernel(size_t m, size_t n, float *matrix, float *vec, float *out)
{
	
}
