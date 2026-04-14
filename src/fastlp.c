#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <R.h>

#include "solver_core.h"

void fastlp(double *obj, double *mat, double *rhs, int *m0 , int *n0, double *opt, int *status, double *lambda)
{
    int m = *m0;
    int n = *n0;
    int nz = 0;
    int i, j, k; 
    double lambda_val = *lambda;

    if (lambda_val <= FC_EPS3) {
        lambda_val = FC_EPS3;
    }

    // Determine non-zeros in dense input matrix (same as old)
    for (j=0; j<n; j++) {
        for (i=0; i<m; i++) {
            if (mat[i*n+j] != 0.0) {
                nz++;
            }
        }
    }

    fc_solver_state_t *state = fc_solver_state_create(m, n, nz);
    
    // Arrays strictly built by driver:
    int *ia = (int*)FC_CALLOC(nz + m, sizeof(int));
    int *ka = (int*)FC_CALLOC(n + m + 1, sizeof(int));
    double *a = (double*)FC_CALLOC(nz + m, sizeof(double));

    k = 0;
    for (j=0; j<n; j++) {
        ka[j] = k; 
        for (i=0; i<m; i++) {
            if (mat[i*n+j] != 0.0) {
                a[k] = mat[i*n+j];
                ia[k] = i;
                k++;
            }    
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

    // Initialization
    for (j=0; j<n; j++) {
        state->nonbasics[j] = j;
        state->basicflag[j] = -j-1;
        state->dual_N[j] = -obj[j];
        state->dual_N_bar[j] = 1.0;
    }

    for (i=0; i<m; i++) {
        state->basics[i] = n+i;
        state->basicflag[n+i] = i;
        state->primal_B[i] = rhs[i];
        state->primal_B_bar[i] = 1.0;
    }

    fc_lufac(state->lu_ctx, m, state->ka, state->ia, state->a, state->basics, 0);

    int iter;
    for (iter=0; iter < 1000000; iter++) {
        double mu;
        int col_in, col_out;

        fc_simplex_find_mu(state, &mu, &col_in, &col_out);

        if (mu <= lambda_val) {
            *status = 0;       
            break;
        }

        if (col_out >= 0) {
            fc_simplex_compute_dy(state, col_out);
            col_in = fc_simplex_ratio_test(state->dual_dy, state->dual_idy, state->dual_ndy, 
                                           state->dual_N, state->dual_N_bar, mu);
            if (col_in == -1) { 
                *status = 1;
                break;
            }
            fc_simplex_compute_dx(state, col_in);
        } else {
            fc_simplex_compute_dx(state, col_in);
            col_out = fc_simplex_ratio_test(state->primal_dx, state->primal_idx, state->primal_ndx, 
                                            state->primal_B, state->primal_B_bar, mu);
            if (col_out == -1) {
                *status = 2;
                break;
            }
            fc_simplex_compute_dy(state, col_out);
        }

        fc_simplex_update_vars(state, col_in, col_out);
        fc_simplex_update_basis(state, col_in, col_out);
        fc_refactor(state->lu_ctx, m, state->ka, state->ia, state->a, state->basics, col_out, 0);
    }
    
    if (iter >= 1000000) {
        *status = 1;
    }

    double *x_local = (double*)FC_CALLOC(state->N, sizeof(double));
    for (i=0; i<m; i++) {
        x_local[state->basics[i]] = state->primal_B[i];
    }

    for (i=0; i<n; i++) {
        opt[i] = x_local[i];
    }
    FC_FREE(x_local);

    fc_solver_state_destroy(state);
    
    FC_FREE(a);
    FC_FREE(ia);
    FC_FREE(ka);
}
