#include <init.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

declare_matrix_and_vec(2000, 4000);
declare_matrix_and_vec(4000, 2000);
declare_matrix_and_vec(10000, 40000);
declare_matrix_and_vec(40000, 10000);

MatrixAndVec *matrices[MATRICES_N] = {
	&m_2000_4000,
	&m_4000_2000,
	&m_10000_40000,
	&m_40000_10000,
};

void alloc_matrices()
{

	srand(123812930);
	for (size_t i = 0; i < MATRICES_N; i++)
	{
		size_t matrix_size = matrices[i]->m * matrices[i]->n;
		size_t vec_size = matrices[i]->n;

		matrices[i]->matrix = (float *)malloc(sizeof(float) * matrix_size);
		matrices[i]->vec = (float *)malloc(sizeof(float) * vec_size);

		for (size_t j = 0; j < matrix_size; j++)
			matrices[i]->matrix[j] = (float)rand();

		for (size_t k = 0; k < vec_size; k++)
			matrices[i]->vec[k] = (float)rand();
	}

	printf("Matrices allocated\n");
}