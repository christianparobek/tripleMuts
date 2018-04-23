#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --time=10-0

sbatch -t 10-0 --wrap "snakemake -s snalumper-jess.py --cluster 'sbatch -t 10-0' --jobs 3"
***OR***
srun snakemake -s snalumper-jess.py --cluster 'sbatch -t 10-0' --jobs 3
