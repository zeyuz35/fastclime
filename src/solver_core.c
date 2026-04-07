#include <stdlib.h>
#include <math.h>

#include "solver_core.h"

fc_solver_state_t* fc_solver_state_create(int m, int n, int nz) {
    fc_solver_state_t *state = (fc_solver_state_t*)FC_CALLOC(1, sizeof(fc_solver_state_t));
    state->m = m;
    state->n = n;
    state->N = m + n;
    
    state->primal_B = (double*)FC_CALLOC(m, sizeof(double));
    state->primal_B_bar = (double*)FC_CALLOC(m, sizeof(double));
    state->dual_N = (double*)FC_CALLOC(n, sizeof(double));
    state->dual_N_bar = (double*)FC_CALLOC(n, sizeof(double));
    
    state->primal_dx = (double*)FC_CALLOC(m, sizeof(double));
    state->primal_idx = (int*)FC_CALLOC(m, sizeof(int));
    state->dual_dy = (double*)FC_CALLOC(n, sizeof(double));
    state->dual_idy = (int*)FC_CALLOC(n, sizeof(int));
    
    state->basics = (int*)FC_CALLOC(m, sizeof(int));
    state->nonbasics = (int*)FC_CALLOC(n, sizeof(int));
    state->basicflag = (int*)FC_CALLOC(state->N, sizeof(int));
    
    state->at = (double*)FC_CALLOC(nz + m, sizeof(double));
    state->iat = (int*)FC_CALLOC(nz + m, sizeof(int));
    state->kat = (int*)FC_CALLOC(m + 1, sizeof(int));
    
    state->lu_ctx = fc_lu_create();
    
    state->vec = (double*)FC_CALLOC(state->N, sizeof(double));
    state->ivec = (int*)FC_CALLOC(state->N, sizeof(int));
    
    state->a_buf = (double*)FC_CALLOC(state->N, sizeof(double));
    state->tag_buf = (int*)FC_CALLOC(state->N, sizeof(int));
    
    int *link_orig = (int*)FC_CALLOC(state->N + 2, sizeof(int));
    state->link_buf = link_orig + 1;
    state->currtag = 1;

    return state;
}

void fc_solver_state_destroy(fc_solver_state_t *state) {
    if (!state) return;

    FC_FREE(state->primal_B);
    FC_FREE(state->primal_B_bar);
    FC_FREE(state->dual_N);
    FC_FREE(state->dual_N_bar);
    
    FC_FREE(state->primal_dx);
    FC_FREE(state->primal_idx);
    FC_FREE(state->dual_dy);
    FC_FREE(state->dual_idy);
    
    FC_FREE(state->basics);
    FC_FREE(state->nonbasics);
    FC_FREE(state->basicflag);
    
    FC_FREE(state->at);
    FC_FREE(state->iat);
    FC_FREE(state->kat);
    
    fc_lu_destroy(state->lu_ctx);
    
    FC_FREE(state->vec);
    FC_FREE(state->ivec);
    
    FC_FREE(state->a_buf);
    FC_FREE(state->tag_buf);
    
    if (state->link_buf) {
        int *orig = state->link_buf - 1;
        FC_FREE(orig);
    }
    
    FC_FREE(state);
}

void fc_simplex_find_mu(fc_solver_state_t *state, double *mu, int *col_in, int *col_out) {
    int i, j;
    *mu = -HUGE_VAL;
    *col_in = -1;
    
    for (j=0; j < state->n; j++) {
        if (state->dual_N_bar[j] > FC_EPS2) {
            if (*mu < -state->dual_N[j] / state->dual_N_bar[j]) {
                *mu = -state->dual_N[j] / state->dual_N_bar[j];
                *col_in = j;
            }
        }
    }
    
    *col_out = -1;
    for (i=0; i < state->m; i++) {
        if (state->primal_B_bar[i] > FC_EPS2) {
            if (*mu < -state->primal_B[i] / state->primal_B_bar[i]) {
                *mu = -state->primal_B[i] / state->primal_B_bar[i];
                *col_out = i;
                *col_in = -1;
            }
        }
    }
}

void fc_simplex_find_mu_primal_only(fc_solver_state_t *state, double *mu, int *col_out) {
    int i;
    *mu = -HUGE_VAL;
    *col_out = -1;
    for (i=0; i < state->m; i++) {
        if (state->primal_B_bar[i] > FC_EPS2) {
            if (*mu < -state->primal_B[i] / state->primal_B_bar[i]) {
                *mu = -state->primal_B[i] / state->primal_B_bar[i];
                *col_out = i;
            }
        }
    }
}

void fc_simplex_compute_dy(fc_solver_state_t *state, int col_out) {
    state->vec[0] = -1.0;
    state->ivec[0] = col_out;
    state->nvec = 1;

    fc_btsolve(state->lu_ctx, state->m, state->vec, state->ivec, &state->nvec);
    fc_Nt_times_y(state->N, state->at, state->iat, state->kat, state->basicflag, 
                  state->vec, state->ivec, state->nvec,
                  state->dual_dy, state->dual_idy, &state->dual_ndy,
                  state->a_buf, state->tag_buf, state->link_buf + 1, &state->currtag);
}

void fc_simplex_compute_dx(fc_solver_state_t *state, int col_in) {
    int i, k;
    int j = state->nonbasics[col_in];
    for (i=0, k=state->ka[j]; k<state->ka[j+1]; i++, k++) {
        state->primal_dx[i] = state->a[k];
        state->primal_idx[i] = state->ia[k];
    }
    state->primal_ndx = i;
    fc_bsolve(state->lu_ctx, state->m, state->primal_dx, state->primal_idx, &state->primal_ndx);
}

int fc_simplex_ratio_test(double *step_dir, int *step_idx, int step_len, double *vars, double *vars_bar, double mu) {
    int j, jj = -1, k;
    double min_ratio = HUGE_VAL;

    for (k=0; k<step_len; k++) {
        if (step_dir[k] > FC_EPS1) {
            j = step_idx[k];
            
            double num = vars[j];
            if (vars_bar) {
                num += mu * vars_bar[j];
            }
            
            if (num / step_dir[k] < min_ratio) {
                min_ratio = num / step_dir[k];
                jj = j;
            }
        }
    }
    return jj;
}

void fc_simplex_update_vars(fc_solver_state_t *state, int col_in, int col_out) {
    int k, i, j;
    double t = 0.0, tbar = 0.0, s = 0.0, sbar = 0.0;
    
    for (k=0; k < state->primal_ndx; k++) {
        if (state->primal_idx[k] == col_out) break;
    }
    t = state->primal_B[col_out] / state->primal_dx[k];
    if (state->primal_B_bar) tbar = state->primal_B_bar[col_out] / state->primal_dx[k];

    for (k=0; k < state->dual_ndy; k++) {
        if (state->dual_idy[k] == col_in) break;
    }
    s = state->dual_N[col_in] / state->dual_dy[k];
    if (state->dual_N_bar) sbar = state->dual_N_bar[col_in] / state->dual_dy[k];

    for (k=0; k < state->dual_ndy; k++) {
        j = state->dual_idy[k];
        state->dual_N[j] -= s * state->dual_dy[k];
        if (state->dual_N_bar) state->dual_N_bar[j] -= sbar * state->dual_dy[k];
    }
    state->dual_N[col_in] = s;
    if (state->dual_N_bar) state->dual_N_bar[col_in] = sbar;

    for (k=0; k < state->primal_ndx; k++) {
        i = state->primal_idx[k];
        state->primal_B[i] -= t * state->primal_dx[k];
        if (state->primal_B_bar) state->primal_B_bar[i] -= tbar * state->primal_dx[k];
    }
    state->primal_B[col_out] = t;
    if (state->primal_B_bar) state->primal_B_bar[col_out] = tbar;
}

void fc_simplex_update_basis(fc_solver_state_t *state, int col_in, int col_out) {
    int i = state->basics[col_out];
    int j = state->nonbasics[col_in];
    state->basics[col_out] = j;
    state->nonbasics[col_in] = i;
    state->basicflag[i] = -col_in - 1;
    state->basicflag[j] = col_out;
}
