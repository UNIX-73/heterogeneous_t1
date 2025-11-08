#!/bin/bash
#SBATCH --job-name=heterogeneous_cuda
#SBATCH --output=job_results.out
#SBATCH --error=job_results.err
#SBATCH --time=00:02:00
#SBATCH --cpus-per-task=32
#SBATCH --gres=gpu:1
#SBATCH --mem=1G

./t1