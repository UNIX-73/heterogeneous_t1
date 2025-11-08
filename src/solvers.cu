#include <math.h>
#include <solvers.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#ifdef MEASURE_TIME
#include <chrono>
using namespace std::chrono;
using namespace std;
#endif

const float EPSILON = 0;

bool arrays_are_equal(size_t size, float *a, float *b)
{
	for (size_t i = 0; i < size; i++)
	{

		float diff = a[i] - b[i];

		if (fabs(diff) > EPSILON)
		{
			printf("NOT EQUAL: a(%f) b(%f)\n", a[i], b[i]);

			return false;
		}
	}

	return true;
}

void cpu_solve(size_t m, size_t n, float *matrix, float *vec, float *out)
{
#ifdef MEASURE_TIME
	auto start = high_resolution_clock::now();
#endif

	for (size_t row = 0; row < m; row++)
	{
		float result = 0.0;

		for (size_t col = 0; col < n; col++)
			result += matrix[row * n + col] * vec[col];

		out[row] = result;
	}

#ifdef MEASURE_TIME
	auto end = high_resolution_clock::now();
	printf("[CPU solve took] %.5f ms\n", duration<double, milli>(end - start).count());
#endif
}

__global__ void gpu_solve_kernel(size_t m, size_t n, float *matrix, float *vec, float *out)
{
	size_t row = blockIdx.x * blockDim.x + threadIdx.x;

	if (!(row < m))
		return;

	float result = 0.0;

	for (size_t col = 0; col < n; col++)
		result += matrix[row * n + col] * vec[col];

	out[row] = result;
}

void gpu_solve(size_t m, size_t n, float *matrix, float *vec, float *out, size_t blk_size)
{
#ifdef MEASURE_TIME

	cudaEvent_t alloc_start, alloc_end, total_start, total_end;
	cudaEventCreate(&alloc_start);
	cudaEventCreate(&alloc_end);
	cudaEventCreate(&total_start);
	cudaEventCreate(&total_end);
	cudaEventRecord(total_start);
	cudaEventRecord(alloc_start);
#endif

	size_t matrix_bytes = sizeof(float) * m * n;
	size_t vec_bytes = sizeof(float) * n;
	size_t out_bytes = sizeof(float) * m;

	float *gpu_matrix;
	float *gpu_vec;
	float *gpu_out;

	cudaMalloc((void **)&gpu_matrix, matrix_bytes);
	cudaMalloc((void **)&gpu_vec, vec_bytes);
	cudaMalloc((void **)&gpu_out, out_bytes);

	cudaMemcpy(gpu_matrix, matrix, matrix_bytes, cudaMemcpyHostToDevice);
	cudaMemcpy(gpu_vec, vec, vec_bytes, cudaMemcpyHostToDevice);

	dim3 block_dim(blk_size);
	dim3 grid_dim((m + block_dim.x - 1) / block_dim.x);

#ifdef MEASURE_TIME
	float alloc_elapsed;
	cudaEventRecord(alloc_end);
	cudaEventSynchronize(alloc_end);
	cudaEventElapsedTime(&alloc_elapsed, alloc_start, alloc_end);

	cudaEvent_t kernel_start, kernel_end;
	cudaEventCreate(&kernel_start);
	cudaEventCreate(&kernel_end);
	cudaEventRecord(kernel_start);
#endif

	gpu_solve_kernel<<<grid_dim, block_dim>>>(m, n, gpu_matrix, gpu_vec, gpu_out);

#ifdef MEASURE_TIME
	float kernel_elapsed;
	cudaEventRecord(kernel_end);
	cudaEventSynchronize(kernel_end);
	cudaEventElapsedTime(&kernel_elapsed, kernel_start, kernel_end);
#endif

	cudaMemcpy(out, gpu_out, out_bytes, cudaMemcpyDeviceToHost);

	cudaFree(gpu_matrix);
	cudaFree(gpu_vec);
	cudaFree(gpu_out);

#ifdef MEASURE_TIME
	float total_elapsed;
	cudaEventRecord(total_end);
	cudaEventSynchronize(total_end);
	cudaEventElapsedTime(&total_elapsed, total_start, total_end);
	printf("[GPU solve fn took] %.5f ms (alloc: %.5f ms, kernel: %.5f ms) \n", total_elapsed,
		   alloc_elapsed, kernel_elapsed);
#endif
}