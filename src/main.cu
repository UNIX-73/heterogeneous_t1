#include <cstdlib>
#include <init.h>
#include <solvers.h>
#include <stddef.h>
#include <stdio.h>

float *cpu_result, *gpu_result32, *gpu_result64, *gpu_result128;

int main()
{
	alloc_matrices();

	for (size_t i = 0; i < MATRICES_N; i++)
	{
		cpu_result = (float *)malloc(sizeof(float) * matrices[i]->m);
		gpu_result32 = (float *)malloc(sizeof(float) * matrices[i]->m);
		gpu_result64 = (float *)malloc(sizeof(float) * matrices[i]->m);
		gpu_result128 = (float *)malloc(sizeof(float) * matrices[i]->m);

		for (size_t j = 0; j < matrices[i]->m; j++)
		{
			cpu_result[j] = 0.0;
			gpu_result32[j] = 0.0;
			gpu_result64[j] = 0.0;
			gpu_result128[j] = 0.0;
		}

		printf("--- MATRIX SIZE (MxN) %ldx%ld ---\n", matrices[i]->m, matrices[i]->n);

		cpu_solve(matrices[i]->m, matrices[i]->n, matrices[i]->matrix, matrices[i]->vec,
				  cpu_result);

		printf("[Threads per block 32]");
		gpu_solve(matrices[i]->m, matrices[i]->n, matrices[i]->matrix, matrices[i]->vec,
				  gpu_result32, 32);

		printf("[Threads per block 64]");
		gpu_solve(matrices[i]->m, matrices[i]->n, matrices[i]->matrix, matrices[i]->vec,
				  gpu_result64, 64);

		printf("[Threads per block 128]");
		gpu_solve(matrices[i]->m, matrices[i]->n, matrices[i]->matrix, matrices[i]->vec,
				  gpu_result128, 128);

		if (!(arrays_are_equal(matrices[i]->m, cpu_result, gpu_result32) &&
			  arrays_are_equal(matrices[i]->m, cpu_result, gpu_result64) &&
			  arrays_are_equal(matrices[i]->m, cpu_result, gpu_result128)))
		{
			printf("Matrices not equal\n");
			return 1;
		}
	}

	printf("Result of cpu == gpu\n");

	free(cpu_result);
	free(gpu_result32);
	free(gpu_result64);
	free(gpu_result128);

	for (size_t i = 0; i < MATRICES_N; i++)
	{
		free(matrices[i]->matrix);
		free(matrices[i]->vec);
	}

	return 0;
}
