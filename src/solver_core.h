#ifndef FASTCLIME_SOLVER_CORE_H
#define FASTCLIME_SOLVER_CORE_H

#include <math.h>
#include "config.h"
#include "memory.h"
#include "lu.h"
#include "linalg.h"

// Core State Structure for Simplex Method
typedef struct {
    int m;
    int n;
    int N;
    
    // Core parameters (primal and dual variables and perturbations)
    double *primal_B;
    double *primal_B_bar;
    double *dual_N;
    double *dual_N_bar;
    
    // Step directions
    double *primal_dx;
    int *primal_idx;
    int primal_ndx;
    
    double *dual_dy;
    int *dual_idy;
    int dual_ndy;
    
    // Active sets
    int *basics;
    int *nonbasics;
    int *basicflag;
    
    // Sparse input formulation
    int *ka;
    int *ia;
    double *a;
    
    // Transposed sparse input
    int *kat;
    int *iat;
    double *at;

    // LU factorization context
    fc_lu_context_t *lu_ctx;
    
    // Computation workspaces
    double *vec;
    int *ivec;
    int nvec;
    
    double *a_buf;
    int *tag_buf;
    int *link_buf;
    int currtag;
    
} fc_solver_state_t;

// Lifecycle
fc_solver_state_t* fc_solver_state_create(int m, int n, int nz);
void fc_solver_state_destroy(fc_solver_state_t *state);

// Simplex algorithmic Steps
// Step 1: Find mu, entering and leaving columns
void fc_simplex_find_mu(fc_solver_state_t *state, double *mu, int *col_in, int *col_out);
// For Dantzig, we only use primal ratio for mu
void fc_simplex_find_mu_primal_only(fc_solver_state_t *state, double *mu, int *col_out);

// Step 2 & 4: Compute step direction limits
void fc_simplex_compute_dy(fc_solver_state_t *state, int col_out);
void fc_simplex_compute_dx(fc_solver_state_t *state, int col_in);

// Step 3: Ratio tests
int fc_simplex_ratio_test(double *step_dir, int *step_idx, int step_len, double *vars, double *vars_bar, double mu);

// Step 5 & 6 & 7: Update dual and primal variables
void fc_simplex_update_vars(fc_solver_state_t *state, int col_in, int col_out);

// Step 8: Update basis structures
void fc_simplex_update_basis(fc_solver_state_t *state, int col_in, int col_out);

#endif // FASTCLIME_SOLVER_CORE_H
