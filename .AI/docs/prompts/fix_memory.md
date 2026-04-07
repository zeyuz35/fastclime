# Fix fastclime memory issues

You are tasked with fixing the `fastclime` R package, which is experiencing memory issues. 
The source code is the working directory, and is confirmed to compile without errors. 

Specifically, /scratch/fastclime_cv_loop.R and /scratch/fastclime_cv_loop_real.R are two scripts, using synthetic, and real data, respectively. 
These rely on some thin wrappers around the main fastclime package, located in /scratch/CLIME.R.
When the fast_cv_loop_real.R script is run via Rscript, there is a free(): invalid pointer errior.

The memory issue only occurs on the real data for some reason, despite both the synthetic and real data being processed in a similar manner, and being of similar dimensions. 

If you need to create any new files, place them in /tmp/.

Both datasets are already confirmed to be finite, and not contain any missing data. 
Both datasets are first converted to matrices first. 

Note that `pryr` is outdated, and has been replaced by the `rlang`, `lobstr`, and `sloop` packages in terms of functionality related to memory profiling and object size inspection.

# fastclime.selector error

Someone else has fixed some free(): invalid pointer errors in the fastclime package, which occured only on fastclime_cv_loop_real.R.

However, there is now a seemingly separate issue with the fastclime.selector function. 

Your task is to investigate and fix this issue.

Note that the although the real data is read in as an xts, it is converted to a matrix before being passed to any fastclime functions. 

The issue is isolated to the functions in the fastclime functions, DO NOT modify any of the wrapper functions in CLIME.R.