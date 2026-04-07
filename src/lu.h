#ifndef FASTCLIME_LU_H
#define FASTCLIME_LU_H

#include "memory.h"
#include "config.h"
#include "tree.h"

#define FC_E_N 200
#define FC_E_NZ 20000
#define FC_LARGE 100000

#define FC_EPS    1.0e-14
#define FC_EPSSOL 1.0e-5
#define FC_EPSNUM 1.0e-9
#define FC_NOREORD 0
#define FC_MD  1


struct lufac_valind {
    double d;
    int    i;
};
typedef struct lufac_valind FC_VALIND;

typedef struct {
    int m;
    
    int rank;
    int *kL, *iL, *kLt, *iLt;
    int *kU, *iU, *kUt, *iUt;
    int *colperm, *icolperm, *rowperm, *irowperm;
    double *L, *Lt, *U, *Ut, *diagU;
    
    int *E_d;
    double *E;
    int *iE;
    int *kE;
    int e_iter;
    int enz;
    
    double cumtime;
    double ocumtime;
    
    // Persistent work buffers
    double *y_bsolve;
    int *tag_bsolve;
    int currtag_bsolve;
    
    double *y_btsolve;
    int *tag_btsolve;
    int currtag_btsolve;
    
    double *a_geta;
    int *tag_geta;
    int *link_geta;
    int currtag_geta;
    
    double *a_getat;
    int *tag_getat;
    int currtag_getat;
    
    fc_tree_t tree;
} fc_lu_context_t;

// Lifecycle
fc_lu_context_t* fc_lu_create(void);
void fc_lu_destroy(fc_lu_context_t *ctx);

// Main operations
void fc_refactor(fc_lu_context_t *ctx, int m, int *kA, int *iA, double *A, int *basics, int col_out, int v);
void fc_lufac(fc_lu_context_t *ctx, int m, int *kA, int *iA, double *A, int *basis, int v);

int fc_bsolve(fc_lu_context_t *ctx, int m, double *sy, int *iy, int *pny);
int fc_btsolve(fc_lu_context_t *ctx, int m, double *sy, int *iy, int *pny);
int fc_dbsolve(fc_lu_context_t *ctx, int m, double *y);

void fc_Gauss_Eta(fc_lu_context_t *ctx, int m, double *dx_B, int *idx_B, int *pndx_B);
void fc_Gauss_Eta_T(fc_lu_context_t *ctx, int m, double *vec, int *ivec, int *pnvec);

#endif // FASTCLIME_LU_H
