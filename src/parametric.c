#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <R.h>

#include "solver_core.h"

void solver2(
    int m,
    int n,
    int nz,
    int *ia, 
    int *ka, 
    double *a,
    double *b, 
    double *c,
    double *lambdamin,
    int *maxnlambda,
    double *mu_input,
    double *iicov,
    int col_num_val,
    int N_val,
    int lambda_val,
    int *max_row_iter_p
);

void parametric(double *SigmaInput, int *m1, double *mu_input, double *lambdamin, int *nlambda, int *maxnlambda, double *iicov)
{
    int m, n, nz;
    int *ia, *ka;
    double *a, *b, *c;
    double **LMATRIX;
    int i, j, k;
    int m0 = *m1;
    int lambda_val = *nlambda;
    int *max_row_iter_p = (int*)FC_CALLOC(m0, sizeof(int));
    int N_val;

    m = 2*m0;
    n = 2*m0;
    nz = 0;
    N_val = m+n;

    LMATRIX = (double**)FC_CALLOC(m, sizeof(double*));
    for (i=0; i<m; i++) {
        LMATRIX[i] = (double*)FC_CALLOC(n, sizeof(double));
    }

    for (i=0; i<m0; i++){
        for (j=0; j<m0; j++){
            LMATRIX[i][j]       =  SigmaInput[i*m0+j];
            LMATRIX[i+m0][j]    = -SigmaInput[i*m0+j];
            LMATRIX[i][j+m0]    = -SigmaInput[i*m0+j];
            LMATRIX[i+m0][j+m0] =  SigmaInput[i*m0+j];
            if (SigmaInput[i*m0+j] != 0.0) {
                nz += 4;
            }
        }
    }

    a  = (double*)FC_CALLOC(nz+m, sizeof(double));
    ia = (int*)FC_CALLOC(nz+m, sizeof(int));
    ka = (int*)FC_CALLOC(n+m+1, sizeof(int));
    c  = (double*)FC_CALLOC(n+m, sizeof(double));      

    for (i = 0; i < n; i++) {
        c[i] = -1.0;    
    }

    // Form sparse matrix A
    k = 0;
    for (j = 0; j < n; j++) {
        ka[j] = k;
        for (i = 0; i < m; i++) {
            if (LMATRIX[i][j] != 0.0) {
                a[k] = LMATRIX[i][j];
                ia[k] = i;
                k++;
            }
        }
    }
    ka[n] = k;

    for (i = 0; i < m; i++){
        FC_FREE(LMATRIX[i]);
    }
    FC_FREE(LMATRIX);

    // Add slack variables
    i = 0;
    for (j = n; j < N_val; j++) {
        a[k] = 1.0;
        ia[k] = i;
        i++;
        k++;
        ka[j+1] = k;
    }
    nz = k;

    for (int col_idx = 0; col_idx < m0; col_idx++){
        b = (double*)FC_CALLOC(m, sizeof(double));  

        b[col_idx] = 1.0;
        b[col_idx+m0] = -1.0;
    
        // Solve parametrically
        solver2(m, n, nz, ia, ka, a, b, c, lambdamin, maxnlambda, mu_input, iicov, col_idx, N_val, lambda_val, max_row_iter_p);
        
        FC_FREE(b);
    }
      
    for (j = 0; j < m0*m0; j++){
        for (i = 1; i < lambda_val; i++){
            if (i > max_row_iter_p[j/m0]){
                iicov[j*lambda_val+i] = iicov[j*lambda_val+i-1];                
            }            
        }
    }
    
    FC_FREE(a);
    FC_FREE(ia);
    FC_FREE(ka);
    FC_FREE(c);
    FC_FREE(max_row_iter_p);
}


void solver2(
    int m, int n, int nz, int *ia, int *ka, double *a, double *b, double *c,
    double *lambdamin, int *maxnlambda, double *mu_input, double *iicov,
    int col_num_val, int N_val, int lambda_val, int *max_row_iter_p
) {
    int i, j;
    int iter = 0;
    
    fc_solver_state_t *state = fc_solver_state_create(m, n, nz);

    FC_FREE(state->dual_N_bar);
    state->dual_N_bar = NULL;

    state->a = a;
    state->ia = ia;
    state->ka = ka;
    
    fc_atnum(m, N_val, state->ka, state->ia, state->a, state->kat, state->iat, state->at);    

    for (j=0; j<n; j++) {
        state->nonbasics[j] = j;
        state->basicflag[j] = -j-1;
        state->dual_N[j] = -c[j];  
    }

    for (i=0; i<m; i++) {
        state->basics[i] = n+i;
        state->basicflag[n+i] = i;
        state->primal_B[i] = b[i];
        state->primal_B_bar[i] = 1.0;
    }

    fc_lufac(state->lu_ctx, m, state->ka, state->ia, state->a, state->basics, 0);

    double *output_vec = (double*)FC_CALLOC(N_val, sizeof(double));

    for (iter = 0; iter < lambda_val; iter++) {

        if (iter > *maxnlambda) {
            *maxnlambda = iter;
        }

        double mu;
        int col_out, col_in;

        fc_simplex_find_mu_primal_only(state, &mu, &col_out);
        
        mu_input[lambda_val*col_num_val+iter] = mu;
        
        memset(output_vec, 0, N_val * sizeof(double));

        for (i=0; i<m; i++) {
            output_vec[state->basics[i]] = state->primal_B[i] + mu*state->primal_B_bar[i];
        }

        for (i=0; i < m/2; i++) {        
            if (fabs(output_vec[i] - output_vec[i+m/2]) > FC_EPS3) {
                iicov[col_num_val * lambda_val * (m/2) + i * lambda_val + iter] = output_vec[i] - output_vec[i+m/2]; 
            }
        }
        
        if (mu <= *lambdamin) {  
            break;
        }

        if (mu <= FC_EPS3) { 
            break;
        }

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
     
    max_row_iter_p[col_num_val] = iter;

    FC_FREE(output_vec);
    
    // We don't own a, ia, ka in this driver helper
    state->a = NULL;
    state->ia = NULL;
    state->ka = NULL;

    fc_solver_state_destroy(state);
}
