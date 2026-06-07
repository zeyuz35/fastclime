#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <R.h>

#include "solver_core.h"

void dantzig(double *X2, double *Xy, double *BETA0, int *d0, 
             double *lambda, int *nlambda, double *lambdalist)
{
    int m, n, nz;
    if (*d0 > 23170) { error("Dimension d too large, integer overflow risk in allocation"); }
    int i, j, k, d;

    d = *d0;         
    m = 2*d;
    n = 2*d;
    nz = m*n;

    fc_solver_state_t *state = fc_solver_state_create(m, n, nz);

    // dantzig dual perturbation is omitted
    FC_FREE(state->dual_N_bar);
    state->dual_N_bar = NULL;

    int *ia = (int*)FC_CALLOC(nz + m, sizeof(int));
    int *ka = (int*)FC_CALLOC(n + m + 1, sizeof(int));
    double *a = (double*)FC_CALLOC(nz + m, sizeof(double));

    // Form sparse matrix
    k = 0;
    for (j=0; j<n; j++) {
        ka[j] = k;
        for (i=0; i<m; i++) {
            if (i<d && j<d) {
                a[k] = X2[i*d+j];
            } else if (i<d && j>=d) {
                a[k] = -X2[i*d+j-d];
            } else if(i>=d && j<d) {
                a[k] = -X2[(i-d)*d+j];
            } else {
                a[k] =  X2[(i-d)*d+j-d];
            }
            ia[k] = i;
            k++;
        }
    }
    ka[n] = k;
    
    // Add slack variables to matrix
    i = 0;
    k = ka[n];
    for (j=n; j<state->N; j++) {  
        a[k] = 1.0;
        ia[k] = i;
        i++;
        k++;
        ka[j+1] = k;
    }
    nz = k;

    state->a = a;
    state->ia = ia;
    state->ka = ka;

    fc_atnum(m, state->N, state->ka, state->ia, state->a, state->kat, state->iat, state->at);  

    for (j=0; j<n; j++) {
        state->nonbasics[j] = j;
        state->basicflag[j] = -j-1;
        state->dual_N[j] = 1.0; 
    }

    for (i=0; i<m; i++) {
        state->basics[i] = n+i;
        state->basicflag[n+i] = i;
        state->primal_B_bar[i] = 1.0;
    }

    for (i=0; i<d; i++) {
        state->primal_B[i]   =  Xy[i];
        state->primal_B[i+d] = -Xy[i];
    }

    fc_lufac(state->lu_ctx, m, state->ka, state->ia, state->a, state->basics, 0);

    double *output_vec = (double*)FC_CALLOC(state->N, sizeof(double));

    int iter;
    // Main loop of PSM in the solver
    for (iter=0; iter<*nlambda; iter++) {
        memset(output_vec, 0, state->N * sizeof(double));
        
        double mu;
        int col_out;
        fc_simplex_find_mu_primal_only(state, &mu, &col_out);

        lambdalist[iter] = mu;
        
        for (i=0; i<m; i++){
            output_vec[state->basics[i]] = state->primal_B[i] + mu * state->primal_B_bar[i];
        }

        for (i=0; i<m/2; i++){
            if (fabs(output_vec[i] - output_vec[i+m/2]) > FC_EPS3) {
                BETA0[m/2*iter+i] = output_vec[i] - output_vec[i+m/2];           
            }
        }

        if (mu <= *lambda) {
            break;
        }

        int col_in;
        fc_simplex_compute_dy(state, col_out);
        col_in = fc_simplex_ratio_test(state->dual_dy, state->dual_idy, state->dual_ndy, 
                                       state->dual_N, state->dual_N_bar, mu);
        if (col_in == -1) {   
            break;
        }

        fc_simplex_compute_dx(state, col_in);
        fc_simplex_update_vars(state, col_in, col_out);
        fc_simplex_update_basis(state, col_in, col_out);
        fc_refactor(state->lu_ctx, m, state->ka, state->ia, state->a, state->basics, col_out, 0);
    }

    FC_FREE(output_vec);
    fc_solver_state_destroy(state);

    FC_FREE(a);
    FC_FREE(ia);
    FC_FREE(ka);
}
