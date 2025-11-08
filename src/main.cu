#include <init.h>
#include <solvers.h>
#include <stddef.h>
#include <stdio.h>

int main()
{
	alloc_matrices();

	for (size_t i = 0; i < MATRICES_N; i++)
	{
		float cpu_result[matrices[i]->m];
		float gpu_result[matrices[i]->m];

		printf("%ld\n", i);

		cpu_solve(matrices[i]->m, matrices[i]->n, matrices[i]->matrix, matrices[i]->vec,
				  cpu_result);

		gpu_solve(matrices[i]->m, matrices[i]->n, matrices[i]->matrix, matrices[i]->vec,
				  gpu_result);

		if (!equal_matrices(matrices[i]->m, matrices[i]->n, cpu_result, gpu_result))
		{
			printf("Matrices not equal\n");
			return 1;
		}
	}

	printf("Result of cpu == gpu\n");

	return 0;
}
